//
//  GameView.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

struct GameView: View {
    //Sposto in GameViewModel
    //let colums: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                Text(viewModel.gameNotification)
                
                if viewModel.game?.player2Id == "" {
                    LoadingView()
                }
                
                VStack{
                    LazyVGrid(columns: viewModel.colums, spacing: 1){
                        ForEach(0..<9) { i in
                            
                            ZStack {
                                GameSquareView(proxy: geometry)
                                PlayerIndicatorView(systemImageName: viewModel.game?.moves[i]?.indicator ?? "square")
                            }.onTapGesture {
                                print("Tap on spot", i)
                                viewModel.processPlayerMove(for: i)
                            }
                        }
                    }
                }
                
                .disabled(viewModel.checkForGameBoardStatus())
                .padding()
                .alert(item: $viewModel.alertItem) { alertItem in
                    //if-else statement
                    alertItem.isForQuit ? Alert(title: alertItem.title, message: alertItem.message, dismissButton: .destructive(alertItem.buttonTitle, action: {
                        self.mode.wrappedValue.dismiss()
                        viewModel.quitGame()
                    }))
                    : Alert(title: alertItem.title, message: alertItem.message, primaryButton: .default(alertItem.buttonTitle, action: {
                        //reset game
                        viewModel.resetGame()
                    }), secondaryButton: .destructive(Text("Quit"), action: {
                        self.mode.wrappedValue.dismiss()
                        viewModel.quitGame()
                    }))
                }
                
                Spacer()
                
                Button{
                    print("Quit the game")
                    mode.wrappedValue.dismiss()
                    //Richiama func firebase che elimina da db il gioco
                    viewModel.quitGame()
                } label: {
                    GameButton(title: "Quit", backgroundColor: .red)
                }
            }
            
        }.onAppear(){
            viewModel.getTheGame()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
