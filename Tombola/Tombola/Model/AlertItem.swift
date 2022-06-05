//
//  AlertItem.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

//Identifiable in order to be able to show it
struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let quit = AlertItem(title: Text("Game over!"), message: Text("Gli altri giocatori hanno abbandonato"), buttonTitle: Text("Abbandona"))
    static let compilaCampi = AlertItem(title: Text("Attenzione!"), message: Text("Compila tutti i campi"), buttonTitle: Text("Ok"))
    static let signIn = AlertItem(title: Text("Login!"), message: Text("Login effettuato con successo!"), buttonTitle: Text("Ok"))
    static let signUp = AlertItem(title: Text("Registrazione!"), message: Text("Registrazione effettuata con successo"), buttonTitle: Text("Ok"))
    static let amboWin = AlertItem(title: Text("Complimenti!"), message: Text("Hai fatto ambo"), buttonTitle: Text("Ok"))
    static let ternaWin = AlertItem(title: Text("Complimenti!"), message: Text("Hai fatto terna"), buttonTitle: Text("Ok"))
    static let quaternaWin = AlertItem(title: Text("Complimenti!"), message: Text("Hai fatto quaterna"), buttonTitle: Text("Ok"))
    static let cinquinaWin = AlertItem(title: Text("Complimenti!"), message: Text("Hai fatto cinquina"), buttonTitle: Text("Ok"))
    static let tombolaWin = AlertItem(title: Text("Complimenti!"), message: Text("Hai fatto tombola"), buttonTitle: Text("Gioca"))
    static let amboLost = AlertItem(title: Text("Ambo!"), message: Text("Un giocatore ha fatto ambo"), buttonTitle: Text("Ok"))
    static let ternaLost = AlertItem(title: Text("Terna!"), message: Text("Un giocatore ha fatto terna"), buttonTitle: Text("Ok"))
    static let quaternaLost = AlertItem(title: Text("Quaterna!"), message: Text("Un giocatore ha fatto quaterna"), buttonTitle: Text("Ok"))
    static let cinquinaLost = AlertItem(title: Text("Cinquina!"), message: Text("Un giocatore ha fatto cinquina"), buttonTitle: Text("Ok"))
    static let tombolaLost = AlertItem(title: Text("Tombola!"), message: Text("Un giocatore ha fatto tombola"), buttonTitle: Text("Gioca"))
    static let tombola = AlertItem(title: Text("Tombola!"), message: Text("E' stata fatta tombola"), buttonTitle: Text("Ok"))
}
