import SwiftUI
import SwiftData

// MARK: - Vanebibliotek
struct HabitLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Habit.name) private var habits: [Habit]
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(habits) { habit in
                    HStack {
                        Text(habit.name)
                        Spacer()
                        if habit.isDaily {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleDailyStatus(for: habit)
                    }
                }
                .onDelete(perform: deleteHabits)
            }
            .navigationTitle("Vanebibliotek")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Klar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddNewHabitView()
            }
        }
    }
    
    /// Växlar en vanas dagliga status
    private func toggleDailyStatus(for habit: Habit) {
        habit.isDaily.toggle()
    }
    
    /// Raderar vanor permanent
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
