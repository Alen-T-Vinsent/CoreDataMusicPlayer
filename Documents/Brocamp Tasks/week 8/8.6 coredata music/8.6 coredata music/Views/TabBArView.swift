
import SwiftUI
import MediaPlayer
import AVKit


@MainActor class commonClassOFMiniPlayer:ObservableObject{
    
    //MARK: published vars
    @Published var recentlyPlayed = UserDefaults.standard.string(forKey: "recentlyPlayed")
    @Published var isPlaying = false
    @Published var  songsList22 = ["song5","Pablo","song12","riseup"]
    @Published var selectedSong22:String =  "riseup"
    @Published var currentSongIndex22:Int = 0
    @Published var player2:AVAudioPlayer!
    @Published var audioSession = AVAudioSession.sharedInstance()
    @Published var player = AVPlayer()
//    @Published  var songsArray = Array<String>()
    
    //MARK: functions
    //MARK: func from medium
    
    
    
    func setupRemoteTransportControls() {
        
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [self ] event in
            if player2 == nil{
                prepareSong()
                player2.play()
                return .success
            }
            print("Play command - is playing:\(player2.isPlaying)")
            if player2.isPlaying==false{
                //                player2.play()
                playNpause()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [] event in
            
            
            if self.player2 == nil{
                self.prepareSong()
            }
            
            print("Pause command - is playing: \(self.player2.isPlaying)")
            
            if self.player2.isPlaying {
                self.player2.pause()
                return .success
            }
            return .commandFailed
        }
        
        
        //add handler for next command
        commandCenter.nextTrackCommand.addTarget { [] event in
            print("next button tapped command")
            self.nextSong()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget{ [] event in
            self.previousSong()
            return .success
        }
        
        
    }
    
    func setupNowPlaying() {
        //lastedi
        // Define Now Playing Info
//        var nowPlayingInfo = [String : Any]()
//        nowPlayingInfo[MPMediaItemPropertyTitle] = songsList22[currentSongIndex22]
        
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = songsList22[currentSongIndex22]
        
        if let image = UIImage(named:songsList22[currentSongIndex22]) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
            
            
            if let path =
                Bundle.main.path(forResource: "\(songsList22[currentSongIndex22]).mp3", ofType: nil) {
                let asset = AVAsset(url: URL(fileURLWithPath: path))
                let playerItem = AVPlayerItem(asset: asset)
                print(playerItem)
                print("hello i am player item 000000000")
                player.replaceCurrentItem(with: playerItem)
                
                
                
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem.currentTime().seconds
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.asset.duration.seconds
                nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
                
                // Set the metadata
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                
            }
        }
        
    }
    
    
    func pause() {
        player2.pause()
        //        playPauseButton.setTitle("Play", for: UIControl.State.normal)
        updateNowPlaying(isPause: true)
        print("Pause - current time: \(player2.currentTime) - is playing: \(player2.isPlaying)")
    }
    
    func updateNowPlaying(isPause: Bool) {
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    //MARK: func from meduim end
    
    
    func prepareSong(){
        let url = Bundle.main.path(forResource:songsList22[currentSongIndex22], ofType: "mp3")
        player2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
        player2.prepareToPlay()
    }
    
    func playNpause(){
        if player2 == nil {
            prepareSong()
        }
        if player2.isPlaying{
            player2.pause()
            isPlaying = false
        }else{
            player2.play()
            isPlaying = true
        }
    }
    
    
    func firstAppear(){
        if let path =
            Bundle.main.path(forResource: "\(songsList22[currentSongIndex22]).mp3", ofType: nil) {
            let asset = AVAsset(url: URL(fileURLWithPath: path))
            let playerItem = AVPlayerItem(asset: asset)
            print(playerItem)
            print("hello i am player item 00000")
            player.replaceCurrentItem(with: playerItem)
        }
        
        try! audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
        try! self.audioSession.setActive(true)
        setupNowPlaying()
    }
    
    func nextSong(){
        if player2 == nil {
            prepareSong()
        }
        if currentSongIndex22 == songsList22.count-1{
            player2.stop()
            isPlaying = false
            currentSongIndex22 = 0
            prepareSong()
            player2.play()
            isPlaying = true
        }else{
            player2.stop()
            isPlaying = false
            currentSongIndex22 += 1
            prepareSong()
            player2.play()
            isPlaying = true
            print(songsList22[currentSongIndex22])
            firstAppear()
        }
        print("inside next song")
        print(currentSongIndex22)
    }
    
    func previousSong(){
        if player2 == nil {
            prepareSong()
        }
        if currentSongIndex22 == 0{
            player2.stop()
            isPlaying = false
            currentSongIndex22 = songsList22.count-1
            prepareSong()
            player2.play()
            isPlaying = true
        }else{
            player2.stop()
            isPlaying = false
            currentSongIndex22 -= 1
            prepareSong()
            player2.play()
            isPlaying = true
        }
        firstAppear()
    }
    
    
    
}

struct TabBArView: View {
    
    
    //MARK: namespace
    @Namespace var animation
    
