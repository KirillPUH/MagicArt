//
//  ArtboardModel.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 3.07.21.
//

import Foundation

struct ArtboardModel: Codable {
    var background: Background
    var items = [Item]()
    var isSomethingDraging = false
    
    func json() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    // MARK: - Intent functions
    
    mutating func addItem(
        height: Double,
        width: Double,
        x: Double = 0,
        y: Double = 0,
        zIndex: Double = 0,
        content: ContentType
    ) {
        items.append(
            Item(
                height: height,
                width: width,
                x: x,
                y: y,
                zIndex: zIndex,
                content: content
            )
        )
    }
    
    mutating func remove(_ item: Item) {
        for index in items.indices {
            if item.id == items[index].id {
                items.remove(at: index)
                return
            }
        }
    }
    
    mutating func remove(_ uuid: UUID) {
        for index in items.indices {
            if uuid == items[index].id {
                items.remove(at: index)
                return
            }
        }
    }
    
    // MARK: - State
    mutating func changeState(for item: Item, on newState: Item.State){
        if let index = items.index(of: item) { items[index].state = newState }
    }
    
    mutating func resetItemsStates() {
        for index in items.indices { items[index].state = .none }
    }
    
    // MARK: - Moving
    mutating func move(item: Item, to position: (x: Double, y: Double)) {
        if let index = items.index(of: item) {
            items[index].x = position.x
            items[index].y = position.y
        }
    }
    
    mutating func move(item: Item, on translation: (width: Double, height: Double)) {
        if let index = items.index(of: item) {
            items[index].x += translation.width
            items[index].y += translation.height
        }
    }
    
    // MARK: - Scaling
    mutating func scale(item: Item, by value: Double) {
        if let index = items.index(of: item) {
            items[index].width *= value
            items[index].height *= value
        }
    }
    
    enum Background: Codable {
        case color(String)
        
        var color: String {
            switch self {
            case .color(let str): return str
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case color
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let color = try container.decode(String.self, forKey: .color)
            self = .color(color)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(color, forKey: .color)
        }
    }
    
    struct Item: Hashable, Identifiable, Codable {
        var id = UUID()
        var height: Double
        var width: Double
        var x: Double
        var y: Double
        var zIndex: Double
        var state = State.none
        var content: ContentType
        
        enum State: String, Codable {
            case none
            case selected
            case moving
        }
    }
    
    enum ContentType: Hashable, Codable {
        case text(String)
        
        var text: String { switch self { case .text(let str): return str } }
        
        enum CodingKeys: String, CodingKey { case text }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let str = try container.decode(String.self, forKey: .text)
            self = .text(str)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .text(let str): try container.encode(str, forKey: .text)
            }
        }
    }
}
