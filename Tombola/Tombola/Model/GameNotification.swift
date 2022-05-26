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
    static let gameFinished = "Gli altri giocatori hanno abbandonato"
}
