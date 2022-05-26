//
//  UsernameView.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI

struct AuthenticationView: View {
    
    //devo avere accesso alla UsernameViewModel, la inizializzo
    @StateObject var authController = AuthenticationViewController()
    @State var isLoginMode = false
    @State var isSignedIn = false
    @State var signUp = false
    @State var username = ""
    @State var password = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    Image("Bingo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Registrati")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())

                    Group {
                        TextField("Username", text: $username)
                        SecureField("Password", text: $password)
                    }
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(12)
                    .background(Color(.white))

                    Button(action: {
                        print("Button clicked")
                        //guard !username.isEmpty, !password.isEmpty else { return }
                        if username.isEmpty || password.isEmpty {
                            print("Compila i campi")
                        }
                        
                        isLoginMode ? authController.signIn(username: username, password: password) { isSignedIn in
                            if isSignedIn == true {
                                self.isSignedIn.toggle()
                            } else {
                                print("Login non effettuato")
                            }
                        } : authController.signUp(username: username, password: password) { signUp in
                            
                            if username.isEmpty || password.isEmpty {
                                print("Compila i campi per la registrazione")
                            } else {
                                if(username.contains("@")){
                                    if(password.count < 6){
                                        print("Inserire password con almeno 8 caratteri")
                                    }else{
                                        if signUp == true{
                                            self.showAlert.toggle()
                                        } else {
                                            print("Registrazione non effettuata")
                                        }
                                    }
                                }else{
                                    print("inserire email")
                                }
                            }
                        }
                    }, label: {
                        GameButton(title: isLoginMode ? "Login" : "Registrati", backgroundColor: Color(.systemRed))
                    }).alert(isPresented: $showAlert) { () -> Alert in
                        Alert(title: Text("Attenzione!"), message: Text("Registrazione effettuata!"), dismissButton: .default(Text("OK")))
                        }
                    .refreshable {
                        print("Refresh")
                    }
                }
            }.padding()
            .background(Color(red: 1.0, green: 0.9137, blue: 0.6275)
            .ignoresSafeArea())
            

        }.navigationTitle(isLoginMode ? "Login" : "Registrati")
        .background(Color(red: 1.0, green: 0.9137, blue: 0.6275)
                        .ignoresSafeArea())
        .fullScreenCover(isPresented: $isSignedIn){
            //indichi quale view vuoi mostrare
            HomeView(viewController: HomeViewController())
        }
    }
}


struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
