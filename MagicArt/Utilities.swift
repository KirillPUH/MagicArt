//
//  Utilities.swift
//  MagicArt
//
//  Created by Kirill Pukhov on 5.07.21.
//

import Foundation
import SwiftUI

func convertToArtboardCoordinateSpace(in geometry: CGSize, x: Double, y: Double) -> CGPoint {
    var point = CGPoint()
    point.x = geometry.width / 2 + CGFloat(x)
    point.y = geometry.height / 2 + CGFloat(y)
    return point
}

func convertFromArtboardCoordinateSpace(in geometry: CGSize, position: CGPoint) -> CGPoint {
    var point = CGPoint()
    point.x = position.x - geometry.width / 2
    point.y = position.y - geometry.height / 2
    return point
}
