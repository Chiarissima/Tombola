//
//  FirebaseService.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine
import FirebaseFirestore
import SwiftUI

final class FirebaseService: NSObject {
    
    let auth: Auth
    static let shared = FirebaseService()
    let db = Firestore.firestore()
    
    var cronologia = Array(repeating: 0, count: 9)
    var cronologiaTot =  Array(repeating: 0, count: 90)
    var indiceCronologia : Int = 0
    var numEstratto: Int = 0
    var numEstrattoGiusto: Int = 0
    var numbers = Array(1...90)
    @Published var emails : [String] = []
    @Published var scores : [Int] = []
    
    @Published var game: Game!
    
    override init() {
        self.auth = Auth.auth()
        super.init()
    }
    
    
    //salvo online il gioco creato dal metodo createNewGame()
    func createOnlineGame() {
        
        do {
            //setto parametri del documento
            try FirebaseReference(.Game).document(self.game.id).setData(from: self.game)
        } catch {
            print("Error creating online game: ", error.localizedDescription)
        }
        
    }
    
    func startGame(with userId: String) {
        
        //controllo se c'è un gioco a cui partecipare. Se non c'è lo creo, altrimenti mi unisco
        //e sto in ascolto per ogni cambiamento del gioco
        FirebaseReference(.Game).whereField("player2Id", isEqualTo: "").whereField("player1Id", isNotEqualTo: userId).getDocuments { querySnapshot, error in
            
            if (error != nil) {
                print("Error starting game")
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
                //update game object
                self.updateGame(self.game)
                self.listenForGameChanges()
                //richiamo metodo per estrazione
                guard self.game != nil else { return }
                self.estrazione()
                
            } else {
                self.createNewGame(with: userId)
            }
        }
    }
    
    func listenForGameChanges() {
        //continuo ad ascoltare per ogni modifica: prendo costantemente le notifiche, push dowm e update gioco
        FirebaseReference(.Game).document(self.game.id).addSnapshotListener { [self] documentSnapshot, error in
            print("Changes received from Firebase")
            
            if error != nil {
                print("Error listening to changes")
                return
            }
            
            //se non ci sono errori
            if let snapshot = documentSnapshot {
                //converto il documento in gioco e lo assegno all'oggetto game
                self.game = try? snapshot.data(as: Game.self)
            }
        }
    }
    
    
    func createNewGame(with userId: String) {
        print("Creating game for userId: ", userId)
        self.game = Game(id: UUID().uuidString, player1Id: userId, player2Id: "", amboWinnerId: "", ternaWinnerId: "", quaternaWinnerId: "", cinquinaWinnerId: "", tombolaWinnerId: "", numeriEstratti: [])
        //salvo online
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func updateGame(_ game: Game) {
        //permette agli altri giocatori di unirsi al gioco
        do {
            //setto parametri del documento
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
    
    
    func estrazione() {
        guard game != nil else { return }
        let timer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { timer in
            if timer.isValid {
                guard self.game != nil else {
                    timer.invalidate()
                    return
                }
                
                if (self.game.player2Id != "" && self.game.player1Id != "" && self.game.tombolaWinnerId != ""){
                    timer.invalidate()
                }
                if ((self.game!.numbers.count) > 0){
                    self.numEstratto = (self.game!.numbers.randomElement())!
                    print("Numero estratto generato: ", self.numEstratto)
                    self.game!.numeriEstratti.append(self.numEstratto)
                    self.game!.numbers.removeAll { value in
                        return value == self.numEstratto
                    }
                }
            } else {
                timer.invalidate()
            }
            self.updateGame(self.game!)
        }
    }
    
    func addInClassifica(with userId: String) {
        
        db.collection("Classifica").document(userId).setData(["Email": userId, "Score":0])
        
    }
    
    
    func getUtentiClassifica() -> Array<String> {
        
        db.collection("Classifica").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.emails.removeAll()
                for document in snapshot!.documents {
                    
                    let email = document.get("Email") as! String
                    if !(self.emails.contains(email)){
                        self.emails.append(email)
                    }
                }
            }
        }
        print(self.emails)
        return emails
    }
    
    func getPunteggiClassifica() -> Array<Int> {
        
        db.collection("Classifica").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.scores.removeAll()
                for document in snapshot!.documents {
                    
                    let score = document.get("Score") as! Int
                    self.scores.append(score)
                }
            }
        }
        print(self.scores)
        return scores
    }
    
    func updateAmbo(with userId: String){
        guard game != nil else { return }
        game.amboWinnerId = userId
        
    }
    
    func updateTerna(with userId: String){
        guard game != nil else { return }
        game.ternaWinnerId = userId    }
    
    func updateQuaterna(with userId: String){
        guard game != nil else { return }
        game.quaternaWinnerId = userId
    }
    
    func updateCinquina(with userId: String){
        guard game != nil else { return }
        game.cinquinaWinnerId = userId
    }
    
    func updateTombola(with userId: String){
        guard game != nil else { return }
        game.tombolaWinnerId = userId
    }
    
    func updateScoreAmbo(with username: String){
        db.collection("Classifica").document(username).updateData(["Score": FieldValue.increment(Int64(2))])
    }
    
    func updateScoreTerna(with username: String){
        db.collection("Classifica").document(username).updateData(["Score": FieldValue.increment(Int64(3))])
    }
    
    func updateScoreQuaterna(with username: String){
        db.collection("Classifica").document(username).updateData(["Score": FieldValue.increment(Int64(4))])
    }
    
    func updateScoreCinquina(with username: String){
        db.collection("Classifica").document(username).updateData(["Score": FieldValue.increment(Int64(5))])
    }
    
    func updateScoreTombola(with username: String){
        db.collection("Classifica").document(username).updateData(["Score": FieldValue.increment(Int64(6))])
    }
}

