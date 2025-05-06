//
//  Item.swift
//  HabitTracker
//
//  Created by Angelica E on 2025-05-06.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
