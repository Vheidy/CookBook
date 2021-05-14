//
//  CookBookWidget.swift
//  CookBookWidget
//
//  Created by OUT-Salyukova-PA on 26.04.2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 2, to: Date())!
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TextView: View {

    let mainText: String
    let subText: String

    var body: some View {
        VStack {
            Text(mainText)
//                .bold()
                .lineLimit(nil)
                .font(.system(size: 15))
            Text(subText)
                .font(.footnote)
                .bold()

        }
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.black)
        .padding(1)
    }
}

struct CookBookWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Image("breakfast")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(4)
            TextView(mainText: "Create your own ", subText: "CoocBook")
        }
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.orange)
    }
}

@main
struct CookBookWidget: Widget {
    let kind: String = "CookBookWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { (entry) in
            CookBookWidgetEntryView(entry: entry)
        }
    }
}

struct CookBookWidget_Previews: PreviewProvider {
    static var previews: some View {
        CookBookWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
