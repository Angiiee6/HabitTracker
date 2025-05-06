import SwiftUI


struct AddNewHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var habitName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Vanas namn", text: $habitName)
                    .autocapitalization(.words)
            }
            .navigationTitle("Ny vana")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Spara") {
                        addNewHabit()
                        dismiss()
                    }
                    .disabled(habitName.isEmpty)
                }
            }
        }
    }
    
    private func addNewHabit() {
        let newHabit = Habit(name: habitName)
        modelContext.insert(newHabit)
    }
}

#Preview {
    AddNewHabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}
