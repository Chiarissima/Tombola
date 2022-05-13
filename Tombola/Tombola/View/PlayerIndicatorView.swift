//
//  PlayerIndicatorView.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

struct PlayerIndicatorView: View {
    var systemImageName: String
            
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.black)
            .opacity(systemImageName == "square" ? 0 : 1)
    }
}

struct PlayerIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerIndicatorView(systemImageName: "square")
    }
}
