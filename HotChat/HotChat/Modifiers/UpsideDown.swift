//
//  UpsideDown.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SwiftUI

struct UpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(radians: .pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

extension View {
    func upsideDown() -> some View {
        ModifiedContent(content: self, modifier: UpsideDown())
    }
}
