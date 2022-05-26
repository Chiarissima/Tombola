//
//  TombolaApp.swift
//  Tombola
//  Created by Chiara Tagani on 10/05/22.
//

import SwiftUI
import Firebase

@main
struct TombolaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate 
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any ]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
