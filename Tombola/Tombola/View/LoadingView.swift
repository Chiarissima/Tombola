//
//  LoadingView.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(2)
            .padding(50)
            .background(Color(red: 1.0, green: 0.9137, blue: 0.6275))
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
