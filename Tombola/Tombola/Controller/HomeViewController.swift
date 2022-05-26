//
//  HomeViewController.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI
import FirebaseAuth

final class HomeViewController: ObservableObject {
    @Published var isGameViewPresented = false
    /*@State var authView = AuthenticationView()
    let auth = Auth.auth()
    
    func signOut() {
        
        do{
            try auth.signOut()
        } catch let signOutError as Error {
            print("Errore nel logout: ", signOutError.localizedDescription)
        }
    }*/
}
