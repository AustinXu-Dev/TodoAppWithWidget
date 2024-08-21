//
//  CompletedTasksView.swift
//  TodoAppWithWidget
//
//  Created by Austin Xu on 2024/7/16.
//

import SwiftUI
import SwiftData

struct CompletedTasksView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(filter: #Predicate<TodoTask> { $0.isCompleted }, sort: [SortDescriptor (\TodoTask.lastUpdated, order: .reverse)], animation: .snappy) var completedTasks: [TodoTask]
    
    var body: some View {
        Section("Completed"){
            ForEach(completedTasks, id: \.id) { task in
                TaskRowView(task: task)
            }
        }
    }
}

#Preview {
    ContentView()
}
