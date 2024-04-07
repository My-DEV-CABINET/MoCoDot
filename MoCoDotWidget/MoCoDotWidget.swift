//
//  MoCoDotWidget.swift
//  MoCoDotWidget
//
//  Created by 준우의 MacBook 16 on 4/7/24.
//

import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    // 데이터를 불러오기 전(snapshot) 에 보여줄 Placeholder
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    // 위젯 갤러리에서 위젯을 고를 때 보이는 샘플 데이터를 보여줄 때 해당 메소드 호출
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct MoCoDotWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct MoCoDotWidget: Widget {
    let kind: String = "MoCoDotWidget"

    /// IntentConfiguration: 사용자가 위젯에서 Edit 을 통해 위젯에 보여지는 내용 변경이 가능
    /// StaticConfiguration : 사용자가 변경 불가능한 정적 데이터 표출
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind, // 위젯의 ID
            intent: ConfigurationAppIntent.self, // 사용자가 설정하는 컨피그
            provider: Provider() // 위젯 생성자
        ) { entry in
            // 위젯에 표출될 뷰
            MoCoDotWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

fileprivate extension ConfigurationAppIntent {
    static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    MoCoDotWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
