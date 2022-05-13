//
//  GameSquareView.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

struct GameSquareView: View {
    var proxy: GeometryProxy
            
    var body: some View {
        Rectangle()
            .foregroundColor(.white)
            .frame(width: proxy.size.width / 3, height: proxy.size.width / 3)
            .border(.black)
    }
}

//struct GameSquareView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameSquareView()
//    }
//}
