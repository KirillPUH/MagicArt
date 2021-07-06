//
//  ToolbarModel.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 3.07.21.
//

import Foundation

struct ToolbarModel {
    var items: [Item]
    
    init(_ items: [Item]) {
        self.items = items
    }
    
    // MARK: - Structs and enums
    struct Item: Identifiable {
        var id: Int
        var content: String
    }
}
