//
//  Home2.swift
//  8.6 coredata music
//
//  Created by Apple  on 22/11/22.
//

import SwiftUI

struct Home2: View {
    
    var songsList = ["song5","Pablo","song12","riseup"]
    @Environment(\.managedObjectContext) var viewContext
    @State private var searchText:String = ""
    
    @ObservedObject var dataForMiniplayer6:commonClassOFMiniPlayer

    var body: some View {
        NavigationView {
            
            
            VStack{
                //list of matching songDB names
                FilteredList(filter: searchText)
                
            }
            .navigationTitle("Shortie")
            .searchable(text: $searchText)
            .navigationBarItems( trailing: Button(action: {
                print("songs added to db")
                addSongToDB()
            }, label: {
                Text("+ DB")
                    .foregroundColor(Color.black)
                    .shadow(color:.white, radius: 0.3,x:0.2,y:0.2)
            }))
        }
        
    }
    
    private func addSongToDB(){
        for eachSong in 0..<self.songsList.count {
            let song = SongsDB(context: viewContext)
            song.idDB = UUID()
            song.nameDB = "\(songsList[eachSong])"
        }
        try? viewContext.save()
    }
    
    
    
}


