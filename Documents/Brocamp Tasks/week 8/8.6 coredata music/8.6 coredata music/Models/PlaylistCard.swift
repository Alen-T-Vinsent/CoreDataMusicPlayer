
import SwiftUI

struct PlaylistCard: View {
    
    @State var playListName:String
    
    var body: some View {
        VStack{
            
            Image("dj")
                .resizable()
                .frame(width: 380 , height: 100)
                
                .overlay(alignment:.bottom){
                    Text(playListName)
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 0.3,x:0,y:0)
                        
                        
                    
            }
                
                    

            
        }
        
        
        .frame(width: 380 , height: 100)
        //.background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.3),Color(.gray)]), startPoint: .top, endPoint: .bottom))
//        .clipShape(RoundedRectangle(cornerRadius: 20,style: .continuous))
        .shadow(color: Color.black.opacity(1), radius: 0.3 ,x: 0, y:10)
    }
        
}

