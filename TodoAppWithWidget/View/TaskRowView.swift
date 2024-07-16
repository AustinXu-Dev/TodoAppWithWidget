//
//  TaskRowView.swift
//  TodoAppWithWidget
//
//  Created by Austin Xu on 2024/7/16.
//

import SwiftUI
import WidgetKit

struct TaskRowView: View {
    
    @Bindable var task: Task
    
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        HStack {
            Button(action: {
                task.isCompleted.toggle()
                task.lastUpdated = .now
                WidgetCenter.shared.reloadAllTimelines()

            }, label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill": "circle")
                    .font(.title2)
                    .padding(3)
                    .contentShape(.rect)
                    .foregroundStyle(task.isCompleted ? .gray : .primary)
                    .contentTransition(.symbolEffect(.replace))
            })
            Text(task.name)
                .strikethrough(task.isCompleted)
            Spacer()
            
        }
        .task {
            task.isCompleted = task.isCompleted
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            //MARK: - Important actor of Widget updates
            //Update from widget will directly come to app by scenePhase
            WidgetCenter.shared.reloadAllTimelines()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false){
            Button("", systemImage: "trash"){
                context.delete(task)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        
    }
    
//    private func refreshTask() {
//        // Trigger a refresh for the task
//        context.refresh(task, mergeChanges: true)
//    }
}

#Preview {
    ContentView()
}
