//
//  HomeView.swift
//  Tombola
//  Created by Chiara Tagani on 10/05/22.
//

import SwiftUI

struct HomeView: View {
        
    //devo avere accesso alla UsernameViewModel, la inizializzo
    @StateObject var viewController = HomeViewController()
    @StateObject var classificaController = ClassificaViewController()
    @StateObject var regolamentoController = RegolamentoViewController()
    @StateObject var authController = AuthenticationViewController()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        
        Color(red: 1.0, green: 0.9137, blue: 0.6275)
                .overlay(
                    VStack(spacing: 20){
                        
                        Button(action: {
                            authController.signOut()
                            print("Logout effettuato con successo!")
                            mode.wrappedValue.dismiss()
                        }, label: {
                            Text("Logout")
                                .foregroundColor(Color.orange)
                                
                        }).frame(width: 300, alignment: .topLeading)
                        
                        
                        Image("Bingo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200, alignment: .topLeading)
                            
                        
                        Button {
                            print("Inizia")
                            viewController.isGameViewPresented = true
                        }label: {
                            GameButton(title: "Inizia", backgroundColor: Color(.systemRed))
                        }.fullScreenCover(isPresented: $viewController.isGameViewPresented){
                            //indichi quale view vuoi mostrare
                            GameView(viewController: GameViewController())
                            }
                        
                        Button {
                            print("Regolamento")
                            regolamentoController.isRegolamentoViewPresented = true
                        }label: {
                            GameButton(title: "Regolamento", backgroundColor: Color(.systemBlue))
                        }.fullScreenCover(isPresented: $regolamentoController.isRegolamentoViewPresented){
                            //indichi quale view vuoi mostrare
                            RegolamentoView()
                            }
                    
                        
                        Button {
                            print("Classifica")
                            classificaController.isClassificaViewPresented = true
                        }label: {
                            GameButton(title: "Classifica", backgroundColor: Color(.systemOrange))
                        }.fullScreenCover(isPresented: $classificaController.isClassificaViewPresented){
                            ClassificaView(viewController: ClassificaViewController())
                        }
                        
                        //var nome = UserDefaults.standard.string(forKey: "username")!
                        //Text("Ciao "+nome)
                        
                        
                    }).edgesIgnoringSafeArea(.vertical)
            .frame(alignment: .topLeading)
                
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
