import SwiftUI

struct AddSongsToPlaylist: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var popDownAddSongsToPlaylist
    
    
    var category:Category 
    @State var songName:String = ""

    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header:Text("New playlist")){
                    TextField("add songs ", text: $songName)
                }
                
            //form ending
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    
                    
                    Button {
                        print("close button inside add new playlist clicked")
                        popDownAddSongsToPlaylist()
                        
                    } label: {
                        Label("Cancel",systemImage:"xmark")
                            .foregroundColor(.red)
                    }
                }
                
                
                
                ToolbarItem{
                
                Button {
                    print("tick button pressed in add new playlist")
                    
                    
                    
                    
                    
                    savePlaylist()
                    popDownAddSongsToPlaylist()
                } label: {
                    Label("Done",systemImage:"checkmark")
                        .foregroundColor( songName == "" ? .gray : .green)
                        
                }
                .disabled(songName.isEmpty)

                
            //tool bar item ending
            }
                    
            }
            
            
            
        //navigation view ending
        }
        .navigationTitle("add new songs")
        .navigationBarTitleDisplayMode(.inline)
        


    }

}






extension AddSongsToPlaylist{
    
    private func savePlaylist(){

        let item = Item(context: viewContext)
        item.value = songName
        item.addToCategories(category)
        
        do{
            try PersistenceController.shared.save()
            popDownAddSongsToPlaylist()
        }catch{
            print(error.localizedDescription)
        }


    }
}
