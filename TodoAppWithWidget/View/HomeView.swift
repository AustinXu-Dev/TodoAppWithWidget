//
//  HomeView.swift
//  TodoAppWithWidget
//
//  Created by Austin Xu on 2024/7/16.
//

import SwiftUI
import SwiftData
import WidgetKit

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Task> { !$0.isCompleted }, sort: [SortDescriptor (\Task.lastUpdated, order: .reverse)], animation: .snappy) var tasks: [Task]
   
    
    @State private var showAddTaskPrompt = false
    @State private var newTaskName = ""
    
    var body: some View {
        VStack {
            List {
                Section("Active"){
                    ForEach(tasks, id: \.id) { task in
                        TaskRowView(task: task)
                    }
                }
                CompletedTasksView()
                
            }
            .listStyle(PlainListStyle())
            
            
            Button("Add Task") {
                showAddTaskPrompt = true
            }
            .padding()
        }
        .navigationTitle("Tasks")
        .overlay(
            Group {
                if showAddTaskPrompt {
                    AddTaskPrompt(
                        isPresented: $showAddTaskPrompt,
                        taskName: $newTaskName,
                        onAdd: addTask
                    )
                }
            }
        )
    }
    
    private func addTask(){
        if newTaskName.isEmpty {
            // Handle invalid input (e.g., show an error message)
            return
        }
        let newTask = Task(name: newTaskName)
        modelContext.insert(newTask)
        WidgetCenter.shared.reloadAllTimelines()
        newTaskName = ""
    }
    
}

#Preview {
    HomeView()
}
