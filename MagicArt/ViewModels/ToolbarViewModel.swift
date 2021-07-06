//
//  ToolbarViewModel.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 3.07.21.
//

import Foundation

class ToolbarViewModel: ObservableObject {
    typealias Item = ToolbarModel.Item
    
    static var emojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵", "🐔", "🐧", "🐦", "🐥", "🦆", "🦅", "🦉", "🐺", "🐗", "🐴", "🦄"]
    
    @Published private var model = createToolbar(emojis)
    
    static private func createToolbar(_ contents: [String]) -> ToolbarModel {
        var items = [Item]()
        
        for emoji in emojis {
            let item = Item(id: items.count, content: emoji)
            items.append(item)
        }
        
        return ToolbarModel(items)
    }
    
    // MARK: - Model vars aliasses
    var items: [Item] {
        model.items
    }
    
}
