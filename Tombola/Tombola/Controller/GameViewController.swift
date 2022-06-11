//
//  GameViewController.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI
import Combine

final class GameViewController: ObservableObject {
    
    @Published var alertTombola : Bool = false
    @Published var alertItem: AlertGame?
    @Published var game: Game? {
        didSet {
            checkWin()
            if game == nil {
                updateGameNotificationFor(.finished)
            } else if game?.player2Id == "" {
                updateGameNotificationFor(.waitingForPlayer)
            } else if game?.tombolaWinnerId != "" {
                updateWinGameNotificationFor(.tombola)
            } else {
                updateGameNotificationFor(.started)
            }
            
            //cambio bottone
            if (game?.amboWinnerId == "") {
                updateWinGameNotificationFor(.ambo)
            } else if (game?.amboWinnerId != "" && game?.ternaWinnerId == "") {
                updateWinGameNotificationFor(.terna)
            } else if (game?.amboWinnerId != "" && game?.ternaWinnerId != "" && game?.quaternaWinnerId == "") {
                updateWinGameNotificationFor(.quaterna)
            } else if (game?.amboWinnerId != "" && game?.ternaWinnerId != "" && game?.quaternaWinnerId != "" && game?.cinquinaWinnerId == ""){
                updateWinGameNotificationFor(.cinquina)
            } else {
                updateWinGameNotificationFor(.tombola)
            }
        }
    }
    
    @Published var gameNotification = GameNotification.waitingForPlayer
    @Published var gameWin = WinGameNotification.ambo
    var utente = UserDefaults.standard.string(forKey: "username")!
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
    
    //conrollo per premi = terna/cinquina/tombola
    var cro = Array(repeating: 0, count: 90)
    var txtPremio: String = "TERNA"
    var ambo1: Int = 0
    var ambo2: Int = 0
    var ambo3: Int = 0
    var terna1: Int = 0
    var terna2: Int = 0
    var terna3: Int = 0
    var quaterna1: Int = 0
    var quaterna2: Int = 0
    var quaterna3: Int = 0
    var cinq1: Int = 0
    var cinq2: Int = 0
    var cinq3: Int = 0
    var tomb1: Int = 0
    var tomb2: Int = 0
    var tomb3: Int = 0
    
    var cronologia : [Int] = []
    var indiceCronologia : Int = 0
    var numEstratto: Int = 0
    var numEstrattoGiusto: Int = 0
    
    //metodo per accedere al gioco
    func getTheGame() {
        FirebaseService.shared.startGame(with: utente)
        FirebaseService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
        
    }
    
    //metodo per abbandonare il gioco
    func quitGame(){
        FirebaseService.shared.quitGame()
    }
    
    
    //metodo per aggiornare la notifica dello stato del gioco
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
    
    //metodo per aggiornare il bottone delle vittorie
    func updateWinGameNotificationFor(_ state: WinGame){
        
        switch state {
        case .ambo:
            gameWin = WinGameNotification.ambo
        case .terna:
            gameWin = WinGameNotification.terna
        case .quaterna:
            gameWin = WinGameNotification.quaterna
        case .cinquina:
            gameWin = WinGameNotification.cinquina
        case .tombola:
            gameWin = WinGameNotification.tombola
        }
        
    }
    
