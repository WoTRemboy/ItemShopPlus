//
//  ItemShopPlusWidget.swift
//  ItemShopPlusWidget
//
//  Created by Roman Tverdokhleb on 7/31/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> StatsEntry {
        StatsEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (StatsEntry) -> ()) {
        let entry = StatsEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [StatsEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = StatsEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct StatsEntry: TimelineEntry {
    let date: Date
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
            Image.Widget.mockItem
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 10))
                .frame(width: 80)
            Spacer()
            
            Image.Widget.newBanner
                .resizable()
                .scaledToFit()
                .frame(width: 35)
        }
    }
    
    private var itemNamePrice: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Texts.Widget.mockTitle)
                .lineLimit(1)
                .font(.system(size: 17, weight: .light))
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
                .frame(width: 13)
            
            Text(Texts.Widget.mockPrice)
                .lineLimit(1)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.labelPrimary)
        }
    }
}

struct ItemShopPlusWidget: Widget {
    let kind: String = "ItemShopPlusWidget"

    var body: some WidgetConfiguration {
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
        .configurationDisplayName("Item of the Day")
        .description("New or the most interesting offer today.")
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
        ItemShopPlusWidgetEntryView(entry: StatsEntry(date: .now))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
