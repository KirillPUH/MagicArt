//
//  ArtboardViewModel.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 4.07.21.
//

import Foundation
import SwiftUI

class ArtboardViewModel: ObservableObject {
    typealias Item = ArtboardModel.Item
    
    @Published private var model: ArtboardModel {
        didSet {
            scheduleAutosave()
        }
    }
    
    struct Autosave {
        static let fileName = "autosave.ma"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(fileName)
        }
        static let autosaveInterval = 3.0
    }
    
    private var autosaveTimer: Timer?
    
    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.autosaveInterval, repeats: false) { _ in
            self.autosave()
        }
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    init() {
        if let url = Autosave.url {
            if let data = try? Data(contentsOf: url) {
                if let model = try? JSONDecoder().decode(ArtboardModel.self, from: data) {
                    self.model = model
                    return
                }
            }
        }
        model = ArtboardViewModel.createArtboard()
    }
    
    private func save(to url: URL) {
        do {
            let data = try model.json()
            print(String(data: data, encoding: .utf8) ?? "nil")
            try data.write(to: url)
        } catch {
            let thisFunction = "\(String(describing: self)).\(#function)"
            print("\(thisFunction) error = \(error)")
        }
    }
    
    static private func createArtboard(bgColor: ArtboardModel.Background = .color("FFFFFF")) -> ArtboardModel { ArtboardModel(background: bgColor) }
    
    // MARK: - Model vars aliasses
    var items: [Item] { model.items }
    var bgColor: ArtboardModel.Background { model.background }
    var isSomethingDraging: Bool { model.isSomethingDraging }
    
    // MARK: - Intent functions
    func addItem(
        height: Double,
        width: Double,
        x: Double = 0,
        y: Double = 0,
        zIndex: Double = 0,
        content: ArtboardModel.ContentType
    ) {
        model.addItem(
            height: height,
            width: width,
            x: x,
            y: y,
            zIndex: zIndex,
            content: content
        )
    }
    
    func remove(_ item: Item) { model.remove(item) }
    
    func remove(_ uuid: UUID) { model.remove(uuid) }
    
    
    // MARK: State
    func changeState(for item: Item, on newState: Item.State) { model.changeState(for: item, on: newState) }
    
    func resetItemsStates() { model.resetItemsStates() }
    
    
    // MARK: Moving
    func move(item: Item, to position: CGPoint) { model.move(item: item, to: position.normalize()) }
    
    func move(item: Item, on translation: CGSize) { model.move(item: item, on: translation.normalize()) }
    
    // MARK: Scaling
    func scale(item: Item, by value: CGFloat) {
        model.scale(item: item, by: Double(value))
    }
}

fileprivate extension CGPoint {
    func normalize() -> (x: Double, y: Double) {
        (x: Double(self.x), y: Double(self.y))
    }
}

fileprivate extension CGSize {
    func normalize() -> (width: Double, height: Double) {
        (width: Double(self.width), height: Double(self.height))
    }
}
