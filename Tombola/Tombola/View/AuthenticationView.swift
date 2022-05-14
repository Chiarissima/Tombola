//
//  UsernameView.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI

struct AuthenticationView: View {
    
    //devo avere accesso alla UsernameViewModel, la inizializzo
    @StateObject var viewController = AuthenticationViewController()
    
    @State var isLoginMode = false
    @State var username = ""
    @State var password = ""
    
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
                        TextField("Email", text: $username)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color(.white))

                    Button {
                        print("Entra")
                        viewController.isGameViewPresented = true
                    }label: {
                        GameButton(title: isLoginMode ? "Login" : "Registrati", backgroundColor: Color(.systemRed))
                    }
                    
                    }
                }
                .padding()
                .background(Color(red: 1.0, green: 0.9137, blue: 0.6275)
                                .ignoresSafeArea())

            }
            .navigationTitle(isLoginMode ? "Login" : "Registrati")
            .background(Color(red: 1.0, green: 0.9137, blue: 0.6275)
                            .ignoresSafeArea())
            .fullScreenCover(isPresented: $viewController.isGameViewPresented){
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
