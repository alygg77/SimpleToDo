import SwiftUI

struct NewTaskRowView: View {
    @Binding var isAddingNewTask: Bool
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var newTaskName: String = ""

    var body: some View {
        TextField("New Task", text: $newTaskName, onCommit: {
            let newTask = Tasks(context: self.managedObjectContext)
            newTask.name = self.newTaskName
            newTask.completed = false

            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
            }

            self.newTaskName = ""
            self.isAddingNewTask = false
        })
    }
}
