import SwiftUI
import CoreData
import AVKit

struct HomeView: View{

    @Environment(\.managedObjectContext) private var viewContext
    var songsList = ["song5","Pablo","song12","riseup"]
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SongsDB.nameDB, ascending: true)],
                  animation: .default)var fetchedSongs:FetchedResults<SongsDB>
    
    
    @State private var songsFetched:Array = Array<String>()
    @State private var searchText:String = ""
    
    //    @State var expand = true
    @State var isPlaying = false
    @State var player:AVAudioPlayer!
    @State var selectedSong:String!
    
    @State var showPlayer:Bool = false
    
    // @Namespace var animation
    
    
    
    
    var searcher = Array<String>()
    
    func currentSongg()-> Int{
        for songIndex in 0...songsList.count-1{
            if fetchedSongs[songIndex].nameDB == selectedSong!{
                
                return songIndex
            }
        }
        return 0
    }
    
    
    
    var body: some View {
        
        NavigationView {
            
            List{
                
                ForEach(fetchedSongs){each in
     
                    NavigationLink {
                        //destination
                        MiniPlayer(selectedSong: each.nameDB ?? "riseup", songsCat_Item: "dummy homeview", songsList1: songsList)
                        
                    } label: {
                        //label
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
            }
            .padding(.bottom,80)
            .navigationTitle("All songs" )
            .searchable(text: $searchText)
            .navigationBarItems( trailing: Button(action: {
                print("songs added to db")
                addSongToDB()
            }, label: {
                Text("+ DB")
                    .foregroundColor(Color.black)
                    .shadow(color:.white, radius: 0.3,x:0.2,y:0.2)
            }))
            
            
            
            Spacer()
            
            
            
        }
        
    }
    
    
    
    
    
    
    
}


extension HomeView{
    
    
    private func addSongToDB(){
        for eachSong in 0..<self.songsList.count {
            let song = SongsDB(context: viewContext)
            song.idDB = UUID()
            song.nameDB = "\(songsList[eachSong])"
        }
        try? viewContext.save()
    }

    
    
    var searchedSongArray:FetchedResults<SongsDB>{
        
        if searchText == "" { return fetchedSongs}
        //return songsList.filter{$0.lowercased().contains(searchText.lowercased()) }
        
        return fetchedSongs
    }
    
    
    
    
}





