//
//  TodoAppWithWidgetApp.swift
//  TodoAppWithWidget
//
//  Created by Austin Xu on 2024/7/16.
//

import SwiftUI

@main
struct TodoAppWithWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TodoTask.self)
    }
}
