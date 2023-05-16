import SwiftUI
import AVKit




struct MiniPlayer: View {
    
    
    init(selectedSong:String,songsCat_Item:String,songsList1:[String]) {
        self.selectedSong = selectedSong
        self.songsCat_Item = songsCat_Item
        _isPlaying = State(initialValue: true)
        songsList = songsList1
        
    
    }
    
    @State var width1:CGFloat = 0
    @State var volume:CGFloat = 0
    @State var player:AVAudioPlayer!
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ Category.value, ascending: true )],animation: .default)
    private var categories:FetchedResults<Category>

    var songsCat_Item:String
    
    
   var songsList = ["song5","Pablo","song12","riseup"]
    @State private var isPlaying:Bool
    @State var expand :Bool = true
    var selectedSong:String
    @State var songToPlay:Int = 0
    @State var currentSongIndex:Int = 0
    
    
    
    var height = UIScreen.main.bounds.height / 3
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets

    var body: some View{
        
        VStack{
            Spacer(minLength:50)
            HStack(spacing: 15) {
                //centering image.......
                if expand{Spacer(minLength: 0)}
               Image(songsList[currentSongIndex])
                    .resizable()
                    .frame(width:expand ? height : 55, height: expand ? height : 55)
                    .cornerRadius(15)
                
                if !expand{
                   // Text("\(selectedSong)")
                    Text("\(songsList[currentSongIndex])")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                }
                
                Spacer(minLength: 0)
                
                if !expand{
                    
                    
                    Button {
                        
                        print("back button pressed")
                        
                        if songToPlay > 0{
                            songToPlay -= 1
                        }else{
                            songToPlay = songsList.count-1
                        }
                        
                        player.stop()
                        isPlaying = false
                        previousSong()
                        
                    }label: {
                        Image(systemName: "backward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    
                    Button {
                        print("play button pressed")
                        
                        playNpause()
                        
                        
                    } label: {
                        Image(systemName: isPlaying ?"pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    Button {
                        
                        print("next button pressed")
                        
                        if songToPlay < songsList.count-1{
                            songToPlay += 1
                        }else{
                            songToPlay = 0
                        }
                        
                        player.stop()
                        
                        
                    } label: {
                        Image(systemName:"forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    
                    
                    //if !expand ending
                }
                
                
            }
            .onAppear(perform: {
                print("----- ---- ---- --- ---- ---- ----- ---- ---")
                print("----- -i am songs list  ---")
                print(songsList)
                print(songsCat_Item)
                print("----- ---- ---- --- ---- ---- ----- ---- ---")
                let url = Bundle.main.path(forResource: selectedSong, ofType: "mp3")
                player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
                player.prepareToPlay()

                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                    if player.isPlaying{
                        print(player.currentTime)
                        let screen = UIScreen.main.bounds.width - 30
                        let value = player.currentTime/player.duration
                        width1 = screen * CGFloat(value)
                    }
                }

                checksSongIndex()

                player.prepareToPlay()

                playNpause()



            })
            .padding()
            .padding(.horizontal)
            
            
            VStack{
                HStack{
                    if expand{
                        
                        
                        Text("   \(selectedSong)")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Menu{
                        ForEach(categories) { category in
                            Button {
                                // savePlaylist()
                                print("here is the category name")
                                print(category)
                                print(songsList[currentSongIndex])
                                let catogory = category
                                let song = Item(context: viewContext)
                                song.value = songsList[currentSongIndex]
                                
                                catogory.addToItems(song)
                                
                                
                                try! viewContext.save()
                            } label: {Text(category.value ?? "")}
                        }
                        

                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .foregroundColor(Color.black)
                            .frame(width: 20,height: 20)
                    }
                    
                    
                    Button {
                        
                    } label: {
                       // Image(systemName: isfav ? "heart.fill" : "heart")
                           // .foregroundColor(Color.red)
                            //.onTapGesture {
                                

                          //      isfav.toggle()

                          //  }
                    }

                }
                
                
            }
            .padding()
            .padding(.horizontal,50)
            
            //hstack ended
            Spacer(minLength:30)
            
            HStack{
                Capsule()
                    .fill(LinearGradient(gradient: .init(colors: [Color.black.opacity(0.7),Color.white.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 2)
            
                Text(" \(songsCat_Item) Playlist")//selectedSongItem from category
                    .shadow(color:.black , radius: 1.3)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Capsule()
                    .fill(LinearGradient(gradient: .init(colors: [Color.white.opacity(0.1),Color.black.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 2)
            }
            Spacer(minLength: 100)
            HStack( alignment:.center ,spacing:50){
                Button {
                    print("expand back button pressed")
                    previousSong()
                }label: {
                    Image(systemName: "backward.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Button {
                    print("expand play button pressed")
                    playNpause()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill" )
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                }
                Button {
                    print("expand next button pressed")
                    nextSong()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.top,20)
            
           // HStack{
                ZStack(alignment:.leading){
                    Capsule().fill(Color.black.opacity(0.08)).frame(height: 8)
                    
                    HStack{
                        ZStack{
                            
                            VStack{
                                Capsule()
                                    .fill(Color.red).frame(width:width1,height: 18)
                                    
                            }
                            VStack{
                                Circle()
                                    
                                    .fill(Color.red).frame(width:25,height: 25)
                                    .padding(.leading,width1)
                                    
                                    
                            }
                            

                        }
                        




                    }
                    .gesture(DragGesture()
                            .onChanged({ (value) in
                                
                                let x = value.location.x
                                self.width1 = x
                                
                            }).onEnded{ (value) in
                                
                                let x = value.location.x
                                let screen = UIScreen.main.bounds.width - 30
                                let percent = x / screen
                                player.currentTime = Double(percent) * player.duration
                                
                            })
                    
                    
                }
                .padding()
                .padding(.top)
                .padding(.bottom,safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
            Spacer()
            
            
        }
        .padding(.top)
        .padding(.bottom,80)
        .frame(width: expand ? nil : 0 , height: expand ? nil : 0 )//this will give stretching effect
        .opacity(expand ? 1 : 0)
        

        //expanding to full screen
        
        .frame(maxHeight: expand ? .infinity: 80)
        //moving miniplayer above the tabbar
        //approz tab bar height is 49
        
        //Divider lin from tabbar and miniplayer
        .background(
            VStack(spacing: 0){
                BlurView()
                Divider()
            }
//                .onTapGesture(perform: {
//                    withAnimation(.spring()){expand.toggle()}
                //perform ending
//                })
 
        //ending of background
        )
         .offset(y: expand ? 0 : -49)

    }

}




extension MiniPlayer{
    
    func checksSongIndex(){
        for song in 0..<songsList.count{
            if songsList[song] == selectedSong {
                currentSongIndex = song
            }
        }
    }
    
    
    
    
    
    func playNpause(){
        
        if player.isPlaying{
            
                player.pause()
                isPlaying = false
            
        }else{
            
            player.play()
            isPlaying = true
            
        }
    }
    

    func previousSong(){
        
        if currentSongIndex == 0{
            
            player.stop()
            isPlaying = false
            
            currentSongIndex = songsList.count-1
            
            let url = Bundle.main.path(forResource:songsList[currentSongIndex], ofType: "mp3")
            player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            
            
            player.play()
            isPlaying = true
            
        }else{
            
            player.stop()
            isPlaying = false
            
            
            currentSongIndex -= 1
            
            
            let url = Bundle.main.path(forResource:songsList[currentSongIndex], ofType: "mp3")
            player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            
            player.play()
            isPlaying = true
        }
        
        print("inside next song")
        print(currentSongIndex)
    }
    
        
   

    


    
    func nextSong(){
        
        if songsList.count == 1{
            
            player.stop()
            isPlaying = false
            
            currentSongIndex = 0
            let url = Bundle.main.path(forResource:songsList[currentSongIndex], ofType: "mp3")
            player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            
            player.play()
            isPlaying = true
            
        }else{
            
            if currentSongIndex == songsList.count-1{
                player.stop()
                isPlaying = false
                
                
                currentSongIndex = 0
                
                let url = Bundle.main.path(forResource:songsList[currentSongIndex], ofType: "mp3")
                player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
                
                
                player.play()
                isPlaying = true
                
            }else{
                player.stop()
                isPlaying = false
                
                
                currentSongIndex += 1
                
                
                let url = Bundle.main.path(forResource:songsList[currentSongIndex], ofType: "mp3")
                player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
                
                player.play()
                isPlaying = true
            }
        }
        
        print("inside next song")
        print(currentSongIndex)
    }
    
    
    
}


