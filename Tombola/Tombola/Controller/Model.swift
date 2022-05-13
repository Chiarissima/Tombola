//
//  Model.swift
//  Tombola
//
//  Created by Chiara Tagani on 13/05/22.
//

import Foundation

//E' codable perchè voglio salvare la mossa online
struct Move: Codable {
    
    let isPlayer1: Bool
    let boardIndex: Int
    
    var indicator: String {
        return isPlayer1 ?  "xmark" : "circle"
    }
}

struct Game: Codable {
    let id: String
    var player1Id: String
    var player2Id: String
    
    // user that should be blocked
    var blockMoveForPlayerId: String
    var winningPlayerId: String
    //how many of the players want to rematch the game
    var rematchPlayerId: [String]
    
    var moves:[Move?]
    
}
