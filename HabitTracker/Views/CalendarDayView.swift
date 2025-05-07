import SwiftUI
import SwiftData


struct CalendarDayView: View {
    @Environment(\.modelContext) private var modelContext
    var date: Date
    var isSelected: Bool
    
    private var hasCompletions: Bool {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return false
        }
        
        let request = FetchDescriptor<HabitCompletion>(
            predicate: #Predicate { completion in
                completion.date >= startOfDay && completion.date < endOfDay
            }
        )
        
        return (try? modelContext.fetch(request).isEmpty == false) ?? false
    }
    
    var body: some View {
        ZStack {
            if date == Date.distantPast {
                Rectangle()
                    .foregroundColor(.clear)
            } else {
                Circle()
                    .foregroundColor(isSelected ? .blue : (hasCompletions ? .green.opacity(0.3) : .clear))
                    .frame(width: 32, height: 32)
                
                Text("\(Calendar.current.component(.day, from: date))")
                    .foregroundColor(isSelected ? .white : .primary)
                    .fontWeight(isSelected ? .bold : .regular)
                
                if hasCompletions {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(.green)
                        .offset(x: 12, y: 12)
                }
            }
        }
        .frame(height: 40)
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, HabitCompletion.self, configurations: config)
    
    let habit = Habit(name: "Test")
    let completion = HabitCompletion(date: Date())
    habit.completions.append(completion)
    container.mainContext.insert(habit)
    
    return CalendarDayView(date: Date(), isSelected: true)
        .modelContainer(container)
}
