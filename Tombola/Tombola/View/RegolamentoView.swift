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

                    VStack{
                        ScrollView(){
                            VStack{
                                Text("Il gioco della tombola si basa sull'estrazione di numeri casuali da 1 a 90. Ogni giocatore ha una scheda dove deve controllare se il numero appena estratto sia presente e, in tale eventualità, contrassegnarlo.\n\n----------  LA SCHEDA  ----------")
                                    .multilineTextAlignment(.center)

                                Image("scheda")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 280, height: 100)

                                Text("La scheda è una tabella personale del giocatore che contenente 15 numeri disposti su 3 righe e 9 colonne con dei vincoli. Ogni riga è composta da 5 numeri e le colonne sono separate per decine:\n")
                                    .multilineTextAlignment(.center)

                                Text("- colonna 1: numeri da 1 a 9\n- colonna 2: numeri da 10 a 19\n- colonna 3: numeri da 20 a 29\n- colonna 4: numeri da 30 a 39\n- colonna 5: numeri da 40 a 49\n- colonna 6: numeri da 50 a 59\n- colonna 7: numeri da 60 a 69\n- colonna 8: numeri da 70 a 79\n- colonna 9: numeri da 80 a 90\n\n----------  L'ESTRAZIONE  ----------")

                                HStack{
                                    Text("Il numero casuale appena estratto sarà visualizzato al centro dello schermo.")

                                    Image("numero")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                                
                                Text("Tutti i numeri estratti sono poi riportati in una cronologia visualizzabile in alto")

                                Image("cronologia")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 280, height: 100)

                                Text("---------- IL VINCITORE ----------\n\nVince il giocatore che per primo riesce a segnare tutti i numeri estratti nella propria schedina")
                                    .multilineTextAlignment(.center)

                                Image("schedaTombola")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 280, height: 100)

                                VStack{
                                    Text("\n----------  I PREMI  ----------\n\nOltre alla   tombola, che aumenta il punteggio del giocatore che la effettua di 6 punti, gli altri premi sono:\n")
                                        .multilineTextAlignment(.center)

                                    HStack{
                                        Text("AMBO: quando il giocatore trova due numeri nella stessa riga (+ 2 punti)")

                                        Image("ambo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 90)
                                    }

                                    HStack{
                                        Image("terna")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 90)

                                        Text("TERNA: quando il giocatore trova tre numeri nella stessa riga (+ 3 punti)")
                                    }

                                    HStack{
                                        Text("QUATERNA: quando il giocatore trova due numeri nella stessa riga (+ 4 punti)")

                                        Image("quaterna")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 90)
                                    }

                                    HStack{
                                        Image("cinquina")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 90)

                                        Text("CINQUINA: quando il giocatore trova tre numeri nella stessa riga (+ 5 punti)\n")
                                    }

                                    Text("Ogni volta che un giocatore si trova per primo in una delle situazioni elencate sopra, dovrà cliccare il bottone per aggiudicarsi il premio. Ogni premio viene aggiunto al punteggio del concorrente, visibile nella sezione classifica.")
                                        .multilineTextAlignment(.center)

                                }
                            }
                        }
                    }
                    .padding(20.0)
                    .frame(width: 360.0, height: 600.0)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                    )

                    Button {
                        print("Indietro")
                        mode.wrappedValue.dismiss()
                    }label: {
                        GameButton(title: "Indietro", backgroundColor: Color(red:0.1451, green: 0.6314, blue:0.6627))
                    }
                    .padding(20.0)
                }).edgesIgnoringSafeArea(.vertical)
    }
}


struct RegolamentoView_Previews: PreviewProvider {
    static var previews: some View {
        RegolamentoView()
    }
}
