//
//  TodayWordsCategoryView.swift
//  Flashword
//
//  Created by Alessio Mason on 19/02/24.
//

import SwiftData
import SwiftUI

struct RecentlyAddedWordsCategoryView: View {
    /// Specifies which of the different ranges of the calendar to show.
    private enum DateRange {
        case today, thisWeek, lastSevenDays, lastThirtyDays
    }
    
    @Query(sort: Word.sortDescriptors) private var words: [Word]
    @State private var dateRange = DateRange.today
    
    var title: String {
        return switch dateRange {
            case .today:
                String(localized: "Today")
            case .thisWeek:
                String(localized: "This week")
            case .lastSevenDays:
                String(localized: "Last 7 days")
            case .lastThirtyDays:
                String(localized: "Last 30 days")
        }
    }
    
    // cannot be filtered using a SwiftData Predicate as the Calendar functions are
    // not supported within a predicate
    var filteredWords: [Word] {
        return switch dateRange {
            case .today:
                words.filter { word in
                    Calendar.current.isDateInToday(word.learntOn)
                }
            case .thisWeek:
                words.filter { word in
                    Calendar.current.isDate(word.learntOn, equalTo: .now, toGranularity: .weekOfYear)
                }
            case .lastSevenDays:
                words.filter { word in
                    let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now)
                    guard let sevenDaysAgo else { return false }
                    return word.learntOn >= sevenDaysAgo
                }
            case .lastThirtyDays:
                words.filter { word in
                    let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: .now)
                    guard let thirtyDaysAgo else { return false }
                    return word.learntOn >= thirtyDaysAgo
                }
        }
    }
    
    var body: some View {
        WordCardsListView(words: filteredWords)
            .navigationTitle(title)
            .toolbar {
                Menu {
                    Picker("Change date range", selection: $dateRange) {
                        Text("Today").tag(DateRange.today)
                        Text("This week").tag(DateRange.thisWeek)
                        Text("Last 7 days").tag(DateRange.lastSevenDays)
                        Text("Last 30 days").tag(DateRange.lastThirtyDays)
                    }
                } label: {
                    Label("Change date range", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words = [
            Word(term: "Test", learntOn: .now.addingTimeInterval(-86400*2)),
            Word(term: "Swift", learntOn: .now)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return NavigationStack {
            RecentlyAddedWordsCategoryView()
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
