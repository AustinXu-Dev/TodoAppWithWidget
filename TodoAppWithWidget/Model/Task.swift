//
//  Task.swift
//  TodoAppWithWidget
//
//  Created by Austin Xu on 2024/7/16.
//

import Foundation
import SwiftData

@Model class Task: Identifiable {
    private(set) var id: String = UUID().uuidString
    var name: String
    var isCompleted: Bool = false
    var lastUpdated: Date = Date.now
    
    init(name: String) {
        self.name = name
    }
}
