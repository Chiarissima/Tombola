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
        
        GeometryReader { geometry in
            
            VStack(alignment: .center, spacing: 15) {
                
                Button(action: {
                    authController.signOut()
                    print("Logout effettuato con successo!")
                    mode.wrappedValue.dismiss()
                }, label: {
                    Text("Logout")
                        .foregroundColor(Color.orange)
                        
                }).frame(width: 300, alignment: .leading)
                    .padding()
            
                Image("bingoLottery")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    
                Button {
                    print("Gioca")
                    viewController.isGameViewPresented = true
                }label: {
                    GameButton(title: "Gioca", backgroundColor: Color(.systemRed))
                }.fullScreenCover(isPresented: $viewController.isGameViewPresented){
                    //indico quale view vuoi mostrare
                    GameView(viewController: GameViewController())
                    }
                
                Button {
                    print("Regolamento")
                    regolamentoController.isRegolamentoViewPresented = true
                }label: {
                    GameButton(title: "Regolamento", backgroundColor: Color(.systemPurple))
                }.fullScreenCover(isPresented: $regolamentoController.isRegolamentoViewPresented){
                    //indichi quale view vuoi mostrare
                    RegolamentoView()
                    }
            
                
                Button {
                    print("Punteggi")
                    classificaController.isClassificaViewPresented = true
                }label: {
                    GameButton(title: "Punteggi", backgroundColor: Color(.systemOrange))
                }.fullScreenCover(isPresented: $classificaController.isClassificaViewPresented){
                    ClassificaView(viewController: ClassificaViewController())
                }
                
                
                Text(UserDefaults.standard.string(forKey: "username")!)
                    .frame(width: 300, height: 100)
                    .padding()
                    .font(Font.custom("Academy Engraved LET", size: 20.0))
                    .foregroundColor(Color(red: 0.8745, green: 0.3098, blue:0.051))
            }
        }
        .padding()
        .background(Color(red: 1.0, green: 0.9137, blue: 0.6275))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
