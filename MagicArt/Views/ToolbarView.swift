//
//  ToolbarView.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 3.07.21.
//

import SwiftUI

struct ToolbarView: View {
    @ObservedObject var toolbar = ToolbarViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 9)
                    .foregroundColor(Color(red: 229/255, green: 229/255, blue: 229/255))
                    .frame(height: ToolbarParameters(geometry.size).height)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(toolbar.items) { item in
                                Text(item.content)
                                    .frame(height: ToolbarParameters(geometry.size).fontSize, alignment: .center)
                                    .font(.system(size: ToolbarParameters(geometry.size).fontSize))
                                    .onDrag { NSItemProvider(object: item.content as NSString) }
                            }
                        }
                    }
                    .padding(.horizontal, 6)
                }
            }
        }
    }
    
    struct ToolbarParameters {
        var geometry: CGSize
        var height: CGFloat { geometry.height * 0.09 }
        var padding: CGFloat = 6
        var fontSize: CGFloat { height - padding * 2 }
        
        init(_ geometry: CGSize) { self.geometry = geometry }
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
            .padding(.horizontal)
            .previewDevice("iPhone 12 mini")
    }
}
