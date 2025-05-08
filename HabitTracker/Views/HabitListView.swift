import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.name) private var habits: [Habit]
    @State private var newHabitName = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Lägg till nytt mål") {
                    HStack {
                        TextField("Namn på mål", text: $newHabitName)
                        Button("Lägg till") {
                            let newHabit = Habit(name: newHabitName)
                            modelContext.insert(newHabit)
                            newHabitName = ""
                        }
                        .disabled(newHabitName.isEmpty)
                    }
                }
                
                Section("Mina mål") {
                    ForEach(habits) { habit in
                        @Bindable var habit = habit
                        HStack {
                            Text(habit.name)
                            Spacer()
                            if habit.isDaily {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                        }
                        .onTapGesture {
                            habit.isDaily.toggle()
                        }
                    }
                    .onDelete(perform: deleteHabits)
                }
            }
            .navigationTitle("Listade mål")
        }
    }
    
    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(habits[index])
            }
        }
    }
}

#Preview {
    HabitListView()
        .modelContainer(for: Habit.self, inMemory: true)
}
