import Foundation
import SwiftData

@Model
final class Habit {
    var name: String
    var isDaily: Bool
    var creationDate: Date
    //koppla ihop modellerna
    @Relationship(deleteRule: .cascade) var completions = [HabitCompletion]()
    

    init(name: String, isDaily: Bool = false) {
        self.name = name
        self.isDaily = isDaily
        self.creationDate = Date()
    }
    
    var currentStreak: Int {
           let calendar = Calendar.current
           let today = calendar.startOfDay(for: Date())
           var currentDate = today
           var streak = 0
           
           // Sortera completion-datum fallande (senaste först)
           let sortedCompletions = completions.sorted { $0.date > $1.date }
           
           // Loopa genom avklaringar och räkna streaken
           for completion in sortedCompletions {
               let completionDate = calendar.startOfDay(for: completion.date)
               
               if completionDate == currentDate {
                   // Fortsätter streaken
                   streak += 1
                   currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
               } else if completionDate < currentDate {
                   // Streaken bruten
                   break
               }
           }
           
           return streak
       }
       
       var potentialStreak: Int {
           let calendar = Calendar.current
           let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
           
           // Om igår var avklarat, visa nuvarande streak + 1
           if isCompleted(for: yesterday) {
               return currentStreak + 1
           }
           // Annars visa 1 (ny streak)
           return 0
       }
       
       func isCompleted(for date: Date) -> Bool {
           let calendar = Calendar.current
           return completions.contains { completion in
               calendar.isDate(completion.date, inSameDayAs: date)
           }
       }
   }
