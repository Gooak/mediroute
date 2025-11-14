//
//  Item.swift
//  mediroute
//
//  Created by 황진우 on 11/14/25.
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
