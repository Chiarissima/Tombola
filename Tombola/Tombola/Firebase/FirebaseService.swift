//
//  FirebaseService.swift
//  Tombola
//
//  Created by Chiara Tagani on 13/05/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

final class FirebaseService: ObservableObject {
    
    static let shared = FirebaseService()
    
    @Published var game: Game!
    
    init() {}
    
    
    //saves the game online created by createNewGame()
    func createOnlineGame() {
        
        do {
            //set parameters of the document
            try FirebaseReference(.Game).document(self.game.id).setData(from: self.game)
        } catch {
            print("Error creating online game: ", error.localizedDescription)
        }
        
    }
    
    func startGame(with userId: String) {
        
        //check if there is a game to join in. If not, we create a new game, if yes
        //we will join and start listening for any changes in the game
        FirebaseReference(.Game).whereField("player2Id", isEqualTo: "").whereField("player1Id", isNotEqualTo: userId).getDocuments { querySnapshot, error in
            
            if (error != nil) {
                print("Error starting game", error?.localizedDescription)
                //create a new game
                self.createNewGame(with: userId)
                return
            }
            
            //se la query ritorna game objects, prendo il primo elemento
            if let gameData = querySnapshot?.documents.first {
                //converto il dictionary in un game object
                self.game = try? gameData.data(as: Game.self)
                //update parameters
                self.game.player2Id = userId
                self.game.blockMoveForPlayerId = userId
               
                //update game object
                self.updateGame(self.game)
                self.listenForGameChanges()
            } else {
                self.createNewGame(with: userId)
            }
        }
    }
    
    func listenForGameChanges() {
        //keep listening for any changes and constantly grab all changes and push down and update game object
        FirebaseReference(.Game).document(self.game.id).addSnapshotListener { documentSnapshot, error in
            print("Changes received from Firebase")
            
            if error != nil {
                print("Error listening to changes", error?.localizedDescription)
                return
            }
            
            //if there are not errors
            if let snapshot = documentSnapshot {
                //convert document to game and assign to game object
                self.game = try? snapshot.data(as: Game.self)
            }
        }
        
    }
    
    
    func createNewGame(with userId: String) {
        print("Creating game for userId: ", userId)
        self.game = Game(id: UUID().uuidString, player1Id: userId, player2Id: "", blockMoveForPlayerId: userId, winningPlayerId: "", rematchPlayerId: [], moves: Array(repeating: nil, count: 9))
        
        //now we save online
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func updateGame(_ game: Game) {
        //permette agli altri giocatori di unirsi al gioco
        do {
            //set parameters of the document
            try FirebaseReference(.Game).document(game.id).setData(from: game)
        } catch {
            print("Error updating online game: ", error.localizedDescription)
        }
    }
    
    func quitGame() {
        
        //devo eliminare il gioco per uscire. L'id del documento è lo stesso id del gioco
        //controllo che il gioco non sia nil, altrimenti crasha
        
        guard game != nil else { return }
        FirebaseReference(.Game).document(self.game.id).delete()
    }
    
}

