//
//  BinView.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 5.07.21.
//

import SwiftUI

struct BinView: View {
    @ObservedObject var artboard: ArtboardViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: BinParameters.cornerRadius)
                .foregroundColor(isHovered ? BinParameters.hovered.background : BinParameters.simple.background)
            
            Image(systemName: isHovered ? "trash.fill" : "trash")
                .foregroundColor(isHovered ? BinParameters.hovered.bin : BinParameters.simple.bin)
                .font(.system(size: BinParameters.binSize))
        }
        .frame(width: BinParameters.width, height: BinParameters.height)
        .onDrop(of: [.text], delegate: BinDropDeligate(artboard: artboard, isHovered: $isHovered))
    }
    
    // MARK: - Droping
    @State var isHovered = false
    
    private struct BinDropDeligate: DropDelegate {
        @ObservedObject var artboard: ArtboardViewModel
        @Binding var isHovered: Bool
        
        func dropEntered(info: DropInfo) {
            self.isHovered = true
        }
        
        func dropExited(info: DropInfo) {
            self.isHovered = false
        }
        
        func performDrop(info: DropInfo) -> Bool {
            let items = info.itemProviders(for: [.text])
            for item in items {
                let _ = item.loadObject(ofClass: String.self) { str, _ in
                    DispatchQueue.main.async {
                        if let str = str {
                            if let uuid = UUID(uuidString: str) {
                                self.artboard.remove(uuid)
                                self.isHovered = false
                            }
                        }
                    }
                }
            }
            return true
        }
    }
    
    struct BinParameters {
        static var height: CGFloat = 88
        static var width: CGFloat = height * 0.85
        static var binSize: CGFloat = height * 0.55
        static var cornerRadius: CGFloat = 7
        static var simple = (background: Color(hex: "E3E3E4"), bin: Color(hex: "484545"))
        static var hovered = (background: Color(hex: "FDF0F0"), bin: Color(hex: "E32C32"))
    }
}

struct BinView_Previews: PreviewProvider {
    static var previews: some View {
        BinView(artboard: ArtboardViewModel())
            .previewLayout(.sizeThatFits)
    }
}
