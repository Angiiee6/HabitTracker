import SwiftUI
import SwiftData


struct CalendarDayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var completions: [HabitCompletion]
    
    var date: Date
    var isSelected: Bool
    
    //ny för att visa dagens datum
    var isToday: Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }
    
    init(date: Date, isSelected: Bool) {
        self.date = date
        self.isSelected = isSelected
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            _completions = Query(filter: #Predicate { _ in false })
            return
        }
        
        _completions = Query(
            filter: #Predicate { completion in
                completion.date >= startOfDay && completion.date < endOfDay
            },
            sort: \.date
        )
    }
    
    private var hasCompletions: Bool {
        !completions.isEmpty
    }
    
    var body: some View {
        ZStack {
            if date == Date.distantPast {
                Rectangle()
                    .foregroundColor(.clear)
            } else {
                // Bakgrundscirkel (nu med tre tillstånd)
                ZStack {
                    //Vald dag
                    if isSelected {
                        Circle()
                            .foregroundColor(.blue)
                        //dagens datum med cirkel
                    } else if isToday {
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                        //om mål är avklarade
                    } else if hasCompletions {
                        Circle()
                            .foregroundColor(.green.opacity(0.3))
                    }
                }
                .frame(width: 32, height: 32)
                
                // Datumtext
                Text("\(Calendar.current.component(.day, from: date))")
                    .foregroundColor(isSelected ? .white : (isToday ? .blue : .primary))
                    .fontWeight(isSelected ? .bold : (isToday ? .semibold : .regular))
                
                // Completion-prick
                if hasCompletions && !isSelected {
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
