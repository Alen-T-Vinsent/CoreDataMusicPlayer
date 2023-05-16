

import SwiftUI

struct FavouritesPlaylist: View {
    
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataForMiniplayer9env:commonClassOFMiniPlayer
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ SongsDB.nameDB  , ascending: false )])
    private var favs:FetchedResults<SongsDB>

    @State  private var songsArray = Array<String>()
    var songsList = ["song5","Pablo","song12","riseup"]
    @State private var unlikeSong:String = ""
    @State private var likedSong:String = ""
    
    //@State  var songsArray = Array<String>()
    
    func SongsAppend(){
        songsArray = []
        for item in favs {
            if item.isfav == true {
                songsArray.append(item.nameDB ?? "Nil")
            }
                        
        }
        print("\(songsArray) this is evndataForMiniplayer9env")
    }
    
    func eachSongsAppend(){
            songsArray.append("\(likedSong)")
        print("\(songsArray) this is evndataForMiniplayer9env")
    }
    
    func songsDelete(){
        if let index = songsArray.firstIndex(of: "\(unlikeSong)") {
            songsArray.remove(at: index)
        }
        print(songsArray)
        print("here is songs array of liked")
    }
    
    func checksSongIndex(){
        for song in 0...dataForMiniplayer9env.songsList22.count-1{
            if dataForMiniplayer9env.songsList22[song] == dataForMiniplayer9env.selectedSong22 {
                dataForMiniplayer9env.currentSongIndex22 = song
            }
        }
    }

    
    var body: some View {
        
       // List{
            
        List(favs){each in
            
            if each.isfav {
            
                
                NavigationLink {

                   MiniPlayer( selectedSong: each.nameDB ?? "riseup", songsCat_Item: "Liked ", songsList1:songsArray)
                    
                } label: {
                    if(each.isfav){
                        HStack{
                            Image(each.nameDB ?? "unknown")
                                .resizable()
                                .frame(width: 70,height: 70)
                                .cornerRadius(20)
                            Spacer()
                            Text(each.nameDB ?? "unknown")
                            
                            
                        Spacer()
                        }
                    }
                }
                
           }//list ending
            
        }
        .onAppear {
            SongsAppend()
        }
        
        
    }
}

