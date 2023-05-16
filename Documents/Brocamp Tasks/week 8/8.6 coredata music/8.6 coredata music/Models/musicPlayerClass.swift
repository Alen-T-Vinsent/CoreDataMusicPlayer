import Foundation
import AVFoundation


class musicPlayerClass:ObservableObject{
    
    @Published var isPlaying:Bool = false
    @Published var title = ""
    @Published var artist = ""
    @Published var artwork = Data(count: 0)
    @Published var type = ""
    
}