    //MARK: @State
    @State var expand:Bool = false
    @State var current:Int = 0
    @State var songsList = ["song5","Pablo","song12","riseup"]
    
    
    //MARK: stateObjects
    @StateObject var dataForMiniPlayer1 = commonClassOFMiniPlayer()
    // @StateObject var vml22 = ViewModel22()
    
    
    //MARK: enviornment
    @Environment(\.managedObjectContext) var env
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SongsDB.nameDB, ascending: true)],
                  animation: .default)var songs:FetchedResults<SongsDB>
    
    
    //MARK: views
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $current) {
                // HomeView()
                Home2(dataForMiniplayer6:dataForMiniPlayer1)
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                Libraries()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Library")
                    }
                
                //settingsj()
                SettingView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("settings")
                    }
                
            }
            
            
            MiniPlayerWithDB(expand: $expand, animation: animation, dataForMiniplayer2: dataForMiniPlayer1)
            
        }
        .environmentObject(dataForMiniPlayer1)
        
    }
    
    
}


struct MiniPlayerWithDB: View {

    //MARK: @states
    @State var player:AVAudioPlayer!
    @State var width1:CGFloat = 0
    @State var volume:CGFloat = 0
    @State var songToPlay:Int = 0
    
    //MARK: @bindings
    @Binding var expand:Bool
    
    
    //MARK: vars
    var animation:Namespace.ID
    var height = UIScreen.main.bounds.height / 3
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    //MARK: @ObservedObject
    // @StateObject  var dataForMiniplayer2 = ViewModel22()
    @ObservedObject var dataForMiniplayer2:commonClassOFMiniPlayer
    
    
    //MARK: @Enviornment
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataForMiniplayer3env:commonClassOFMiniPlayer
    
    //MARK: @FetchRequest
    @FetchRequest(entity:SongsDB.entity() ,sortDescriptors: [NSSortDescriptor(key: "isfav", ascending: false)]) private var alSongs:FetchedResults<SongsDB>
    
