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
    
    func placeholder(in context: Context) -> StatsEntry {
        StatsEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StatsEntry) -> ()) {
        let entry = StatsEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StatsEntry>) -> ()) {
        networkService.getShopItems { result in
            switch result {
            case .success(let items):
                if let newItem = items.filter({ $0.banner == .new }).max(by: { $0.price < $1.price }) {
                    downloadImage(for: newItem) { downloadedImage in
                        let futureDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
                        let entry = StatsEntry(date: Date(), shopItem: newItem, image: downloadedImage)
                        let timeline = Timeline(entries: [entry], policy: .after(futureDate))
                        completion(timeline)
                    }
                    
                } else if let mostExpensiveItem = items.max(by: { $0.price < $1.price && $0.previousReleaseDate > $1.previousReleaseDate }) {
                    downloadImage(for: mostExpensiveItem) { downloadedImage in
                        let futureDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
                        let entry = StatsEntry(date: Date(), shopItem: mostExpensiveItem, image: downloadedImage)
                        let timeline = Timeline(entries: [entry], policy: .after(futureDate))
                        completion(timeline)
                    }
                    
                } else {
                    let futureDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
                    let entry = StatsEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
                    let timeline = Timeline(entries: [entry], policy: .after(futureDate))
                    completion(timeline)
                }
                
            case .failure(let error):
                print("Failed to load items: \(error)")
                let entry = StatsEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }
    
    private func downloadImage(for item: WidgetShopItem, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: item.image) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}

struct StatsEntry: TimelineEntry {
    let date: Date
    let shopItem: WidgetShopItem
    let image: UIImage?
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
                Image.Widget.placeholder
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Spacer()
            
            if entry.shopItem.banner == .new {
                Image.Widget.newBanner
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
            }
        }
    }
    
    private var itemNamePrice: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(!entry.shopItem.name.isEmpty ? entry.shopItem.name : Texts.Widget.placeholderName)
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
            
            Text(String(entry.shopItem.price))
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
        ItemShopPlusWidgetEntryView(entry: StatsEntry(date: .now, shopItem: .emptyShopItem, image: .Placeholder.noImage))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
