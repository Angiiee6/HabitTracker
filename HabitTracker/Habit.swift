import Foundation
import SwiftData

@Model
final class Habit {
    var name: String
    var isDaily: Bool
    var creationDate: Date
    
    
    
    init(name: String, isDaily: Bool = false) {
        self.name = name
        self.isDaily = isDaily
        self.creationDate = Date()
        
    }
}
