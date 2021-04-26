//
//  CookBookWidget.swift
//  CookBookWidget
//
//  Created by Полина Салюкова on 22.04.2021.
//

import WidgetKit
import SwiftUI
import Intents
import Nuke

struct DishEntry: TimelineEntry {
    var date = Date()
    var dish: DishModel
}

struct Provider: TimelineProvider {
//    typealias Entry = DishEntry
    @AppStorage("dishes", store: UserDefaults(suiteName: "group.vheidy.CookBook.CookBookWidget"))
    var dishesData = Data()
    
    func placeholder(in context: Context) -> DishEntry {
        return DishEntry(dish: DishModel(name: "Create your recipe", typeDish: "With some ingredients", ingredient: [], orderOfAction: [], imageName: nil, cuisine: nil, calories: nil, id: Date()))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DishEntry) -> Void) {
        guard let dish = try? JSONDecoder().decode(DishModel.self, from: dishesData) else { return }
        let entry = DishEntry(dish: dish)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DishEntry>) -> Void) {
        guard let dish = try? JSONDecoder().decode(DishModel.self, from: dishesData) else { return }
        let entry = DishEntry(dish: dish)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    

    
}

struct DishView: View {
    var dish: DishModel
    
    var body: some View {
        HStack {
//            if let image = UIImage(named: "breakfast")/
//            Image.init("breakfast")
            VStack {
                Text.init("❤️")
                    .bold()
                Text.init("\(dish.ingredient.count) ingredients")
                    .underline()
            }
        }
    }
    
    private func downloadImage(_ urlString: String, _ complition: ((UIImageView) -> ())?) {
        guard let url = URL(string: urlString) else { return }
        let imageView = UIImageView()
        Nuke.loadImage(with: ImageRequest(url: url), into: imageView) { (result) in
            switch result {
            case .failure(let error):
                print(error)
                complition?(UIImageView(image: UIImage(named: "breakfast")))
            case .success( _):
                complition?(imageView)
            }
        }
    }
}

struct CookBookWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        DishView(dish: entry.dish)
    }
}

@main
struct CookBookWidget: Widget {
    let kind: String = "CookBookWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration (kind: kind, provider: Provider()) { entry in
            CookBookWidgetEntryView(entry: entry)
        }
//        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
//            CookBookWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
    }
}

//struct Provider: IntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
//    }
//
//    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
//        completion(entry)
//    }
//
//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationIntent
//}
//
//struct CookBookWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time)
//    }
//}
//
//@main
//struct CookBookWidget: Widget {
//    let kind: String = "CookBookWidget"
//
//    var body: some WidgetConfiguration {
//        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
//            CookBookWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//    }
//}
//
//struct CookBookWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        CookBookWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
