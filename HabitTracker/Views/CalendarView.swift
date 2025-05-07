import Foundation
import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.name) private var habits: [Habit]
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Månadsvy
                MonthCalendarView(selectedDate: $selectedDate)
                    .padding(.horizontal)
                
                // Lista över vanor för valt datum
                List {
                    ForEach(habits) { habit in
                        HStack {
                            Text(habit.name)
                            Spacer()
                            if habit.isCompleted(for: selectedDate) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                        }
                        .onTapGesture {
                            toggleHabitCompletion(habit: habit, date: selectedDate)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Kalender")
        }
    }
    
    private func toggleHabitCompletion(habit: Habit, date: Date) {
        if habit.isCompleted(for: date) {
            // Ta bort completion
            if let index = habit.completions.firstIndex(where: {
                Calendar.current.isDate($0.date, inSameDayAs: date)
            }) {
                modelContext.delete(habit.completions[index])
            }
        } else {
            // Lägg till completion
            let completion = HabitCompletion(date: date)
            habit.completions.append(completion)
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, HabitCompletion.self, configurations: config)
    
    let habit = Habit(name: "Kalendervana")
    let completion = HabitCompletion(date: Date())
    habit.completions.append(completion)
    container.mainContext.insert(habit)
    
    return CalendarView()
        .modelContainer(container)
}
