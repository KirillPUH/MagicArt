//
//  ArtboardView.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 3.07.21.
//

import SwiftUI

struct ArtboardView: View {
    typealias Item = ArtboardModel.Item
    
    @ObservedObject var artboard = ArtboardViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hex: artboard.bgColor.color)
                    .onTapGesture { artboard.resetItemsStates() }
                
//                VStack {
//                    HStack {
//                        Spacer()
//                        BinView(artboard: artboard)
//                    }
//                    Spacer()
//                }
//                .padding([.top, .trailing])
                
                ForEach(artboard.items) { item in
                    ItemView(for: item, in: artboard)
                }
            }
            .onDrop(of: [.text], isTargeted: nil) { items, location in
                drop(of: items, in: geometry.size, on: location)
            }
        }
    }
    
    // MARK: - Actions
    private func drop(of items: [NSItemProvider], in geometry: CGSize, on location: CGPoint) -> Bool {
        for item in items {
            let _ = item.loadObject(ofClass: String.self) { object, _ in
                let point = convertFromArtboardCoordinateSpace(in: geometry, position: location)
                DispatchQueue.main.async {
                    if let str = object {
                        artboard.addItem(height: 72,
                                      width: 72,
                                      x: Double(point.x),
                                      y: Double(point.y),
                                      zIndex: 0,
                                      content: .text(str))
                    }
                }
            }
        }
        return true
    }
}

struct ArtboardView_Previews: PreviewProvider {
    static var previews: some View {
        ArtboardView()
            .previewDevice("iPhone 12 mini")
    }
}
