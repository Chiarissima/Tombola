//
//  AuthenticationViewController.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI
import FirebaseAuth

final class AuthenticationViewController: ObservableObject {
    @Published var signedIn = false
    @Published var signUp = false
    
    let auth = Auth.auth()
    
    func signIn(username: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: username, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                print("Errore nel login")
                completion(false)
                return
            }
            
            let userDef = UserDefaults.standard
            userDef.set(username, forKey: "username")
            userDef.set(password, forKey: "password")
            
            DispatchQueue.main.async {
                //Success
                self?.signedIn = true
                completion(true)
            }
            
            print("Login effettuato con successo!")
            
        }
    }


    func signUp(username: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: username, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                print("Errore nella registrazione")
                completion(false)
                return
            }
            
            let userDef = UserDefaults.standard
            userDef.set(username, forKey: "username")
            userDef.set(password, forKey: "password")
            userDef.set(0, forKey: "score")
            
            DispatchQueue.main.async {
                //Success
                self?.signUp = true
                completion(true)
                FirebaseService.shared.addInClassifica(with: username)
            }
            
            print("Registrazione effettuata con successo!")
        }
    }
    
    func signOut() {
        
        do{
            try auth.signOut()
            self.signedIn = false
        } catch let signOutError as Error {
            print("Errore nel logout: ", signOutError.localizedDescription)
        }
    }
    
    
}

