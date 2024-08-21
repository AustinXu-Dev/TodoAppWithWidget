//
//  TodoWidget.swift
//  TodoWidget
//
//  Created by Austin Xu on 2024/7/16.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let entry = SimpleEntry(date: .now)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TodoWidgetEntryView : View {
    var entry: Provider.Entry

    @Query(taskDescriptor, animation: .snappy) private var tasks: [TodoTask]
    
    var body: some View {
        VStack {
            ForEach(tasks){ task in
                HStack(spacing: 10) {
                    // Intent Action Button
                    Button(intent: ToggleButton(id: task.id)) {
                        Image(systemName: "circle")
                    }
                    .font(.callout)
                    .buttonBorderShape(.circle)
                    Text(task.name)
                        .font(.callout)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                }.transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if tasks.isEmpty{
                Text("No Tasks.")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var taskDescriptor: FetchDescriptor<TodoTask>{
        let predicate = #Predicate<TodoTask> { !$0.isCompleted }
        let sort = [SortDescriptor(\TodoTask.name)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
}

struct TodoWidget: Widget {
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: TodoTask.self)
            
        }
        .configurationDisplayName("My Widget")
        .description("This is todo widget.")
        .supportedFamilies([.systemMedium])
        
    }
}

//MARK: - Main part of the widget intent action

struct ToggleButton: AppIntent{
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle Task State")
    
    @Parameter(title: "Task ID") var id: String
    
    init(){
        
    }
    
    init(id: String){
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        // Update task status, Get context
        let context = try ModelContext(.init(for: TodoTask.self))
        // Retrieve the respective task ID
        let descriptor = FetchDescriptor(predicate: #Predicate<TodoTask> { $0.id == id})
        if let task = try context.fetch(descriptor).first{
            task.isCompleted = true
            task.lastUpdated = .now
            
            // saving the task
            try context.save()
        }
        
        return .result()
    }


}


#Preview(as: .systemSmall) {
    TodoWidget()
} timeline: {
    SimpleEntry(date: .now)
}
