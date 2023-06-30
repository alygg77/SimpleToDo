import SwiftUI


struct TaskRowView: View {
    @ObservedObject var task: Tasks
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationLink(destination: TaskView(task: task)) {
            HStack {
                Image(systemName: self.task.completed ? "checkmark.square" : "square")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .imageScale(.large)
                    .onTapGesture {
                        withAnimation {
                            self.task.completed.toggle()
                            for subtask in task.subtasksArray {
                                subtask.completed = task.completed
                            }
                        }
                    }
                Text(task.name ?? "")
                    .font(.system(size: 24))
                    .strikethrough(self.task.completed, color: colorScheme == .dark ? .white : .black)
                    .foregroundColor(self.task.completed ? .gray : (colorScheme == .dark ? .white : .black))
            }
        }
    }
}

