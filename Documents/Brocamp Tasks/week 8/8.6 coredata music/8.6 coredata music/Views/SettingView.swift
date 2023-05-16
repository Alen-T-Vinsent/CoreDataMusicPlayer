import SwiftUI

struct SettingView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isDevMode") private var isDevMode = false
    var body: some View {
        NavigationView {
            VStack{
                List{
                    Section(header:Text("light mode / dark mode")){
                        Toggle("Dark Mode", isOn: $isDarkMode)

                    }
                    
                    Section(header:Text("Developer mode")){
                        Toggle("Developer Mode", isOn: $isDevMode)

                    }
                    
                }
                .sheet(isPresented: $isDevMode) {
                    DeveloperLogin()
                }
        
                
            }
            .accentColor(Color.gray)
            .navigationTitle("Settings")

        }
        
        
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
