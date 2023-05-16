import SwiftUI

struct SongCard: View {
   // var songggg:SongsModel
    
    @State  var SongCardName:String
    
    var body: some View {
        VStack{
            Image( SongCardName )
           // Image(systemName:"figure.walk")

                .resizable()
                .overlay(alignment:.bottom){
                    Text("\(SongCardName)")
                        .background(Color.black.opacity(0.2))
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 0.3,x:0,y:0)
                        .frame(maxWidth: 100)
                        .padding()
                
        }
    }
        
        .frame(width: 160 , height:160 ,alignment:.top)
//        .background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.3),Color(.gray)]), startPoint: .top, endPoint: .bottom))
        .background(Image("dj").resizable().frame(width: 160 , height:160 ,alignment:.top))
        .clipShape(RoundedRectangle(cornerRadius: 20,style: .continuous))
        .shadow(color: Color.black.opacity(1), radius: 0.3 ,x: 0, y:1)
    
}

}

