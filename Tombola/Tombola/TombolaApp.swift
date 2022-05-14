//
//  TombolaApp.swift
//  Tombola
//  Created by Chiara Tagani on 10/05/22.
//

import SwiftUI
import Firebase

@main
struct TombolaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            UsernameView()
        }
    }
}
