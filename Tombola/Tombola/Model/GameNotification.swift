//
//  GameNotification.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

enum GameState {
    case started
    case waitingForPlayer
    case finished
}

struct GameNotification {
    static let waitingForPlayer = "In attesa degli altri partecipanti"
    static let gameHasStarted = "Partita iniziata!"
    static let gameFinished = "L'altro giocatore ha abbandonato"
    static let tombola = "TOMBOLA!!"
}

enum WinGame {
    case ambo
    case terna
    case quaterna
    case cinquina
    case tombola
}

struct WinGameNotification {
    static let ambo = "AMBO"
    static let terna = "TERNA"
    static let quaterna = "QUATERNA"
    static let cinquina = "CINQUINA"
    static let tombola = "TOMBOLA"
    
}
