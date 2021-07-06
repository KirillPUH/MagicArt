//
//  ItemView.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 5.07.21.
//

import SwiftUI

struct ItemView: View {
    typealias Item = ArtboardModel.Item
    
    @ObservedObject var artboard: ArtboardViewModel
    private var item: Item
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                switch item.content {
                case .text:
                    Text(item.content.text)
                        .font(.system(size: CGFloat(item.height)))
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 1).strokeBorder(lineWidth: 1).foregroundColor(item.state == Item.State.selected ? .blue : .clear))
            .position(convertToArtboardCoordinateSpace(in: geometry.size, x: item.x, y: item.y))
            .offset(movingOffset)
            .onTapGesture(count: 1) { item.state == Item.State.selected ? artboard.changeState(for: item, on: .none) : artboard.changeState(for: item, on: .selected) }
//            .onDrag({ NSItemProvider(object: item.id.uuidString as NSString) })
            .gesture(moveGesture(in: geometry.size, item))
            .gesture(scaleGesture())
        }
    }
    
    // MARK: - Moving gesture
    @State private var movingOffset = CGSize.zero
    
    private func moveGesture(in geometry: CGSize, _ item: Item) -> some Gesture {
        DragGesture()
            .onChanged {
                artboard.changeState(for: item, on: .moving)
                movingOffset.width = $0.translation.width
                movingOffset.height = $0.translation.height
            }
            .onEnded { _ in
                artboard.changeState(for: item, on: .none)
                artboard.move(item: item, on: movingOffset)
                movingOffset = CGSize.zero
            }
    }
    
    // MARK: - Scale gesture
    @GestureState private var scaleState = CGFloat(1.0)
    
    private func scaleGesture() -> some Gesture {
        MagnificationGesture()
            .updating($scaleState) { newScale, scaleState, _ in
                artboard.changeState(for: item, on: .none)
                withAnimation {
                    artboard.scale(item: item, by: newScale / scaleState)
                }
                scaleState = newScale
            }
    }

    init(for item: Item, in artboard: ArtboardViewModel) {
        self.artboard = artboard
        self.item = item
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
