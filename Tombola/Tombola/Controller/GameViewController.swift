//
//  GameViewController.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI
import Combine

final class GameViewController: ObservableObject {
    @AppStorage("user") private var userData: Data?
        
    let colums: [GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible())]
    
    //everytime game is set, we call some functions
    //check game status
    @Published var game: Game? {
        didSet {
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
    
    //Array "vuoto" iniziale per i 15 numeri casuali
    var a = Array(repeating: 0, count: 15)
    
    //Array che corrispondono alle 3 righe della Card, inizialmente "vuoti"
    var ar = Array(repeating: 0, count: 9)
    var br = Array(repeating: 0, count: 9)
    var cr = Array(repeating: 0, count: 9)
    
    //Nascondere celle con numero = 0
    var ar0 = Array(repeating: "", count: 9)
    var br0 = Array(repeating: "", count: 9)
    var cr0 = Array(repeating: "", count: 9)
    
    //numero max di numeri per riga = 5
    var v1: Int = 5
    var v2: Int = 5
    var v3: Int = 5
    
    //numero max di muneri per colonna = 3 + tot numeri = 15
    var tot: Int = 15
    var c0: Int = 3
    var c1: Int = 3
    var c2: Int = 3
    var c3: Int = 3
    var c4: Int = 3
    var c5: Int = 3
    var c6: Int = 3
    var c7: Int = 3
    var c8: Int = 3
    
    //controllo per selezionare/deselezionare bottoni cliccati
    var r1 = Array(repeating: Color.white, count: 9)
    var r2 = Array(repeating: Color.white, count: 9)
    var r3 = Array(repeating: Color.white, count: 9)
    var rCard1 = Array(repeating: false, count: 9)
    var rCard2 = Array(repeating: false, count: 9)
    var rCard3 = Array(repeating: false, count: 9)
    var buttonColor: Color = .white
    
    //conrollo per premi = terna/cinquina/tombola
    var cro = Array(repeating: 0, count: 90)
    var cro1 = Array(repeating: 0, count: 9)
    var cro0 = Array(repeating: "", count: 9)
    var txtPremio: String = "TERNA"
    var terna1: Int = 0
    var terna2: Int = 0
    var terna3: Int = 0
    var cinq1: Int = 0
    var cinq2: Int = 0
    var cinq3: Int = 0
    
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
    
    //Metodo per settare 15 numeri casuali con max 3 numeri per decina
    func getRandomNumber() -> Array<Int> {
        while tot > 0 {
            for i in 0...14 {
                var r = Int.random(in: 1...90)
                if ((a[i] == 0) && !a.contains(r)){
                    if ((r >= 1) && (r <= 9) && (c0 > 0)) {
                        a[i] = r;
                        c0-=1;
                        tot-=1;
                    } else if ((r >= 10) && (r <= 19) && (c1 > 0)){
                        a[i] = r;
                        c1-=1;
                        tot-=1;
                    } else if ((r >= 20) && (r <= 29) && (c2 > 0)){
                        a[i] = r;
                        c2-=1;
                        tot-=1;
                    } else if ((r >= 30) && (r <= 39) && (c3 > 0)){
                        a[i] = r;
                        c3-=1;
                        tot-=1;
                    } else if ((r >= 40) && (r <= 49) && (c4 > 0)){
                        a[i] = r;
                        c4-=1;
                        tot-=1;
                    } else if ((r >= 50) && (r <= 59) && (c5 > 0)){
                        a[i] = r;
                        c5-=1;
                        tot-=1;
                    } else if ((r >= 60) && (r <= 69) && (c6 > 0)){
                        a[i] = r;
                        c6-=1;
                        tot-=1;
                    } else if ((r >= 70) && (r <= 79) && (c7 > 0)){
                        a[i] = r;
                        c7-=1;
                        tot-=1;
                    } else if ((r >= 80) && (r <= 90) && (c8 > 0)){
                        a[i] = r;
                        c8-=1;
                        tot-=1;
                    }
                }
            }
        }
        return a.sorted()
    }
    
    //Metodo per popolare correttamente la Card con 15 numeri divisi per decine
    func setCards(array: Array<Int>) -> (ar: Array<Int>, br: Array<Int>, cr: Array<Int>) {
        for i in stride(from: 0, to: 14, by: 3) {
            if (array[i] <= 9) {
                ar[0] = array[i]
            } else if ((array[i] >= 10) && (array[i] <= 19)){
                ar[1] = array[i]
            } else if ((array[i] >= 20) && (array[i] <= 29)){
                ar[2] = array[i]
            } else if ((array[i] >= 30) && (array[i] <= 39)){
                ar[3] = array[i]
            } else if ((array[i] >= 40) && (array[i] <= 49)){
                ar[4] = array[i]
            } else if ((array[i] >= 50) && (array[i] <= 59)){
                ar[5] = array[i]
            } else if ((array[i] >= 60) && (array[i] <= 69)){
                ar[6] = array[i]
            } else if ((array[i] >= 70) && (array[i] <= 79)){
                ar[7] = array[i]
            } else if ((array[i] >= 80) && (array[i] <= 90)){
                ar[8] = array[i]
            }
        }
        for i in stride(from: 1, to: 14, by: 3) {
            if (array[i] <= 9) {
                br[0] = array[i]
            } else if ((array[i] >= 10) && (array[i] <= 19)){
                br[1] = array[i]
            } else if ((array[i] >= 20) && (array[i] <= 29)){
                br[2] = array[i]
            } else if ((array[i] >= 30) && (array[i] <= 39)){
                br[3] = array[i]
            } else if ((array[i] >= 40) && (array[i] <= 49)){
                br[4] = array[i]
            } else if ((array[i] >= 50) && (array[i] <= 59)){
                br[5] = array[i]
            } else if ((array[i] >= 60) && (array[i] <= 69)){
                br[6] = array[i]
            } else if ((array[i] >= 70) && (array[i] <= 79)){
                br[7] = array[i]
            } else if ((array[i] >= 80) && (array[i] <= 90)){
                br[8] = array[i]
            }
        }
        for i in stride(from: 2, to: 15, by: 3) {
            if (array[i] <= 9) {
                cr[0] = array[i]
            } else if ((array[i] >= 10) && (array[i] <= 19)){
                cr[1] = array[i]
            } else if ((array[i] >= 20) && (array[i] <= 29)){
                cr[2] = array[i]
            } else if ((array[i] >= 30) && (array[i] <= 39)){
                cr[3] = array[i]
            } else if ((array[i] >= 40) && (array[i] <= 49)){
                cr[4] = array[i]
            } else if ((array[i] >= 50) && (array[i] <= 59)){
                cr[5] = array[i]
            } else if ((array[i] >= 60) && (array[i] <= 69)){
                cr[6] = array[i]
            } else if ((array[i] >= 70) && (array[i] <= 79)){
                cr[7] = array[i]
            } else if ((array[i] >= 80) && (array[i] <= 90)){
                cr[8] = array[i]
            }
        }
        return (ar, br, cr)
    }
    
    //Metodo per trasformaziione celle con num = 0 in celle vuote
    func rimuoviZeri(ar: Array<Int>, br: Array<Int>, cr: Array<Int>) -> (ar0: Array<String>, br0: Array<String>, cr0: Array<String>) {
        for i in 0...8 {
            if (ar[i] == 0){
                ar0[i] = ""
            } else {
                ar0[i] = String(ar[i])
            }
        }
        for j in 0...8 {
            if (br[j] == 0){
                br0[j] = ""
            } else {
                br0[j] = String(br[j])
            }
        }
        for z in 0...8 {
            if (cr[z] == 0){
                cr0[z] = ""
            } else {
                cr0[z] = String(cr[z])
            }
        }
        return (ar0, br0, cr0)
    }
    
    //Metodo che controlla selezione/deselezione celle
    func checkSelected(rCard1: Array<Bool>, rCard2: Array<Bool>, rCard3: Array<Bool>) -> (r1: Array<Color>, r2: Array<Color>, r3: Array<Color>) {
        for s in 0...8 {
            if (rCard1[s] == false){
                r1[s] = Color.white
            } else {
                r1[s] = Color.yellow
            }
        }
        for p in 0...8 {
            if (rCard2[p] == false){
                r2[p] = Color.white
            } else {
                r2[p] = Color.yellow
            }
        }
        for q in 0...8 {
            if (rCard3[q] == false){
                r3[q] = Color.white
            } else {
                r3[q] = Color.yellow
            }
        }
        return (r1, r2, r3)
    }
    
    //Metodo che attesta Premio = Terna/Cinquina/Tombola
    func checkPremio (cro: Array<Int>, ar: Array<Int>, br: Array<Int>, cr: Array<Int>, rCard1: Array<Bool>, rCard2: Array<Bool>, rCard3: Array<Bool>, r1: Array<Color>, r2: Array<Color>, r3: Array<Color>) -> String{
        if (txtPremio == "TERNA"){
            terna1 = 0
            for i in 0...8 {
                if ((ar[i] != 0) && (rCard1[i] == true) && cro.contains(ar[i])){
                    terna1 += 1
                } else if ((ar[i] != 0) && (rCard1[i] == true) && !cro.contains(ar[i])){
                    self.r1[i] = Color.red
                    self.rCard1[i] = false
                }
            }
            terna2 = 0
            for i in 0...8 {
                if ((br[i] != 0) && (rCard2[i] == true) && cro.contains(br[i])){
                    terna2 += 1
                } else if ((br[i] != 0) && (rCard2[i] == true) && !cro.contains(br[i])){
                    self.rCard2[i] = false
                }
            }
            terna3 = 0
            for i in 0...8 {
                if ((cr[i] != 0) && (rCard3[i] == true) && cro.contains(cr[i])){
                    terna3 += 1
                } else if ((cr[i] != 0) && (rCard3[i] == true) && !cro.contains(cr[i])){
                    self.rCard3[i] = false
                }
            }
            if ((terna1 >= 3) || (terna2 >= 3) || (terna3 >= 3)) {
                txtPremio = "CINQUINA"
            }
        } else if (txtPremio == "CINQUINA"){
            cinq1 = 0
            for i in 0...8 {
                if ((ar[i] != 0) && (rCard1[i] == true) && cro.contains(ar[i])){
                    cinq1 += 1
                }
            }
            cinq2 = 0
            for i in 0...8 {
                if ((br[i] != 0) && (rCard2[i] == true) && cro.contains(br[i])){
                    cinq2 += 1
                }
            }
            cinq3 = 0
            for i in 0...8 {
                if ((cr[i] != 0) && (rCard3[i] == true) && cro.contains(cr[i])){
                    cinq3 += 1
                }
            }
            if ((cinq1 >= 5) || (cinq2 >= 5) || (cinq3 >= 5)) {
                txtPremio = "TOMBOLA"
            }
        } else if (txtPremio == "TOMBOLA"){
            cinq1 = 0
            for i in 0...8 {
                if ((ar[i] != 0) && (rCard1[i] == true) && cro.contains(ar[i])){
                    cinq1 += 1
                }
            }
            cinq2 = 0
            for i in 0...8 {
                if ((br[i] != 0) && (rCard2[i] == true) && cro.contains(br[i])){
                    cinq2 += 1
                }
            }
            cinq3 = 0
            for i in 0...8 {
                if ((cr[i] != 0) && (rCard3[i] == true) && cro.contains(cr[i])){
                    cinq3 += 1
                }
            }
            if ((cinq1 >= 5) && (cinq2 >= 5) && (cinq3 >= 5)) {
                txtPremio = "!!! WIN !!!!"
            }
        }
        return txtPremio
    }
}

