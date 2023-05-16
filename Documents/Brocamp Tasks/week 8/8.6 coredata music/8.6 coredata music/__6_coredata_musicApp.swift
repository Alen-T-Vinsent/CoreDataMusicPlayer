import SwiftUI

@main
struct __6_coredata_musicApp: App {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    let persistenceController = PersistenceController.shared
    
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
}
