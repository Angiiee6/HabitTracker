
import Foundation
import SwiftUI
import SwiftData


@Model
class HabitCompletion {
    var date: Date
    weak var habit: Habit?
    
    init(date: Date) {
        self.date = date
    }
}
