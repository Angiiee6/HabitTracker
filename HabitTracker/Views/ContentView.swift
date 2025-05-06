import SwiftUI
import SwiftData


// MARK: - Huvudvy

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.creationDate) private var allHabits: [Habit]
    @State private var showingHabitLibrary = false
    

    var dailyHabits: [Habit] {
        allHabits.filter { $0.isDaily }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if dailyHabits.isEmpty {
                    ContentUnavailableView(
                        "Inga vanor idag",
                        systemImage: "plus.circle",
                        description: Text("Lägg till vanor från biblioteket")
                    )
                } else {
                    List {
                        ForEach(dailyHabits) { habit in
                            Text(habit.name)
                        }
                        .onDelete(perform: removeFromDaily)
                    }
                }
            }
            .navigationTitle("Dagens vanor")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingHabitLibrary = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingHabitLibrary) {
                HabitLibraryView()
            }
        }
    }
    
    /// Ta bort vanor från dagens lista men inte permanent)
    private func removeFromDaily(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                dailyHabits[index].isDaily = false
            }
        }
    }
}



  #Preview {
      ContentView()
          .modelContainer(for: Habit.self, inMemory: true)
  }
