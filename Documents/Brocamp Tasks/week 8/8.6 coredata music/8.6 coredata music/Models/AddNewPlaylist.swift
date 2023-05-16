import SwiftUI

struct AddNewPlaylist: View {
    @State private var name = ""
    @State private var navigateToLibrary:Bool = false
    @State private var disableTick:Bool = false
    @State private var showAlertPlaylistExist = false
    
    
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var popDownScreen
    
    
    @FetchRequest(sortDescriptors: []) private var categories:FetchedResults<Category>
    
    
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header:Text("New playlist")){
                    TextField("enter playlist name", text: $name)
                }
                
                //form ending
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    
                    
                    Button {
                        print("close button inside add new playlist clicked")
                        popDownScreen()
                        
                    } label: {
                        Label("Cancel",systemImage:"xmark")
                            .foregroundColor(.red)
                    }
                }
                
                
                ToolbarItem{
                    Button {
                        print("tick button pressed in add new playlist")
                        savePlaylist()
                    } label: {
                        Label("Done",systemImage:"checkmark")
                            .foregroundColor(name=="" ? .gray : .green)
                    }
                    .disabled(name.isEmpty)
                    .alert("Alert ⛑️", isPresented:$showAlertPlaylistExist) {
                        
                        Button("OK",role:.cancel){
                            print("ok pressed important")
                            showAlertPlaylistExist = false
                            name = ""
                        }
                    }message: {
                        Text("Playlist already exist")
                    }
                    //tool bar item ending
                }
            }
            
            //navigation view ending
        }
        .navigationTitle("Create New Playlist")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    func savePlaylist(){
        
        let category = Category(context: viewContext)
        category.value = name
        
        do{
            try PersistenceController.shared.save()
            popDownScreen()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    
    
}









