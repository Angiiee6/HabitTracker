import SwiftUI
import SwiftData

struct TodayView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayTabView()
                .tabItem {
                    Label("Idag", systemImage: "checkmark.circle.fill")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Label("Kalender", systemImage: "calendar")
                }
                .tag(1)
            
            HabitListView()
                .tabItem {
                    Label("Mål", systemImage: "list.bullet")
                }
                .tag(2)
        }
    }
}
struct TodayTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Habit> { $0.isDaily }) private var habits: [Habit]
    

    
    var incompleteHabits: [Habit] {
        habits.filter { !$0.isCompleted(for: Date()) }
    }
    
    var completedHabits: [Habit] {
        habits.filter { $0.isCompleted(for: Date()) }
    }
    
    var body: some View {
        NavigationStack {
            List {

                
                // Oavklarade vanor
                Section(incompleteHabits.isEmpty ? "Alla mål klara" : "Att göra") {
                    ForEach(incompleteHabits) { habit in
                        HabitRowView(habit: habit, isCompleted: false)
                    }
                }
                // Avklarade vanor
                if !completedHabits.isEmpty {
                    Section("Avklarade idag") {
                        ForEach(completedHabits) { habit in
                            HabitRowView(habit: habit, isCompleted: true)
                        }
                    }
                }
            }
            .navigationTitle("Dagens mål")
            .overlay {
                if habits.isEmpty {
                    ContentUnavailableView(
                        "Inga mål idag",
                        systemImage: "plus.circle",
                        description: Text("Lägg till vanor i biblioteket")
                    )
                }
            }
        }
    }
}

struct HabitRowView: View {
    @Bindable var habit: Habit
    var isCompleted: Bool
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack {
            Text(habit.name)
            
            Spacer()
            
            // Streak-visning
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(
                        isCompleted ?
                        (habit.currentStreak > 0 ? .orange : .gray) :
                        .gray
                    )
                Text("\(isCompleted ? habit.currentStreak : habit.potentialStreak)")
                    .font(.footnote.monospacedDigit())
            }
            
            // Avmarkeringsknapp
            Button {
                toggleHabitCompletion()
            } label: {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? .green : .blue)
                    .imageScale(.large)
            }
            .buttonStyle(.borderless)
        }
    }
    
    private func toggleHabitCompletion() {
        withAnimation {
            if isCompleted {
                removeCompletion()
            } else {
                addCompletion()
            }
        }
    }
    
    private func addCompletion() {
        let completion = HabitCompletion(date: Date())
        habit.completions.append(completion)
    }
    
    private func removeCompletion() {
        if let index = habit.completions.firstIndex(where: {
            Calendar.current.isDate($0.date, inSameDayAs: Date())
        }) {
            modelContext.delete(habit.completions[index])
        }
    }
}

//#Preview("TodayTabView - Empty") {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(
//        for: Habit.self, HabitCompletion.self,
//        configurations: config
//    )
//    return TodayTabView()
//        .modelContainer(container)
//}


#Preview("TodayTabView - With Data") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Habit.self, HabitCompletion.self,
        configurations: config
    )
    
    let habit1 = Habit(name: "Meditate", isDaily: true)
    let habit2 = Habit(name: "Plan Day", isDaily: true)
    habit1.completions.append(HabitCompletion(date: Date()))
    
    container.mainContext.insert(habit1)
    container.mainContext.insert(habit2)
    
    return TodayTabView()
        .modelContainer(container)
}
