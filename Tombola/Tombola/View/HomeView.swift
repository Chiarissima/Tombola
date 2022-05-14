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

    var body: some View {
        
        Color(red: 1.0, green: 0.9137, blue: 0.6275)
                .overlay(
                    VStack(spacing: 20){
                        
                        Image("Bingo")
                            .resizable()
                            .scaledToFit()
                            
                        
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
                            print("Classifica")
                            classificaController.isClassificaViewPresented = true
                        }label: {
                            GameButton(title: "Classifica", backgroundColor: Color(.systemOrange))
                        }.fullScreenCover(isPresented: $classificaController.isClassificaViewPresented){
                            ClassificaView()
                        }
                        
                    }).edgesIgnoringSafeArea(.vertical)
                
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
