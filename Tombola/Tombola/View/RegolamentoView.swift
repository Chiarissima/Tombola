//
//  RegolamentoView.swift
//  Tombola
//
//  Created by Filippo Lupatelli on 02/06/22.
//

import SwiftUI

struct RegolamentoView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        Color(red: 1.0, green: 0.9137, blue: 0.6275)
            .overlay(
                VStack(spacing: 20){
                    
                    Text("REGOLAMENTO")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(.top, 60.0)
                    
                    ScrollView(){
                        VStack{
                            Text("Il gioco della tombola si basa sull'estrazione di un numero casuale da 1 a 90 alla volta. Ogni giocatore ha una scheda dove deve controllare se sia presente il numero appena estratto e, in questa eventualità, contrassegnarlo.")
                                .multilineTextAlignment(.center)
                            
                            Text("LA SCHEDA")
                                .multilineTextAlignment(.leading)
                                .padding(.top, 5.0)
                            
                            Image("scheda")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 280, height: 100, alignment: .topLeading)
                            
                            Text("La scheda è una tabella contenente 15 numeri disposti su 3 righe e 9 colonne con dei vincoli. Ogni riga è composta da 5 numeri e le colonne sono separate per decine:")
                            
                            Text("- colonna 1: numeri da 1 a 9")
                            Text("- colonna 2: numeri da 10 a 19")
                            Text("- colonna 3: numeri da 20 a 29")
                            Text("- colonna 4: numeri da 30 a 39")
                            Text("- colonna 5: numeri da 40 a 49")
                            
             
                        }
                        .frame(width: 360.0, height: 600.0)
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray)
                        )
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

struct RegolamentoView_Previews: PreviewProvider {
    static var previews: some View {
        RegolamentoView()
    }
}
