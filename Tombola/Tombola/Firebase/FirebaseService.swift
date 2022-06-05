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

final class FirebaseService: NSObject {
    
    let auth: Auth
    static let shared = FirebaseService()
    
    var cronologia = Array(repeating: 0, count: 9)
    var cronologiaTot =  Array(repeating: 0, count: 90)
    var indiceCronologia : Int = 0
    var numEstratto: Int = 0
    var numEstrattoGiusto: Int = 0
    var timerprova = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    var numbers = Array(1...90)
    let db = Firestore.firestore()
    
    @Published var alertItem: AlertItem?
    //private var timer: Timer!
    //lazy var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(estrazione), userInfo: nil, repeats: true)
    //var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(estrazione), userInfo: nil, repeats: true)
    
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
                //update game object
                self.updateGame(self.game)
                self.listenForGameChanges()
                //richiamo metodo per estrazione
                guard self.game != nil else { return }
                self.richiamaEstrazione()
                
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
                print("Error listening to changes", error?.localizedDescription)
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
        //let timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [self] timer in
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            guard self.game != nil else {
                timer.invalidate()
                return
            }
            
            if (self.game.player2Id != "" && self.game.player1Id != "" && self.game.tombolaWinnerId == ""){
                timer.invalidate()
            }
            if ((self.game!.numbers.count) > 0){
                self.numEstratto = (self.game!.numbers.randomElement())!
                print("Numero estratto generato: ", self.numEstratto)
                self.game!.numeriEstratti.append(self.numEstratto)
                self.game!.numbers.removeAll { value in
                    return value == self.numEstratto
                }
                self.updateGame(self.game!)
            }
        }
        
        if (self.game.tombolaWinnerId != "" ){
            timer.invalidate()
            alertItem = AlertContext.tombola
        }
    }
    
    
    func richiamaEstrazione() {
        
        FirebaseReference(.Game).document(self.game.id).addSnapshotListener { [self] documentSnapshot, error in
            
            if error != nil {
                print("Error listening to changes", error?.localizedDescription)
                return
            }
            
            //se non ci sono errori
            if let snapshot = documentSnapshot {
                //converto il documento in game e lo assegno ad un oggetto game
                guard game != nil else { return }
                if (self.game.player2Id != "" && self.game.player1Id != "" && self.game.tombolaWinnerId == ""){
                    self.estrazione()
                    self.game = try? snapshot.data(as: Game.self)
                }
            }
        }
    }
    
    func updateAmbo(with userId: String){
        guard game != nil else { return }
        game.amboWinnerId = userId
        //updateGame(game)
        //updateScore()
        
    }
    
    func updateTerna(with userId: String){
        guard game != nil else { return }
        game.ternaWinnerId = userId
        //updateGame(game)
        //updateScore()
    }
    
    func updateQuaterna(with userId: String){
        guard game != nil else { return }
        game.quaternaWinnerId = userId
        //updateGame(game)
    }
    
    func updateCinquina(with userId: String){
        guard game != nil else { return }
        game.cinquinaWinnerId = userId
        //updateGame(game)
    }
    
    func updateTombola(with userId: String){
        guard game != nil else { return }
        game.tombolaWinnerId = userId
        //updateGame(game)
    }
    
    /*func startTimer() {
        guard game != nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(estrazione), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }*/
    
    func updateClassifica(with userId: String) {
        
        db.collection("Classifica").document(userId).setData(["Email": userId, "Score":0])
        
    }
    
    
    func getClassifica(){
        
        db.collection("Classifica").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    //print("\(document.documentID)") // Get documentID
                    
                    let documentData = document.data()
                    print(documentData)
                    let emails = document.get("Email")
                    let scores = document.get("Score")
                    print(emails!)
                    print(scores!)
                }
            }
        }
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

