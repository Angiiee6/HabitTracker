import SwiftUI
import SwiftData

struct HabitLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.name) private var habits: [Habit]
    @State private var newHabitName = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Lägg till ny vana") {
                    HStack {
                        TextField("Namn på vana", text: $newHabitName)
                        Button("Lägg till") {
                            let newHabit = Habit(name: newHabitName)
                            modelContext.insert(newHabit)
                            newHabitName = ""
                        }
                        .disabled(newHabitName.isEmpty)
                    }
                }
                
                Section("Mina vanor") {
                    ForEach(habits) { habit in
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
            .navigationTitle("Vanebibliotek")
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
    HabitLibraryView()
        .modelContainer(for: Habit.self, inMemory: true)
}
