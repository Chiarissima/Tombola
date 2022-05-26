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
        
        Color(red: 0.53, green: 0.73, blue: 0.83, opacity: 0.5)
            .overlay(
                VStack(spacing: 20){
                    Image("logo")
                        .resizable()
                        .padding(.top, 20.0)
                        .frame(width: 250, height: 100)
                        .scaledToFit()
                    Text("CLASSIFICA")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.07, saturation: 0.172, brightness: 0.412))
                        .multilineTextAlignment(.center)
                    List(0..<10) { item in
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
        ClassificaView()
    }
}
