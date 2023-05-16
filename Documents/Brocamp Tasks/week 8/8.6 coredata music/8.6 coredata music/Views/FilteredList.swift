import SwiftUI

struct FilteredList: View {
    
    init(filter:String) {
        
        if filter == ""{
            
            _fetchRequest = FetchRequest<SongsDB>(sortDescriptors: [])
            
        }else{
            
            _fetchRequest = FetchRequest<SongsDB>(sortDescriptors: [],predicate: NSPredicate(format: "nameDB Contains[c] %@",filter))
            
        }
        
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var fetchRequest:FetchedResults<SongsDB>
    @EnvironmentObject var dataForMiniplayer4envFilteredList:commonClassOFMiniPlayer
    @Namespace var animation
    @State private var expand = false
    
    var body: some View {
        List(fetchRequest,id:\.self){each in
            HStack{
                Image("\(each.songsNameManual)")
                    .resizable()
                    .frame(width: 70,height: 70)
                    .cornerRadius(20)
                
                Text("   \(each.songsNameManual)")
                
                Spacer()
                
                Image(systemName: each.isfav ? "heart.fill" : "heart")
                    .onTapGesture {
                        each.isfav.toggle()
                        
                        try! viewContext.save()
                    }
                    .foregroundColor(Color.red)
            }
            .onTapGesture {
                print("\(each.songsNameManual)")
                dataForMiniplayer4envFilteredList.selectedSong22 = each.songsNameManual
                print("from common class -- \(dataForMiniplayer4envFilteredList.selectedSong22)")
                checksSongIndex()
                print("from common class -- \(dataForMiniplayer4envFilteredList.currentSongIndex22)")
                dataForMiniplayer4envFilteredList.prepareSong()
                dataForMiniplayer4envFilteredList.playNpause()
              
                
            }
            .environmentObject(commonClassOFMiniPlayer())
            
        }
        
    }
    
    
    //MARK: functions
    func checksSongIndex(){
        for song in 0...dataForMiniplayer4envFilteredList.songsList22.count-1{
            if dataForMiniplayer4envFilteredList.songsList22[song] == dataForMiniplayer4envFilteredList.selectedSong22 {
                dataForMiniplayer4envFilteredList.currentSongIndex22 = song
            }
        }
    }
    
   
    
}

