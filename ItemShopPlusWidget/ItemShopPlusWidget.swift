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

struct ItemShopPlusWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)
        }
        .widgetBackground(Color.red)
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
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
