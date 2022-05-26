//
//  GameView.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var viewController: GameViewController
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @State var selectedBtn: Int = 9
    @State var isClicked: Bool = false
    @State var buttonColor: Color = .white
    
    @State var rCard1 = Array(repeating: false, count: 9)
    @State var rCard2 = Array(repeating: false, count: 9)
    @State var rCard3 = Array(repeating: false, count: 9)
    @State var r1 = Array(repeating: Color.white, count: 9)
    @State var r2 = Array(repeating: Color.white, count: 9)
    @State var r3 = Array(repeating: Color.white, count: 9)
    
    @State var txtPremio: String = "TERNA"
    
    @State var cronologia = Array(repeating: 0, count: 9)
    @State var cronologiaTot = Array(repeating: 0, count: 90)
    @State var numEstrattoGiusto: Int = 0
    @State var timer = Timer.publish(every: 3, on: .current, in: .common).autoconnect()
    
    var body: some View {
        
        GeometryReader { geometry in
            
            var a = viewController.getRandomNumber()
            var (ar, br, cr) = viewController.setCards(array: a)
            var (ar0, br0, cr0) = viewController.rimuoviZeri(ar: ar, br: br, cr: cr)
           
            VStack(alignment: .center) {
                
                Spacer()
                VStack {
                    Text("ULTIMI NUMERI ESTRATTI:")
                        .padding(.bottom, 40.0)
                    
                    HStack{
                        ForEach(0...8, id: \.self) { i in
                            Button(action: {
                                
                            }) {
                            Text(String(cronologia[i]))
                            }
                            .frame(width: 30.0, height: 50.0)
                            .border(Color.black)
                            .foregroundColor(.black)
                            .background(Color.yellow)
                        }
                    }
                    .padding(.bottom, 40.0)
                    
                }
                .padding()
                .frame(width: 360.0, height: 200.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                )
                
                VStack {
                    Text("NUMERO ESTRATTO:")
                        .padding(.bottom, 40.0)
                    
                    
                    Text("\(numEstrattoGiusto)")
                            .onReceive(timer) { input in
                                (numEstrattoGiusto, cronologia, cronologiaTot) = viewController.estrazione()
                           
                    }
                    .foregroundColor(.black)
                    .frame(width: 70.0, height: 70.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black)
                    )
                    .frame(width: 60.0, height: 60.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.pink)
                    )
                }
                .padding()
                .frame(width: 360.0, height: 200.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                )
                //.background(Color.yellow)
                
                Spacer()
                
                Button(action: {
                    txtPremio = viewController.checkPremio(cro: cronologiaTot, ar: ar, br: br, cr: cr, rCard1: rCard1, rCard2: rCard2, rCard3: rCard3, r1: r1, r2: r2, r3: r3)
                    //(r1, r2, r3) = viewController.checkSelected(rCard1: rCard1, rCard2: rCard2, rCard3: rCard3)
                }) {
                    Text(txtPremio)
                }
                    .foregroundColor(.black)
                    .frame(width: 300.0, height: 40.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black)
                    )
                
                VStack() {
                        HStack() {
                            ForEach(0...8, id: \.self) { i in
                                Button(action: {
                                    rCard1[i].toggle()
                                    (r1, r2, r3) = viewController.checkSelected(rCard1: rCard1, rCard2: rCard2, rCard3: rCard3)
                                }) {
                                Text(String(ar0[i]))
                                }
                                .frame(width: 30.0, height: 50.0)
                                .border(Color.black)
                                .foregroundColor(.black)
                                .background(r1[i])
                            }
                        }
                        HStack() {
                            ForEach(0...8, id: \.self) { j in
                                Button(action: {
                                    rCard2[j].toggle()
                                    (r1, r2, r3) = viewController.checkSelected(rCard1: rCard1, rCard2: rCard2, rCard3: rCard3)
                                }) {
                                    Text(String(br0[j]))
                                }
                                    .frame(width: 30.0, height: 50.0)
                                    .border(Color.black)
                                    .foregroundColor(.black)
                                    .background(r2[j])
                                    
                            }
                        }
                        HStack() {
                            ForEach(0...8, id: \.self) { z in
                                Button(action: {
                                    rCard3[z].toggle()
                                    (r1, r2, r3) = viewController.checkSelected(rCard1: rCard1, rCard2: rCard2, rCard3: rCard3)
                                }) {
                                    Text(String(cr0[z]))
                                }
                                    .frame(width: 30.0, height: 50.0)
                                    .border(Color.black)
                                    .foregroundColor(.black)
                                    .background(r3[z])
                            }
                        }
                    //}
                }
                .padding(10)
                .border(Color.black)
                .background(Color(hue: 0.514, saturation: 0.76, brightness: 0.65, opacity: 0.978))
                

                
                //.disabled(viewController.checkForGameBoardStatus())
                //.padding()
                //.alert(item: $viewController.alertItem) { alertItem in
                    //if-else statement
                //    alertItem.isForQuit ? Alert(title: alertItem.title, message: alertItem.message, dismissButton: .destructive(alertItem.buttonTitle, action: {
                //         self.mode.wrappedValue.dismiss()
                //        viewController.quitGame()
                //    }))
                //    : Alert(title: alertItem.title, message: alertItem.message, primaryButton: .default(alertItem.buttonTitle, action: {
                        //reset game
                //        viewController.resetGame()
                //    }), secondaryButton: .destructive(Text("Quit"), action: {
                //        self.mode.wrappedValue.dismiss()
                //        viewController.quitGame()
                //    }))
                //}
                
                
                Button{
                    print("Quit the game")
                    mode.wrappedValue.dismiss()
                    //Richiama func firebase che elimina da db il gioco
                    viewController.quitGame()
                } label: {
                    GameButton(title: "Quit", backgroundColor: .gray)
                }
            }
            .padding()
            .background(Color(hue: 0.131, saturation: 0.107, brightness: 0.842, opacity: 0.978))
            
            
        //)
            
        }.onAppear(){
            viewController.getTheGame()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewController: GameViewController())
    }
}
