//
//  ContentView.swift
//  Tombola
//
//  Created by Chiara Tagani on 10/05/22.
//

import SwiftUI

struct HomeView: View {
        
    //devo avere accesso alla HomeViewModel, la inizializzo
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        
        VStack{
            Button {
                print("Hello")
                //isGameViewPresented.toggle()
                //sostituito da
                viewModel.isGameViewPresented = true
            }label: {
                GameButton(title: "Play", backgroundColor: Color(.systemGreen))
            }
        }.fullScreenCover(isPresented: $viewModel.isGameViewPresented){
            //indichi quale view vuoi mostrare
            GameView(viewModel: GameViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
