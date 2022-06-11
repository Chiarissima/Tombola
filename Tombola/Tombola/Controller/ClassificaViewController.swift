//
//  ClassificaViewController.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI

final class ClassificaViewController: ObservableObject {
    
    @Published var isClassificaViewPresented = false
    @State var emails : [String] = FirebaseService.shared.getUtentiClassifica()
    @State var scores : [Int] = FirebaseService.shared.getPunteggiClassifica()
    
}
