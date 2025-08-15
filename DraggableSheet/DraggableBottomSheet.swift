//
//  DraggableBottomSheet.swift
//  DraggableSheet
//
//  Created by Nicolas Bouème on 2025/08/15.
//

import SwiftUI

struct DraggableBottomSheet<Content: View>: View {
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let content: Content
    
    @State private var height: CGFloat = 0
    @State private var dragStartHeight: CGFloat = 0
    private let initialHeight: CGFloat
    private var backgroundColor: Color = .white
    
    init(
        minHeight: CGFloat,
        maxHeight: CGFloat,
        @ViewBuilder content: () -> Content
    ) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.initialHeight = minHeight
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            dragIndicator()
                .background(backgroundColor)
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged { value in
                            // Store starting height on first drag frame
                            if dragStartHeight == 0 {
                                dragStartHeight = height
                            }
                            
                            // Apply drag with a 50px overshoot allowance
                            let proposedHeight = dragStartHeight - value.translation.height
                            let lowerBound = minHeight - 50
                            let upperBound = maxHeight + 50
                            height = min(
                                max(proposedHeight, lowerBound),
                                upperBound
                            )
                        }
                        .onEnded { _ in
                            // Snap to top or bottom
                            let midpoint = (maxHeight + minHeight) / 2
                            withAnimation(
                                .spring(
                                    response: 0.35,
                                    dampingFraction: 0.8
                                )
                            ) {
                                height = height > midpoint ? maxHeight : minHeight
                            }
                            dragStartHeight = 0
                        }
                )
            
            let computedHeight = height - dragIndicatorBlocHeight
            if computedHeight > 0 {
                content
                    .frame(height: computedHeight)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(backgroundColor)
        .clipShape(
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 40, topTrailing: 40))
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -2)
        .onAppear {
            height = initialHeight
        }
        .onChange(of: initialHeight) { newValue in
            height = newValue
        }
    }
    
    // MARK: - Drag Indicator
    
    private let dragIndicatorSize: CGSize = CGSize(width: 64, height: 6)
    private let dragIndicatorTopPadding: CGFloat = 8
    private let dragIndicatorBottomPadding: CGFloat = 10
    private var dragIndicatorBlocHeight: CGFloat {
        dragIndicatorSize.height + dragIndicatorTopPadding + dragIndicatorBottomPadding
    }
    
    private func dragIndicator() -> some View {
        Color.gray.opacity(0.5)
            .frame(
                width: dragIndicatorSize.width,
                height: dragIndicatorSize.height
            )
            .clipShape(Capsule())
            .padding(.top, dragIndicatorTopPadding)
            .padding(.bottom, dragIndicatorBottomPadding)
            .frame(maxWidth: .infinity, maxHeight: dragIndicatorBlocHeight)
    }
}
