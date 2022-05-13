//
//  GameNotification.swift
//  Tombola
//
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

enum GameState {
    case started
    case waitingForPlayer
    case finished
}

struct GameNotification {
    static let waitingForPlayer = "Waiting for player"
    static let gameHasStarted = "Game has started"
    static let gameFinished = "Player left the game"
}
