import SwiftUI

struct SubtaskView: View {
    @ObservedObject var subtask: Subtasks
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    self.subtask.completed.toggle()
                }
            }) {
                Image(systemName: self.subtask.completed ? "checkmark.circle" : "circle")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .imageScale(.large)
            }
            Text(subtask.name ?? "")
                .font(.system(size: 24))
                .strikethrough(self.subtask.completed, color: colorScheme == .dark ? .white : .black)
                .foregroundColor(self.subtask.completed ? .gray : (colorScheme == .dark ? .white : .black))
        }
    }
}
