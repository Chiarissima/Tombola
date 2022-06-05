//
//  ClassificaView.swift
//  Tombola
//
//  Created by Chiara Tagani on 14/05/22.
//

import SwiftUI

struct ClassificaView: View {
    
    @ObservedObject var viewController: ClassificaViewController
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        Color(red: 1.0, green: 0.9137, blue: 0.6275)
            .overlay(
                VStack(spacing: 20){
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                    
                    Text("CLASSIFICA")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.07, saturation: 0.172, brightness: 0.412))
                        .multilineTextAlignment(.center)

                    /*List(0..<10) { item in
                        HStack {
                            Image(systemName: "photo")
                            VStack(alignment: .leading) {
                                Text("Filippo Lupatelli")
                                Text("filo@unibo.it")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }

                            Text("300")
                                .multilineTextAlignment(.trailing)
                            Image("coin")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .scaledToFit()
                        }
                    }*/
                   
                    ForEach(0..<ClassificaViewController.utenti.count) { i in
                        HStack {
                            Image(systemName: "photo")
                            VStack(alignment: .leading) {
                                Text("\(ClassificaViewController.utenti[i])")
                                Text("\(ClassificaViewController.utenti[i])")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                            Text("\(ClassificaViewController.punteggi[i])")
                                .multilineTextAlignment(.trailing)
                            Image("coin")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .scaledToFit()
                            
                        }
                    }
                    
                    Button {
                        print("Indietro")
                        mode.wrappedValue.dismiss()
                    }label: {
                        GameButton(title: "Indietro", backgroundColor: Color(hue: 0.081, saturation: 0.237, brightness: 0.66))
                    }
                    .padding(.bottom, 20.0)
                        
                        
                }).edgesIgnoringSafeArea(.vertical)
    }
}

struct ClassificaView_Previews: PreviewProvider {
    static var previews: some View {
        ClassificaView(viewController: ClassificaViewController())
    }
}
