import SwiftUI
import CoreData


struct ContentView: View {
    var body: some View {
        TaskListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
