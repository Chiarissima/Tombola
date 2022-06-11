//
//  AuthenticationView.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI

struct AuthenticationView: View {
    
    //devo avere accesso alla AuthenticationViewController, la inizializzo
    @StateObject var authController = AuthenticationViewController()
    @State var isSignedIn = false
    @State var isLoginMode = false
    @State var username = ""
    @State var password = ""
    
    @State private var alert = false
    @State private var alertItem : AlertItem = .signUpOk
    
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    
                    Image("biglieTombola")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                    
                    Text("TOMBOLA")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.07, saturation: 0.172, brightness: 0.412))
                        .multilineTextAlignment(.center)
                        .frame(height: 100)
                    
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
                        
                        isLoginMode ? authController.signIn(username: username, password: password) { isSignedIn in
                            
                            if username.isEmpty || password.isEmpty {
                                print("Compila i campi")
                                self.alertItem = .fields
                                self.alert.toggle()
                            } else {
                            
                                if isSignedIn == true {
                                    self.isSignedIn.toggle()
                                } else {
                                    print("Login non effettuato")
                                    self.alertItem = .loginFail
                                    self.alert.toggle()
                                }
                            }
                        } : authController.signUp(username: username, password: password) { isSignedUp in
                            
                            if username.isEmpty || password.isEmpty {
                                print("Compila i campi per la registrazione")
                                self.alertItem = .fields
                                self.alert.toggle()
                            } else {
                                if !username.contains("@") {
                                    print("Inserire mail")
                                    self.alertItem = .emailFail
                                    self.alert.toggle()
                                } else {
                                    if(password.count < 6){
                                        print("Inserire password con almeno 8 caratteri")
                                        self.alertItem = .passwordFail
                                        self.alert.toggle()
                                    }else{
                                        if isSignedUp == true{
                                            self.alertItem = .signUpOk
                                            self.alert.toggle()
                                        } else {
                                            print("Registrazione non effettuata")
                                            self.alertItem = .signUpFail
                                            self.alert.toggle()
                                        }
                                    }
                                }
                            }
                        }
                    }, label: {
                        GameButton(title: isLoginMode ? "Login" : "Registrati", backgroundColor: Color(red:0.7412, green:0.2157, blue:0.2392))
                    })
                    .alert(isPresented: $alert) {
                        switch alertItem {
                        case .signUpOk:
                            return Alert(title: Text("Registrazione effettuata!"), message: Text("Registrazione effettuata con successo, ora puoi loggarti!"), dismissButton: .default(Text("OK")))
                        case .signUpFail:
                            return Alert(title: Text("Attenzione"), message: Text("Registrazione non effettuata. Riprova!"), dismissButton: .default(Text("OK")))
                        case .loginFail:
                            return Alert(title: Text("Attenzione"), message: Text("Login non effettuato. Riprova!"), dismissButton: .default(Text("OK")))
                        case .fields:
                            return Alert(title: Text("Campi vuoti"), message: Text("Compila tutti i campi"), dismissButton: .default(Text("OK")))
                        case .emailFail:
                            return Alert(title: Text("Attenzione"), message: Text("Inserisci una mail valida"), dismissButton: .default(Text("OK")))
                        case .passwordFail:
                            return Alert(title: Text("Attenzione"), message: Text("Inserisci una password lunga almeno 6 caratteri"), dismissButton: .default(Text("OK")))
                        }
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


struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
