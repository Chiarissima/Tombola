//
//  ClassificaView.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI

struct ClassificaView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        Color(red: 1.0, green: 0.9137, blue: 0.6275)
            .overlay(
                VStack(spacing: 20){
                    Image("Bingo")
                        .resizable()
                        .scaledToFit()
                    
                    Text("Classifica!")
                    
                    Button {
                        print("Indietro")
                        mode.wrappedValue.dismiss()
                    }label: {
                        GameButton(title: "Indietro", backgroundColor: Color(red: 1.00, green: 0.50, blue: 0.50))
                    }
                        
                        
                }).edgesIgnoringSafeArea(.vertical)
    }
}

struct ClassificaView_Previews: PreviewProvider {
    static var previews: some View {
        ClassificaView()
    }
}
