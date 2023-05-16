import SwiftUI

struct CategoryView: View {
    @FetchRequest(sortDescriptors:[NSSortDescriptor(keyPath:\Item.value, ascending: true)],animation:.default)
    private var items:FetchedResults<Item>
    @State var category:Category
    @State var isAddSongViewisPresented = false
    @State  var songsArray = Array<String>()
    
    func SongsAppend(){
        for item in items {
            songsArray.append(item.value ?? "Nil")
        }
        print(songsArray)
    }
    
    var body: some View {
        
        List{
            ForEach(items) { item in
                NavigationLink {
//                    MiniPlayer(selectedSong:item.value ?? "" , songsCat_Item:category.value ?? "unknownItem")
                    MiniPlayer(selectedSong:item.value ?? "" , songsCat_Item:category.value ?? "unknownItem", songsList1: songsArray)
                  //  MiniPlayer(selectedSong:item.value ?? "" , songsCat_Item:category.value ?? "unknownItem")
                }label:{
                    HStack{
                        Image( item.value ?? "")
                            .resizable()
                            .frame(width: 70,height: 70)
                            .cornerRadius(20)
                        Spacer()
                        Text(item.value ?? "")
                        Spacer()
                        Spacer()
                    } 
                }
            }
            .onDelete(perform: delete(Offsets: ))
        }
        //-----deleteme
        .onAppear(perform: {
            SongsAppend()
        })
        
        //----
        .navigationTitle(category.value ?? "playlist songs")
        ///
        .toolbar {
            ToolbarItem {
                Button {
                    isAddSongViewisPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $isAddSongViewisPresented) {
                    AddSongsToPlaylist(category:category)
                }
            }
        }
        
        
    }
      
    func delete(Offsets:IndexSet){
        withAnimation {
            Offsets.forEach { offset in
                let item = items[offset]
                do{
                    try PersistenceController.shared.delete(item)
                }catch{
                    print(error.localizedDescription)
                }
                
                
            }
        }
    } 
}

