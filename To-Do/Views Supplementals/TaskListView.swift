import SwiftUI
import CoreData



extension Tasks {
    @nonobjc public class func getAllTasks() -> NSFetchRequest<Tasks> {
        let request = NSFetchRequest<Tasks>(entityName: "Tasks")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    public var subtasksArray: [Subtasks] {
        let set = subtasks as? Set<Subtasks> ?? []
        return set.sorted {
            $0.name ?? "" < $1.name ?? ""
        }
    }
}


struct TaskListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(fetchRequest: Tasks.getAllTasks()) var tasks: FetchedResults<Tasks>

    @State private var isAddingNewTask: Bool = false

    var body: some View {
        NavigationStack{
            VStack {
                List {
                    ForEach(self.tasks, id: \.self) { (task: Tasks) in
                        DisclosureGroup(
                            content: {
                                ForEach(task.subtasksArray, id: \.self) { (subtask: Subtasks) in
                                    SubtaskView(subtask: subtask)
                                }
                                .onDelete { indexSet in
                                    let deleteItem = task.subtasksArray[indexSet.first!]
                                    self.managedObjectContext.delete(deleteItem)

                                    do {
                                        try self.managedObjectContext.save()
                                    } catch {
                                        print(error)
                                    }
                                }
                            },
                            label: {
                                TaskRowView(task: task)
                            }
                        )
                    }
                    .onDelete { indexSet in
                        let deleteItem = self.tasks[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)

                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                    }
                    if isAddingNewTask {
                        NewTaskRowView(isAddingNewTask: $isAddingNewTask)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Tasks")
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    withAnimation {
                        self.isAddingNewTask = true
                    }
                }) {
                    Image(systemName: "plus")
                })
            }
        }
    }
}










    



