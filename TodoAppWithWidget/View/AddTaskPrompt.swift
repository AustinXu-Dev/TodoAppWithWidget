//
//  AddTaskPrompt.swift
//  TodoAppWithWidget
//
//  Created by Austin Xu on 2024/7/16.
//

import SwiftUI

struct AddTaskPrompt: View {
    @Binding var isPresented: Bool
    @Binding var taskName: String
    var onAdd: () -> Void
    
    @FocusState private var isActive: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text("Add New Task")
                .font(.headline)

            TextField("Task Name", text: $taskName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .focused($isActive)

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .padding()
                
                Button("Add") {
                    onAdd()
                    isPresented = false
                }
                .padding()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 20)
        .padding()
        .onAppear(perform: {
            isActive = taskName.isEmpty
        })
    }
}
