import SwiftUI


struct TaskView: View {
    @ObservedObject var task: Tasks
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme

    @State private var isAddingNewSubtask: Bool = false

    var body: some View {
        VStack {
            List {
                ForEach(task.subtasksArray, id: \.id) { (subtask: Subtasks) in
                    SubtaskView(subtask: subtask)
                }
                .onDelete { indexSet in
                    let deleteItem = self.task.subtasksArray[indexSet.first!]
                    self.managedObjectContext.delete(deleteItem)

                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
                if isAddingNewSubtask {
                    NewSubtaskRowView(task: task, isAddingNewSubtask: $isAddingNewSubtask)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Subtasks")
            .navigationBarItems( trailing: Button(action: {
                withAnimation {
                    self.isAddingNewSubtask = true
                }
            }) {
                Image(systemName: "plus")
            })
        }
    }
}

struct NewSubtaskRowView: View {
    @ObservedObject var task: Tasks
    @Binding var isAddingNewSubtask: Bool
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var newSubtaskName: String = ""

    var body: some View {
        TextField("New Subtask", text: $newSubtaskName, onCommit: {
            let newSubtask = Subtasks(context: self.managedObjectContext)
            newSubtask.name = self.newSubtaskName
            newSubtask.completed = false
            newSubtask.parentTask = self.task

            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
            }

            self.newSubtaskName = ""
            self.isAddingNewSubtask = false
        })
    }
}

