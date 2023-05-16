import SwiftUI

struct settingsj: View {
    
    @State var expand = false
    @Namespace var animation
    
    
    
    
    var songsList = ["song5","Pablo","song12","riseup"]
    
    
    @Environment(\.managedObjectContext) private var viewContext

    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"nameDB", ascending: true)])
    private var allSongs:FetchedResults<SongsDB>
    //
    
    
    var body: some View {
        
        List{
            
            ForEach(allSongs){each in
 
                NavigationLink {
                    MiniPlayer(selectedSong: each.nameDB ?? "riseup", songsCat_Item: "helo dummy settingsj", songsList1: songsList)
                } label: {
                    HStack{
                        Image(each.nameDB ?? "unknown")
                            .resizable()
                            .frame(width: 70,height: 70)
                            .cornerRadius(20)
                        
                        Text("    \(each.nameDB ?? "unknown")")
                            .font(.title3)
                        Spacer()
                        Button {
                            
                            
                            print("i am ready to play --- --- \(each.nameDB ?? "unknown each.nameDB") ")
                        } label: {
                            Image(systemName: each.isfav ? "heart.fill" : "heart")
                                .foregroundColor(Color.red)
                                .onTapGesture {
                                    
                                    
                                    each.isfav.toggle()
                                    try! viewContext.save()
                                    
                                    do{
                                        try viewContext.save()
                                    }catch{
                                        print(error.localizedDescription)
                                    }
                                    
                                    
                                }
                        }
                        
                        
                    }
                }

                
                
                
                
                
            }
            .onDelete(perform: removeSongsDB)
            
            
        }
        .padding(.bottom,80)
    }
    
    
    
    
    
    func removeSongsDB(at offsets : IndexSet){
        for offset in offsets{
            let songs = allSongs[offset]
            viewContext.delete(songs)
            
        }
        try! viewContext.save()
    }
    
    
}


