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
    private enum Range: CaseIterable {
        case today, thisWeek, pastSevenDays
    }
    
    @Query(sort: Word.sortDescriptors) private var words: [Word]
    @State private var range = Range.today
    
    var title: String {
        return switch range {
            case .today:
                String(localized: "Today")
            case .thisWeek:
                String(localized: "This week")
            case .pastSevenDays:
                String(localized: "Past seven days")
        }
    }
    
    // cannot be filtered using a SwiftData Predicate as the Calendar functions are
    // not supported within a predicate
    var filteredWords: [Word] {
        return switch range {
            case .today:
                words.filter { word in
                    Calendar.current.isDateInToday(word.learntOn)
                }
            case .thisWeek:
                words.filter { word in
                    Calendar.current.isDate(word.learntOn, equalTo: .now, toGranularity: .weekOfYear)
                }
            case .pastSevenDays:
                words.filter { word in
                    let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now)
                    guard let sevenDaysAgo else { return false }
                    return word.learntOn >= sevenDaysAgo
                }
        }
    }
    
    var body: some View {
        WordCardsListView(words: filteredWords)
            .navigationTitle(title)
            .toolbar {
                Menu {
                    Picker("Change date range", selection: $range) {
                        Text("Today").tag(Range.today)
                        Text("This week").tag(Range.thisWeek)
                        Text("Past seven days").tag(Range.pastSevenDays)
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
