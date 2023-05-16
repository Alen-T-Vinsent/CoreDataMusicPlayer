import SwiftUI

struct DeveloperLogin: View {
    
    @State var name: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @State var showDeveloperScreen:Bool = false
    @State var showAlert:Bool = false
    @AppStorage("username") private var username = "Alen"
    @AppStorage("userkey") private var userKey = "14307"
    
    
    var isSignInButtonDisabled: Bool {
        [name, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        NavigationView {
            List{
                VStack(alignment: .leading, spacing: 15) {
                    Spacer()
                    
                    TextField("Name",
                              text: $name ,
                              prompt: Text("Login").foregroundColor(.gray)
                    )
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Group {
                            if showPassword {
                                TextField("Password",
                                          text: $password,
                                          prompt: Text("Password").foregroundColor(.gray))
                            } else {
                                SecureField("Password",
                                            text: $password,
                                            prompt: Text("Password").foregroundColor(.gray))
                            }
                        }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        
                        HStack{
                            Button {
                                
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(Color.red)
                        
                        
                        
                    }.padding(.horizontal)
                    
                    Spacer()
                    
                    HStack{
                        Button {
                            print("doing login action...")
                            
                            if name == username && password == userKey{
                                showDeveloperScreen = true
                            }else{
                                showAlert = true
                                name = ""
                                password = ""
                                }
                            
                        } label: {
                            Text("Sign In")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(
                            isSignInButtonDisabled ?
                           // LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                            //    LinearGradient(colors: [.black, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                            Color.gray : Color.black
                        )
                        .cornerRadius(20)
                        .disabled(isSignInButtonDisabled)
                        .padding()
                    }
                }
                .navigationTitle("Login to enter developer mode")
                .navigationBarTitleDisplayMode(.inline)
                
                Section(header:Text("Info   \(Image(systemName: "info.circle"))")){
                    Text("By Entering developer mode you can easily delete and and add songs according to your preference . We ensure your privacy so we don't track you , you can download song from any source and you can add song to  SHORTIFY music player")
                        .font(.footnote)
                }
            }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Account doesnot exist"),
                  message: Text("please check username and password"),
                  dismissButton:.default(Text("Got it!"))
            )
            
        })
        .sheet(isPresented:$showDeveloperScreen) {
            settingsj()
        }
    }
}

