//
//  ContentView.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 28.06.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottom) {
                ArtboardView()
                ToolbarView()
                    .padding([.bottom, .horizontal])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 mini")
    }
}
