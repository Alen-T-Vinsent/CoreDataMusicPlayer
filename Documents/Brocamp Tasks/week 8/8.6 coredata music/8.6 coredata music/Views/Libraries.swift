import SwiftUI

struct Libraries: View {
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ Category.value, ascending: true )],animation: .default)
    private var categories:FetchedResults<Category>
    
    //@State var categories:Category

    @State var popUpAddNewPlaylist:Bool = false
    
    
    
    var body: some View {
        
            
       
        NavigationView {
        List{
            VStack{
                NavigationLink {
                    FavouritesPlaylist()
                } label: {
                    Image("favs")
                        .resizable()
                        .frame(width: 380 , height: 100)
                        .overlay(alignment:.bottom){
                            Text("Liked Songs")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .shadow(color: .black, radius: 0.3,x:0,y:0)
      
                    }
                }
                
            }
            .frame(width: 380 , height: 100)
            .shadow(color: Color.black.opacity(1), radius: 0.3 ,x: 0, y:10)
            
            
            ForEach(categories) { category in
                VStack{
                    NavigationLink{
                        let itemsFetchRequest = FetchRequest<Item>(sortDescriptors: [NSSortDescriptor(keyPath: \Item.value, ascending: true)],predicate :NSPredicate(format: "%K CONTAINS[cd] %@",#keyPath(Item.categories),category),animation: .default)
                        CategoryView(category: category)
                    } label: {

                        PlaylistCard(playListName: category.value ?? "")
                    }
                }
            }
            .onDelete(perform: delete(offsets:))
            .listStyle(.plain)
        }
        .navigationTitle("Library")
        .toolbar{
            ToolbarItem(placement: .primaryAction) {
                Button {
                    popUpAddNewPlaylist = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
            //navi ending
        }
        .sheet(isPresented: $popUpAddNewPlaylist) {
            AddNewPlaylist()
        }
    }
    
    private  func delete(offsets:IndexSet){
        offsets.forEach { offset in
            let category = categories[offset]
            do{
                try PersistenceController.shared.delete(category)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
}

