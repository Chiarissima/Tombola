//
//  Model.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import Foundation

//E' codable perchè voglio salvare la mossa online
struct Game: Codable {
    let id: String
    var player1Id: String
    var player2Id: String
    var amboWinnerId: String
    var ternaWinnerId: String
    var quaternaWinnerId: String
    var cinquinaWinnerId: String
    var tombolaWinnerId: String
    var numeriEstratti: [Int]
    var numbers = Array(1...90)
}

struct numEstratto: Codable {
    let id: Int
}
