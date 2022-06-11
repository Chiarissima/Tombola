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
        
        GeometryReader { geometry in
                VStack(spacing: 20){
                    Image("coins")
                        .resizable()
                        .scaledToFit()
                    
                    Text("PUNTEGGI")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.07, saturation: 0.172, brightness: 0.412))
                        .multilineTextAlignment(.center)
                   
                    ScrollView {
                        VStack(alignment: .leading){
                            ForEach(0..<viewController.emails.count) { i in
                                HStack {
                                    let text = viewController.emails[i]
                                    let char = text.prefix(1).uppercased()
                                    Text(char)
                                        .padding()
                                        .background(Color.orange)
                                        .clipShape(Circle())
                                    Text("\(viewController.emails[i])")
                                    
                                    HStack{
                                        Text("\(viewController.scores[i])")
                                            .multilineTextAlignment(.trailing)
                                            .frame(alignment: .trailing)
                                        
                                        Image("goldCoin")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .scaledToFit()
                                        .frame(alignment: .trailing)
                                    }
                                }
                            }
                        }
                    }
                            
                    Button {
                        print("Indietro")
                        mode.wrappedValue.dismiss()
                    }label: {
                        GameButton(title: "Indietro", backgroundColor: Color(red:0.9569, green:0.7333, blue:0.2314))
                    }
                    .padding(.bottom, 20.0)
                }
                .padding()
                .background(Color(red: 1.0, green: 0.9137, blue: 0.6275))
        }
    }
}

struct ClassificaView_Previews: PreviewProvider {
    static var previews: some View {
        ClassificaView(viewController: ClassificaViewController())
    }
}
