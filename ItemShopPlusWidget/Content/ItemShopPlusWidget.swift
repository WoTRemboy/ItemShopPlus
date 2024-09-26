//
//  ItemShopPlusWidget.swift
//  ItemShopPlusWidget
//
//  Created by Roman Tverdokhleb on 7/31/24.
//

import WidgetKit
import SwiftUI
import UIKit

struct Provider: TimelineProvider {
    private let networkService = WidgetNetworkService()
    
    func placeholder(in context: Context) -> ShopEntry {
        ShopEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ShopEntry) -> ()) {
        Task {
            do {
                let items = try await fetchShopItems()
                let newItem = items.filter({ $0.banner == .new }).max(by: { $0.price < $1.price }) ?? items.max(by: { $0.previousReleaseDate < $1.previousReleaseDate }) ?? .emptyShopItem
                
                downloadImage(for: newItem) { image in
                    let entry = ShopEntry(date: Date(), shopItem: newItem, image: image)
                    completion(entry)
                }
            } catch {
                print("Failed to load snapshot data: \(error)")
                let entry = ShopEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
                completion(entry)
            }
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ShopEntry>) -> ()) {
        networkService.getShopItems { result in
            switch result {
            case .success(let items):
                if let newItem = items.filter({ $0.banner == .new }).randomElement() {
                    downloadImage(for: newItem) { downloadedImage in
                        let entry = ShopEntry(date: Date(), shopItem: newItem, image: downloadedImage)
                        let timeline = Timeline(entries: [entry], policy: .atEnd)
                        completion(timeline)
                    }
                    
                } else if let maxDate = items.max(by: { $0.previousReleaseDate < $1.previousReleaseDate })?.previousReleaseDate,
                          let mostNewItem = items.filter({ $0.previousReleaseDate == maxDate }).randomElement() {
                    
                    downloadImage(for: mostNewItem) { downloadedImage in
                        let entry = ShopEntry(date: Date(), shopItem: mostNewItem, image: downloadedImage)
                        let timeline = Timeline(entries: [entry], policy: .atEnd)
                        completion(timeline)
                    }
                    
                } else {
                    let entry = ShopEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                }
                
            case .failure(let error):
                print("Failed to load items: \(error)")
                let entry = ShopEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }
    
    private func fetchShopItems() async throws -> [WidgetShopItem] {
        return try await withCheckedThrowingContinuation { continuation in
            networkService.getShopItems { result in
                switch result {
                case .success(let items):
                    continuation.resume(returning: items)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func downloadImage(for item: WidgetShopItem, completion: @escaping (UIImage?) -> Void) {
        guard URL(string: item.image) != nil else {
            completion(nil)
            return
        }
        
        let _ = ImageLoader.loadImage(urlString: item.image, size: CGSize(width: 300, height: 300)) { image in
            completion(image)
        }
    }
}

struct ItemShopPlusWidgetEntryView: View {
    internal var entry: Provider.Entry
    
    internal var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            itemIconAndBanner
            itemNamePrice
        }
        .widgetBackground(Color.backDefault)
    }
    
    private var itemIconAndBanner: some View {
        HStack(alignment: .top) {
            if let image = entry.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .scaledToFit()
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            
            VStack {
                Image.Widget.appIcon
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 3))
                    .frame(width: 20)
                
                if entry.shopItem.banner == .new {
                    Image.Widget.newBanner
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                }
            }
        }
    }
    
    private var itemNamePrice: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(!entry.shopItem.name.isEmpty ?
                 entry.shopItem.name :
                    Texts.Widget.placeholderName)
            .lineLimit(1)
            .font(.system(size: 15, weight: .light))
            .padding(.top, 8)
            
            itemPrice
                .padding(.top, 2)
        }
    }
    
    private var itemPrice: some View {
        HStack(spacing: 3) {
            Image.Widget.vBucks
                .resizable()
                .scaledToFit()
                .frame(width: 15)
            
            Text(entry.shopItem.price != -100 ?
                 String(entry.shopItem.price) :
                    Texts.Widget.placeholderName)
                .lineLimit(1)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.labelPrimary)
        }
    }
}

struct ItemShopPlusWidget: Widget {
    let kind: String = "ItemShopPlusWidget"
    
    internal var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ItemShopPlusWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ItemShopPlusWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName(Texts.Widget.displayName)
        .description(Texts.Widget.description)
        .supportedFamilies([.systemSmall])
    }
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

struct ItemShopPlusWidget_Previews: PreviewProvider {
    static var previews: some View {
        ItemShopPlusWidgetEntryView(entry: ShopEntry(date: .now, shopItem: .mockShopItem, image: .Widget.mockItem))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
