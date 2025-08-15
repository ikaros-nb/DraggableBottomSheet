//
//  SizePreferenceKey.swift
//  DraggableSheet
//
//  Created by Nicolas Bouème on 2025/08/15.
//

import SwiftUI

extension View {
    func readSize(
        in coordinateSpace: String,
        onChange: @escaping (CGFloat) -> Void
    ) -> some View {
        modifier(SizeReader(coordinateSpace: coordinateSpace, onChange: onChange))
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct SizeReader: ViewModifier {
    let coordinateSpace: String
    let onChange: (CGFloat) -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: SizePreferenceKey.self,
                            value: geo.frame(in: .named(coordinateSpace)).height
                        )
                }
            )
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
