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
    
    @Query(sort: Word.sortDescriptors, animation: .bouncy) private var words: [Word]
    @State private var dateRange = DateRange.today
    @Environment(\.modelContext) private var modelContext
    #if os(watchOS)
    @Environment(\.dismiss) private var dismiss
    @State private var showingPickerSheet = false
    #endif
    
    let focusNewWordField: Bool
    
    let contentUnavailableLocalizedText = String(localized: "No recent words to display")
    let contentUnavailableLocalizedDescription = String(localized: "You haven't added any words as of late: there's nothing to see here!")
    
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
        filterWordsByDateRange(words)
    }
    
    var body: some View {
        FilteredWordCardsListView(words: filteredWords, focusNewWordField: focusNewWordField, contentUnavailableText: contentUnavailableLocalizedText, contentUnavailableDescription: contentUnavailableLocalizedDescription)
            .navigationTitle(title)
        #if os(watchOS)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Change date range", systemImage: "line.3.horizontal.decrease.circle") {
                        showingPickerSheet = true
                    }
                    .foregroundStyle(.white)
                }
            }
            .sheet(isPresented: $showingPickerSheet) {
                List {
                    CustomPickerOption(selectedDateRange: $dateRange, optionDateRange: .today, optionText: String(localized: "Today"))
                    CustomPickerOption(selectedDateRange: $dateRange, optionDateRange: .thisWeek, optionText: String(localized: "This week"))
                    CustomPickerOption(selectedDateRange: $dateRange, optionDateRange: .lastSevenDays, optionText: String(localized: "Last 7 days"))
                    CustomPickerOption(selectedDateRange: $dateRange, optionDateRange: .lastThirtyDays, optionText: String(localized: "Last 30 days"))
                }
                .navigationTitle("Change date range")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close", systemImage: "multiply") {
                            dismiss()
                        }
                    }
                }
            }
        #else
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
        #endif
    }
    
    #if os(watchOS)
    private struct CustomPickerOption: View {
        @Environment(\.dismiss) private var dismiss
        @Binding var selectedDateRange: DateRange
        let optionDateRange: DateRange
        let optionText: String
        
        var body: some View {
            Button {
                selectedDateRange = optionDateRange
                dismiss()
            } label: {
                HStack {
                    Text(optionText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if (selectedDateRange == optionDateRange) {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
    #endif
    
    // Determines the minimum date range that displays at least a word (if possible).
    // This allows to open the view showing some data to the user, instead of a blank page.
    init(modelContext: ModelContext, focusNewWordField: Bool = false) {
        self.focusNewWordField = focusNewWordField
        
        let descriptor = FetchDescriptor<Word>()
        guard let localWords = try? modelContext.fetch(descriptor) else { return }
        
        var localFilteredWords = filterWordsByDateRange(localWords, providedDateRange: .today)
        if localFilteredWords.count > 0 { return }
        
        _dateRange = State(initialValue: .thisWeek)
        localFilteredWords = filterWordsByDateRange(localWords, providedDateRange: .thisWeek)
        if localFilteredWords.count > 0 { return }
        
        _dateRange = State(initialValue: .lastSevenDays)
        localFilteredWords = filterWordsByDateRange(localWords, providedDateRange: .lastSevenDays)
        if localFilteredWords.count > 0 { return }
        
        _dateRange = State(initialValue: .lastThirtyDays)
    }
    
    private func filterWordsByDateRange(_ words: [Word], providedDateRange: DateRange? = nil) -> [Word] {
        let filteringDateRange = providedDateRange ?? dateRange
        
        return switch filteringDateRange {
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
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self, configurations: config)
        let words: [Word] = [
            Word(uuid: UUID(), term: "Test", learntOn: .now.addingTimeInterval(-86400*2)),
            Word(uuid: UUID(), term: "Swift", learntOn: .now)
        ]
        
        words.forEach {
            container.mainContext.insert($0)
        }
        
        return NavigationStack {
            RecentlyAddedWordsCategoryView(modelContext: container.mainContext)
        }
        .modelContainer(container)
        .environment(Router())
    } catch {
        return Text("Failed to create the preview: \(error.localizedDescription)")
    }
}