    @FetchRequest(sortDescriptors:[NSSortDescriptor(keyPath:\SongsDB.nameDB, ascending: true)],animation:.default)
    var allSongs:FetchedResults<SongsDB>
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ Category.value, ascending: true )],animation: .default)
    private var categories:FetchedResults<Category>
    
    //MARK: view
    var body: some View {
        
        
        VStack(){
            Capsule()
                .fill(Color.gray.opacity(0))
                .frame(width: expand ? 60 : 0 ,height:  expand ? 2 : 0)
                .opacity(expand ? 1 : 0)
                .padding(.top,expand ? safeArea?.top : 0 )
                .padding(.vertical,expand ? 30 : 0 )
            
            
            HStack(spacing: 15) {
                
                
                
                //centering image.......
                if expand{Spacer(minLength: 0)}
                
                Image("\(dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22])")
                //lastedit1
                // Image("\(dataForMiniplayer2.selectedSong22)")
                    .resizable()
                    .frame(width:expand ? height : 55, height: expand ? height : 55)
                    .cornerRadius(15)
                
                
                if !expand{
                    
                    Text("\(dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22])")
                        .font(.title2)
                        .fontWeight(.bold)
                        .matchedGeometryEffect(id: "label", in: animation)
                }
                
                Spacer(minLength: 0)
                
                if !expand{

                    Button {
                        
                        print("back button pressed")
                        
                        dataForMiniplayer3env.previousSong()
                        
                    }label: {
                        Image(systemName: "backward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    
                    Button {
                        print("play button pressed")

                        dataForMiniplayer3env.playNpause()
                         
                    } label: {
                        //Image(systemName: isPlaying ? "pause.fill" : "play.fill" )
                        Image(systemName: dataForMiniplayer2.isPlaying ? "pause.fill" : "play.fill" )
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    Button {
                        
                        
                        print("next button pressed")
                        
                        // nextSong()
                        dataForMiniplayer3env.nextSong()
                    } label: {
                        Image(systemName:"forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    
                    
                    //if !expand ending
                }
            }
            .onAppear(perform: {
                
                //last try
                if let path =
                    Bundle.main.path(forResource: "\(dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22]).mp3", ofType: nil) {
                    let asset = AVAsset(url: URL(fileURLWithPath: path))
                    let playerItem = AVPlayerItem(asset: asset)
                    print(playerItem)
                    print("hello i am player item 000000000")
                    dataForMiniplayer2.player.replaceCurrentItem(with: playerItem)
                    
                    
                }
                
                
                try! dataForMiniplayer2.audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
                try! self.dataForMiniplayer2.audioSession.setActive(true)
                
                dataForMiniplayer2.setupRemoteTransportControls()
                
                dataForMiniplayer2.setupNowPlaying()
                
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                    if dataForMiniplayer2.player2 == nil{
                        dataForMiniplayer2.prepareSong()
                    }
                    if dataForMiniplayer2.player2.isPlaying{
                        print("music time \(dataForMiniplayer2.player2.currentTime)")
                        let screen = UIScreen.main.bounds.width - 30
                        let value = dataForMiniplayer2.player2.currentTime/dataForMiniplayer2.player2.duration
                        width1 = screen * CGFloat(value)
                    }
                }
                
                
            })
            .padding()
            .padding(.horizontal)
            
            
            VStack{
                HStack{
                    if expand{
                        
                        Text("\(dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22])")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                            .matchedGeometryEffect(id:"label", in: animation)
                    }
                    
                    Spacer(minLength: 0)
                    
//                    Button {
//
//
//
//                    } label: {
//
//                        Image(systemName:"heart")
//                            .font(.title2)
//                            .foregroundColor(.red)
//                    }
                    
                    
                    Menu{
                        ForEach(categories) { category in
                            Button {
                                // savePlaylist()
                                print("here is the category name")
                                print(category)
                                let catogory = category
                                let song = Item(context: viewContext)
                                song.value = ("\(dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22])")
                                
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
                }
                .padding()
                .padding(.horizontal,50)
                
                //hstack ended
                Spacer(minLength:30)
                
                //                HStack{
                //                    Capsule()
                //                        .fill(LinearGradient(gradient: .init(colors: [Color.white.opacity(0.7),Color.white.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))
                //                        .frame(height: 2)
                //
                //                    //Text("godha expanded")
                //
                //                    Text("\(dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22])")
                //                        .shadow(color:.black , radius: 1.3)
                //                        .font(.title2)
                //                        .foregroundColor(.white)
                //                        .fontWeight(.bold)
                //
                //
                //
                //                    Capsule()
                //                        .fill(LinearGradient(gradient: .init(colors: [Color.white.opacity(0.1),Color.white.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                //                        .frame(height: 2)
                //                }
                
                
                HStack{
                    Capsule()
                        .fill(LinearGradient(gradient: .init(colors: [Color.black.opacity(0.7),Color.white.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))
                        .frame(height: 2)
                    
                    
                    Text(" \("All songs :") Playlist")
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
                        dataForMiniplayer2.previousSong()
                        
                    }label: {
                        Image(systemName: "backward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    
                    Button {
                        print("expand play button pressed")
                        dataForMiniplayer2.playNpause()
                    } label: {
                        Image(systemName: dataForMiniplayer2.isPlaying ? "pause.fill" : "play.fill" )
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                        
                    }
                    Button {
                        
                        print("expand next button pressed")
                        
                        //recentProgress2.recentlyPlayed = "song12"
                        
                        dataForMiniplayer3env.nextSong()
                        
                        
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.top,20)
                
                
                
                
                
                
                ZStack(alignment: .leading){
                    Capsule().fill(Color.black.opacity(0.08)).frame(height: 8)
                    Capsule().fill(Color.red).frame(width:width1,height: 8)
                    Circle().fill(Color.red).frame(width: 20,height: 20)
                        .padding(.leading,width1-3)
//                    Slider(value: $width1,in:0...1000)
                        .gesture(DragGesture()
                            .onChanged({ (value) in
                                let x = value.location.x
                                self.width1 = x
                                
                            }).onEnded{ (value) in
                                
                                let x = value.location.x
                                let screen = UIScreen.main.bounds.width - 30
                                let percent = x / screen
                                dataForMiniplayer2.player2.currentTime = Double(percent) * dataForMiniplayer2.player2.duration
                                
                               
                                
                                
                            })
                    
                    
                }
                .padding()
                .padding(.top)
                .padding(.bottom,safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
                
                Spacer()
                
                
            }
            .padding(.top)
            //this will give stretching effect
            .frame(width: expand ? nil : 0 , height: expand ? nil : 0 )
            .opacity(expand ? 1 : 0)
            
            
            
            
            //main v stack ending
        }
        .environmentObject(dataForMiniplayer3env)
        
        
        
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
                .onTapGesture(perform: {
                    withAnimation(.spring()){expand.toggle()}
                    //perform ending
                })
            
            //ending of background
        )
        .offset(y: expand ? 0 : -49)
        
        
    }
    
    func playNpause(){
        
        if player.isPlaying{
            
            player.pause()
            dataForMiniplayer2.isPlaying = false
            
        }else{
            
            player.play()
            dataForMiniplayer2.isPlaying = true
            
        }
    }
    
    
    
    func nextSong(){
        
        if dataForMiniplayer2.currentSongIndex22 == dataForMiniplayer2.songsList22.count-1{
            player.stop()
            dataForMiniplayer2.isPlaying = false
            
            
            dataForMiniplayer2.currentSongIndex22 = 0
            
            let url = Bundle.main.path(forResource:dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22], ofType: "mp3")
            player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            
            
            player.play()
            dataForMiniplayer2.isPlaying = true
            
        }else{
            player.stop()
            dataForMiniplayer2.isPlaying = false
            
            
            dataForMiniplayer2.currentSongIndex22 += 1
            
            
            let url = Bundle.main.path(forResource:dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22], ofType: "mp3")
            player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            
            player.play()
            dataForMiniplayer2.isPlaying = true
            
            print(dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22])
        }
        
        print("inside next song")
        print(dataForMiniplayer2.currentSongIndex22)
    }
    
    func previousSong(){
        
        if dataForMiniplayer2.currentSongIndex22 == 0{
            player.stop()
            dataForMiniplayer2.isPlaying = false
            
            dataForMiniplayer2.currentSongIndex22 = dataForMiniplayer2.songsList22.count-1
            
            let url = Bundle.main.path(forResource:dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22], ofType: "mp3")
            player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            
            
            player.play()
            dataForMiniplayer2.isPlaying = true
            
        }else{
            
            player.stop()
            dataForMiniplayer2.isPlaying = false
            dataForMiniplayer2.currentSongIndex22 -= 1
            
            
            let url = Bundle.main.path(forResource:dataForMiniplayer2.songsList22[dataForMiniplayer2.currentSongIndex22], ofType: "mp3")
            player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            
            player.play()
            dataForMiniplayer2.isPlaying = true
        }
        
        print("inside next song")
        print(dataForMiniplayer2.currentSongIndex22)
    }
    
    
    func checksSongIndex(){
        for song in 0...dataForMiniplayer2.songsList22.count-1{
            if dataForMiniplayer2.songsList22[song] == dataForMiniplayer2.selectedSong22 {
                dataForMiniplayer2.currentSongIndex22 = song
            }
        }
    }
    
}

