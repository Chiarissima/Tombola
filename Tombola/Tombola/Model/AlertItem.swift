//
//  AlertItem.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

enum AlertItem {
    case signUpOk, signUpFail, loginFail, fields, emailFail, passwordFail
}

struct AlertGame: Identifiable {
    let id = UUID()
    let isWinner = false
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let tombolaWin = AlertGame(title: Text("TOMBOLA!"), message: Text("Hai fatto tombola!"), buttonTitle: Text("OK"))
    static let tombolaLost = AlertGame(title: Text("TOMBOLA!"), message: Text("L'altro giocatore ha fatto tombola!"), buttonTitle: Text("OK"))
}
