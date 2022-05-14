//
//  ContentView.swift
//  Tombola
//  Created by Chiara Tagani on 10/05/22.
//

import SwiftUI

struct HomeeView: View {
        
    //devo avere accesso alla UsernameViewModel, la inizializzo
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        
        Color(red: 1.0, green: 0.9137, blue: 0.6275)
                .overlay(
                    VStack(spacing: 20){
                        Image("Bingo")
                            .resizable()
                            .scaledToFit()
                            
                        
                        
                        Button {
                            print("Inizia")
                            viewModel.isUsernameViewPresented = true
                        }label: {
                            GameButton(title: "Inizia", backgroundColor: Color(.systemRed))
                        }
                    }).edgesIgnoringSafeArea(.vertical)
                .fullScreenCover(isPresented: $viewModel.isUsernameViewPresented){
            //indichi quale view vuoi mostrare
            UsernameView(viewModel: UsernameViewModel())
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeeView()
    }
}