    //Metodo per settare 15 numeri casuali con max 3 numeri per decina
    func getRandomNumber() -> Array<Int> {
        while tot > 0 {
            for i in 0...14 {
                let r = Int.random(in: 1...90)
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
    
    //Metodo che attesta Premio = Ambo/Terna/Quaterna/Cinquina/Tombola
    func checkPremio (firstRow: Array<Int>, secondRow: Array<Int>, thirdRow: Array<Int>, firstRowSelected: Array<Bool>, secondRowSelected: Array<Bool>, thirdRowSelected: Array<Bool>, stato: String) {
        guard game != nil else { return }
        if (stato == "AMBO"){
            ambo1 = 0
            for i in 0...8 {
                if ((firstRow[i] != 0) && (firstRowSelected[i] == true) && game!.numeriEstratti.contains(firstRow[i])){
                    ambo1 += 1
                }
            }
            ambo2 = 0
            for i in 0...8 {
                if ((secondRow[i] != 0) && (secondRowSelected[i] == true) && game!.numeriEstratti.contains(secondRow[i])){
                    ambo2 += 1
                }
            }
            ambo3 = 0
            for i in 0...8 {
                if ((thirdRow[i] != 0) && (thirdRowSelected[i] == true) && game!.numeriEstratti.contains(thirdRow[i])){
                    ambo3 += 1
                }
            }
            if ((ambo1 == 2) || (ambo2 == 2) || (ambo3 == 2)) {
                FirebaseService.shared.updateAmbo(with: utente)
                FirebaseService.shared.updateScoreAmbo(with: utente)
            }
        }
        if (stato == "TERNA"){
            terna1 = 0
            for i in 0...8 {
                if ((firstRow[i] != 0) && (firstRowSelected[i] == true) && game!.numeriEstratti.contains(firstRow[i])){
                    terna1 += 1
                }
            }
            terna2 = 0
            for i in 0...8 {
                if ((secondRow[i] != 0) && (secondRowSelected[i] == true) && game!.numeriEstratti.contains(secondRow[i])){
                    terna2 += 1
                }
            }
            terna3 = 0
            for i in 0...8 {
                if ((thirdRow[i] != 0) && (thirdRowSelected[i] == true) && game!.numeriEstratti.contains(thirdRow[i])){
                    terna3 += 1
                }
            }
            if ((terna1 == 3) || (terna2 == 3) || (terna3 == 3)) {
                FirebaseService.shared.updateTerna(with: utente)
                FirebaseService.shared.updateScoreTerna(with: utente)
            }
        }
        if (stato == "QUATERNA"){
            quaterna1 = 0
            for i in 0...8 {
                if ((firstRow[i] != 0) && (firstRowSelected[i] == true) && game!.numeriEstratti.contains(firstRow[i])){
                    quaterna1 += 1
                }
            }
            quaterna2 = 0
            for i in 0...8 {
                if ((secondRow[i] != 0) && (secondRowSelected[i] == true) && game!.numeriEstratti.contains(secondRow[i])){
                    quaterna2 += 1
                }
            }
            quaterna3 = 0
            for i in 0...8 {
                if ((thirdRow[i] != 0) && (thirdRowSelected[i] == true) && game!.numeriEstratti.contains(thirdRow[i])){
                    quaterna3 += 1
                }
            }
            if ((quaterna1 == 4) || (quaterna2 == 4) || (quaterna3 == 4)) {
                FirebaseService.shared.updateQuaterna(with: utente)
                FirebaseService.shared.updateScoreQuaterna(with: utente)
            }
        }
        if (stato == "CINQUINA"){
            cinq1 = 0
            for i in 0...8 {
                if ((firstRow[i] != 0) && (firstRowSelected[i] == true) && game!.numeriEstratti.contains(firstRow[i])){
                    cinq1 += 1
                }
            }
            cinq2 = 0
            for i in 0...8 {
                if ((secondRow[i] != 0) && (secondRowSelected[i] == true) && game!.numeriEstratti.contains(secondRow[i])){
                    cinq2 += 1
                }
            }
            cinq3 = 0
            for i in 0...8 {
                if ((thirdRow[i] != 0) && (thirdRowSelected[i] == true) && game!.numeriEstratti.contains(thirdRow[i])){
                    cinq3 += 1
                }
            }
            if ((cinq1 == 5) || (cinq2 == 5) || (cinq3 == 5)) {
                FirebaseService.shared.updateCinquina(with: utente)
                FirebaseService.shared.updateScoreCinquina(with: utente)
            }
        }
        if (stato == "TOMBOLA"){
            tomb1 = 0
            for i in 0...8 {
                if ((firstRow[i] != 0) && (firstRowSelected[i] == true) && game!.numeriEstratti.contains(firstRow[i])){
                    tomb1 += 1
                }
            }
            tomb2 = 0
            for i in 0...8 {
                if ((secondRow[i] != 0) && (secondRowSelected[i] == true) && game!.numeriEstratti.contains(secondRow[i])){
                    tomb2 += 1
                }
            }
            tomb3 = 0
            for i in 0...8 {
                if ((thirdRow[i] != 0) && (thirdRowSelected[i] == true) && game!.numeriEstratti.contains(thirdRow[i])){
                    tomb3 += 1
                }
            }
            if ((tomb1 >= 5) && (tomb2 >= 5) && (tomb3 >= 5)) {
                FirebaseService.shared.updateTombola(with: utente)
                FirebaseService.shared.updateScoreTombola(with: utente)
            }
        }
        
        FirebaseService.shared.updateGame(game!)
    }
    
    //metodo per ottenere l'ultimo numero estratto
    func getLastNumber() -> (Int) {
        var number = 0
        guard game != nil else { return 0}
        if !(game!.numeriEstratti.isEmpty){
            number = game!.numeriEstratti.last!
        }
        return number
    }
    
    //metodo per ottenere l'array di numeri estratti
    func getListNumbers() -> Array<Int> {
        guard game != nil else { return []}
        if !(game!.numeriEstratti.isEmpty) {
            if !(cronologia.contains(getLastNumber())){
                cronologia.append(getLastNumber())
            }
        }
        return cronologia
    }
    
    func checkWin() {
        alertItem = nil
        guard game != nil else { return }
        
        //check if game is finished
        if game!.tombolaWinnerId != "" {
            if game!.tombolaWinnerId == utente {
                //abbiamo vinto
                alertItem = AlertContext.tombolaWin
            } else {
                //abbiamo perso
                alertItem = AlertContext.tombolaLost
            }
        }
    }
}

