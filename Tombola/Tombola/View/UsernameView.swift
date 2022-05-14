//
//  UsernameView.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI

struct UsernameView: View {
    
    //devo avere accesso alla UsernameViewModel, la inizializzo
    @StateObject var viewController = UsernameViewController()
    
    @State private var username = ""
    
    var body: some View {
        Color(red: 1.0, green: 0.9137, blue: 0.6275)
            .overlay(
                VStack(spacing: 20){
                    Image("Bingo")
                        .resizable()
                        .scaledToFit()
                        
                    
                    
                    Button {
                        print("Gioca")
                        viewController.isGameViewPresented = true
                    }label: {
                        GameButton(title: "Gioca", backgroundColor: Color(.systemRed))
                    }
                    
                    TextField("Inserisci username", text: $username)
                                .textFieldStyle(.roundedBorder)
                                .padding()
                    
                }).edgesIgnoringSafeArea(.vertical)
                .fullScreenCover(isPresented: $viewController.isGameViewPresented){
            //indichi quale view vuoi mostrare
            HomeView(viewController: HomeViewController())
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView()
    }
}
