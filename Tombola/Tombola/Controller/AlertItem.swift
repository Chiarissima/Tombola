//
//  AlertItem.swift
//  Tombola
//
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

//Identifiable in order to be able to show it
struct AlertItem: Identifiable {
    let id = UUID()
    let isForQuit = false
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let youWin = AlertItem(title: Text("You win"), message: Text("You are good at this game!"), buttonTitle: Text("Rematch"))
    static let youLost = AlertItem(title: Text("You lost"), message: Text("Try Rematch!"), buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Draw!"), message: Text("That was a cool game"), buttonTitle: Text("Rematch"))
    static let quit = AlertItem(title: Text("Game over!"), message: Text("Other player left"), buttonTitle: Text("Quit"))
}
