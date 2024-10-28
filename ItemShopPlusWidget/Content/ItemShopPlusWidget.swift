//
//  ItemShopPlusWidget.swift
//  ItemShopPlusWidget
//
//  Created by Roman Tverdokhleb on 7/31/24.
//

import WidgetKit
import SwiftUI
import UIKit
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "WidgetTarget", category: "MainModule")

// MARK: - Provider

/// A timeline provider responsible for managing and updating the content for the widget
struct Provider: TimelineProvider {
    
    /// A service for handling network requests to fetch shop items
    private let networkService = WidgetNetworkService()
    
    /// Placeholder data for when the widget is loading or unavailable
    /// - Parameter context: The current widget context
    /// - Returns: A `ShopEntry` with placeholder data
    func placeholder(in context: Context) -> ShopEntry {
        ShopEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
    }
    
    /// Provides a snapshot of the widget content
    /// - Parameters:
    ///   - context: The current widget context
    ///   - completion: A closure that handles the generated snapshot
    ///
    /// Retrieves the current shop items and selects the most relevant item to display, either the newest or most recently released item. It also downloads the corresponding image
    func getSnapshot(in context: Context, completion: @escaping (ShopEntry) -> ()) {
        Task {
            do {
                let items = try await fetchShopItems()
                let newItem = items.filter({ $0.banner == .new }).max(by: { $0.price < $1.price }) ?? items.max(by: { $0.previousReleaseDate < $1.previousReleaseDate }) ?? .emptyShopItem
                
                // Download the corresponding image for the selected shop item
                downloadImage(for: newItem) { image in
                    logger.info("Snaplshot image downloaded")
                    let entry = ShopEntry(date: Date(), shopItem: newItem, image: image)
                    completion(entry)
                }
            } catch {
                logger.error("Failed to load snapshot data: \(error)")
                let entry = ShopEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
                completion(entry)
            }
        }
    }
    
    /// Provides a timeline of widget entries
    /// - Parameters:
    ///   - context: The current widget context
    ///   - completion: A closure that handles the generated timeline
    ///
    /// Fetches shop items and updates the widget timeline based on the most recent or highlighted items
    func getTimeline(in context: Context, completion: @escaping (Timeline<ShopEntry>) -> ()) {
        networkService.getShopItems { result in
            switch result {
            case .success(let items):
                // Check for the most relevant shop item based on banners or release dates
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
                    // Provide a default empty entry if no items are available
                    let entry = ShopEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                }
                logger.info("Shop item loaded successfully")
            case .failure(let error):
                // Log the error and create a placeholder entry
                logger.error("Failed to load items: \(error)")
                let entry = ShopEntry(date: Date(), shopItem: .emptyShopItem, image: .Placeholder.noImage)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }
    
    /// Asynchronously fetches shop items using the network service
    /// - Returns: An array of `WidgetShopItem`
    /// - Throws: Throws an error if the fetching process fails
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
    
    /// Downloads the image for a specific shop item
    /// - Parameters:
    ///   - item: The `WidgetShopItem` for which the image needs to be downloaded
    ///   - completion: A closure that handles the downloaded image
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

// MARK: - ItemShopPlusWidgetEntryView

/// A view that defines the layout and design of the widget
struct ItemShopPlusWidgetEntryView: View {
    
    /// The entry data for the widget
    internal var entry: Provider.Entry
    
    /// The body of the widget view
    ///
    /// Сonsists of two main sections: an image/banner display and the shop item's name and price. The layout is structured vertically with padding and background styling
    internal var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            itemIconAndBanner
            itemNamePrice
        }
        .widgetBackground(Color.backDefault)
    }
    
    /// Displays the item's image and banner
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
    
    /// Displays the item's name and price
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
    
    /// Displays the item's price with an image of VBucks currency
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

// MARK: - ItemShopPlusWidget

/// The main widget structure defining the widget type and configuration
struct ItemShopPlusWidget: Widget {
    
    /// The unique kind identifier for the widget
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

// MARK: - WidgetBackground Extension

extension View {
    /// Provides different widget backgrounds depending on the iOS version
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

// MARK: - Preview

struct ItemShopPlusWidget_Previews: PreviewProvider {
    /// Displays a mock version of the widget for preview purposes
    static var previews: some View {
        ItemShopPlusWidgetEntryView(entry: ShopEntry(date: .now, shopItem: .mockShopItem, image: .Widget.mockItem))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
