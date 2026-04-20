import WidgetKit
import SwiftUI

// MARK: - Data

struct PrayerEntry: TimelineEntry {
    let date: Date
    let nextName: String
    let nextTime: String
    let countdown: String
}

// MARK: - Provider

struct PrayerProvider: TimelineProvider {
    static let appGroupId = "group.com.nayeem.quran"

    func placeholder(in context: Context) -> PrayerEntry {
        PrayerEntry(
            date: Date(),
            nextName: "Fajr",
            nextTime: "5:14 AM",
            countdown: "in 2h 14m"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerEntry) -> Void) {
        completion(readCurrentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerEntry>) -> Void) {
        let entry = readCurrentEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func readCurrentEntry() -> PrayerEntry {
        let defaults = UserDefaults(suiteName: Self.appGroupId)
        return PrayerEntry(
            date: Date(),
            nextName: defaults?.string(forKey: "next_prayer_name") ?? "Next Prayer",
            nextTime: defaults?.string(forKey: "next_prayer_time") ?? "—",
            countdown: defaults?.string(forKey: "next_prayer_countdown") ?? ""
        )
    }
}

// MARK: - View

struct PrayerWidgetEntryView: View {
    var entry: PrayerEntry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.059, green: 0.463, blue: 0.431),
                    Color(red: 0.024, green: 0.306, blue: 0.231)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(alignment: .leading, spacing: 4) {
                Text("Next: \(entry.nextName)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                Text(entry.nextTime)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text(entry.countdown)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(12)
        }
        .widgetURL(URL(string: "quranapp://home"))
    }
}

// MARK: - Widget

struct PrayerWidget: Widget {
    let kind: String = "PrayerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PrayerProvider()) { entry in
            if #available(iOS 17.0, *) {
                PrayerWidgetEntryView(entry: entry)
                    .containerBackground(.fill, for: .widget)
            } else {
                PrayerWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Next Prayer")
        .description("Shows the next prayer time and countdown.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
