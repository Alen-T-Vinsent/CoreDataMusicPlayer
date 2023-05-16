import SwiftUI

struct BlurView: UIViewRepresentable {
   
    func makeUIView(context: Context) -> some UIView {
        
        print("i am make ui view")
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return view
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("i am update ui view")
    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
            .preferredColorScheme(.dark)
    }
}
