//
//  GameView.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var viewController: GameViewController
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        GeometryReader { geometry in
            
            Color(red: 1.0, green: 0.9137, blue: 0.6275)
                    .overlay(
                
            VStack {
                Text(viewController.gameNotification)
                
                if viewController.game?.player2Id == "" {
                    LoadingView()
                }
                
                VStack{
                    LazyVGrid(columns: viewController.colums, spacing: 1){
                        ForEach(0..<9) { i in
                            
                            ZStack {
                                GameSquareView(proxy: geometry)
                                PlayerIndicatorView(systemImageName: viewController.game?.moves[i]?.indicator ?? "square")
                            }.onTapGesture {
                                print("Tap on spot", i)
                                viewController.processPlayerMove(for: i)
                            }
                        }
                    }
                }
                
                .disabled(viewController.checkForGameBoardStatus())
                .padding()
                .alert(item: $viewController.alertItem) { alertItem in
                    //if-else statement
                    alertItem.isForQuit ? Alert(title: alertItem.title, message: alertItem.message, dismissButton: .destructive(alertItem.buttonTitle, action: {
                        self.mode.wrappedValue.dismiss()
                        viewController.quitGame()
                    }))
                    : Alert(title: alertItem.title, message: alertItem.message, primaryButton: .default(alertItem.buttonTitle, action: {
                        //reset game
                        viewController.resetGame()
                    }), secondaryButton: .destructive(Text("Quit"), action: {
                        self.mode.wrappedValue.dismiss()
                        viewController.quitGame()
                    }))
                }
                
                Spacer()
                
                Button{
                    print("Quit the game")
                    mode.wrappedValue.dismiss()
                    //Richiama func firebase che elimina da db il gioco
                    viewController.quitGame()
                } label: {
                    GameButton(title: "Quit", backgroundColor: .red)
                }
            }
            
        )}.onAppear(){
            viewController.getTheGame()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewController: GameViewController())
    }
}
