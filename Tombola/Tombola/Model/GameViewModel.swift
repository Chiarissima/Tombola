//
//  GameViewModel.swift
//  Tombola
//
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI
import Combine

final class GameViewModel: ObservableObject {
    @AppStorage("user") private var userData: Data?
        
    let colums: [GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible())]
    
    @Published var game: Game? {
        //everytime game is set, we call some functions
        didSet {
            //check game status
            checkIfGameIsOver()
            if game == nil { updateGameNotificationFor(.finished) } else {
                game?.player2Id == "" ? updateGameNotificationFor(.waitingForPlayer) : updateGameNotificationFor(.started)
            }
        }
    }
    
    @Published var currentUser: User!
    @Published var alertItem: AlertItem?
    @Published var gameNotification = GameNotification.waitingForPlayer
    
    private var cancellables: Set<AnyCancellable> = []
    
    //Set of winning positions
    private let winPattern: Set<Set<Int>> = [ [0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6] ]
    
    init() {
        retrieveUser()
        
        if currentUser==nil {
            saveUser()
        }
        
        print("We have a user with id: ", currentUser.id)
        
    }
    
    func getTheGame() {
        FirebaseService.shared.startGame(with: currentUser.id)
        FirebaseService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
        
    }
    
    //process everytime the user clicks on the specific round
    //if the index is free to be clicked and it's free we want to check who is clicking it
    func processPlayerMove(for position: Int) {
        
        //controllo che ci sia un gioco, altrimenti esci
        guard game != nil else { return }
        
        //check if the position GameSquareView is occupied, per non fare override
        //faccio unwrap dell'oggetto game ed essere sicura che l'oggetto game esista affinchè vada l'app
        if isSquaredOccupied(in: game!.moves, forIndex: position) { return }
        
        //isPlayer1: true stabilisce che escano solo X se clicchi
        game!.moves[position] = Move(isPlayer1: isPlayerOne(), boardIndex: position)
        
        //block the move for the specific user
        game!.blockMoveForPlayerId = currentUser.id
        
        FirebaseService.shared.updateGame(game!)
        
        //check for win
        if checkForWinCondition(for: true, in: game!.moves) {
            game!.winningPlayerId = currentUser.id
            FirebaseService.shared.updateGame(game!)
            print("You have won")
            return
        }
        
        //check for draw
        if checkForDraw(in: game!.moves){
            game!.winningPlayerId = "0"
            FirebaseService.shared.updateGame(game!)
            print("Draw!")
            return
        }
        
    }
    
    func isSquaredOccupied(in moves:[Move?], forIndex index: Int) -> Bool {
        
        return moves.contains(where: { $0?.boardIndex==index })
    }
    
    func checkForWinCondition(for player1: Bool, in moves: [Move?]) -> Bool {
        //remove all nils and check if moves left belong to user1 or user2
        let playerMoves = moves.compactMap { $0 }.filter{ $0.isPlayer1 == player1 }
        //compare moves with set. Convert moves to set
        let playerPositions = Set(playerMoves.map { $0.boardIndex } )
        
        for pattern in winPattern where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
        
    }
    
    func checkForDraw(in moves:[Move?]) -> Bool {
        
        return moves.compactMap { $0 }.count==9
    }
    
    func quitGame(){
        FirebaseService.shared.quitGame()
    }
    
    //funzione che controlla se il game board è bloccato.
    //True se è bloccato, altrimenti false
    func checkForGameBoardStatus() -> Bool {
        
        //Check if the game it's not nil.
        //If it's not, we are going to return true if it's blocked for the current user
        return game != nil ? game!.blockMoveForPlayerId == currentUser.id : false
        
    }
    
    
    func isPlayerOne() -> Bool {
        //if the player1 is the currentUser.id we return true, otherwise it's false
        return game != nil ? game!.player1Id == currentUser.id : false
    }
    
    func checkIfGameIsOver() {
        alertItem = nil
        guard game != nil else { return }
        
        //check if game is finished
        if game!.winningPlayerId == "0" {
            //parità
            alertItem = AlertContext.draw
        } else if game!.winningPlayerId != "" {
            //se non è vuoto, il gioco continua, ci sono altre moves
            if game!.winningPlayerId == currentUser.id {
                //abbiamo vinto
                alertItem = AlertContext.youWin
            } else {
                //abbiamo perso
                alertItem = AlertContext.youLost
            }
        }
        //se non è nessuno dei due, uno dei giocatori ha vinto e vogliamo sapere chi
    }
    
    func resetGame(){
        guard game != nil else {
            alertItem = AlertContext.quit
            return
        }
        
        //if the other hasn't left, check how many items we have in this rematch
        if game!.rematchPlayerId.count == 1 {
            //start new game
            game!.moves = Array(repeating: nil, count: 9)
            game!.winningPlayerId = ""
            //block move for player 2
            game!.blockMoveForPlayerId = game!.player2Id
        }else if game!.rematchPlayerId.count == 2 {
            //reset rematchId
            game!.rematchPlayerId = []
        }
        
        game!.rematchPlayerId.append(currentUser.id)
        
        FirebaseService.shared.updateGame(game!)
    }
    
    func updateGameNotificationFor(_ state: GameState){
        
        switch state {
        case .started:
            gameNotification = GameNotification.gameHasStarted
        case .waitingForPlayer:
            gameNotification = GameNotification.waitingForPlayer
        case .finished:
            gameNotification = GameNotification.gameFinished
        }
        
    }
    
    
    //check if there is already a user
    //MARK: User object
    
    func saveUser() {
        
        currentUser = User()
        do{
            print("Encoding user object")
            let data = try JSONEncoder().encode(currentUser)
            userData = data
        } catch {
            print("Couldn't save user object")
        }
    }
    
    func retrieveUser(){
        
        guard let userData = userData else { return }
        
        do{
            print("Decoding user")
            currentUser = try JSONDecoder().decode(User.self, from: userData)
        }catch{
            print("No user saved")
        }
    }
}
