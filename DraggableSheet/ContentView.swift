//
//  ContentView.swift
//  DraggableSheet
//
//  Created by Nicolas Bouème on 2025/08/15.
//

import SwiftUI

struct ContentView: View {
    @State private var topContentHeight: CGFloat = 0
    @State private var whiteContentHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                topContent()
                
                VStack {
                    Spacer()
                    DraggableBottomSheet(
                        minHeight: geometry.size.height - topContentHeight,
                        maxHeight: geometry.size.height - whiteContentHeight
                    ) {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(0..<100) { index in
                                    Text("Item \(index + 1)")
                                        .padding()
                                        .background(Color.clear)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    private func topContent() -> some View {
        VStack(spacing: 0) {
            Color.white
                .frame(height: 100)
                .coordinateSpace(name: "whiteContent")
                .readSize(in: "whiteContent") { height in
                    whiteContentHeight = height
                }
            Color.blue
                .frame(height: 100)
            Color.red
                .frame(height: 100)
        }
        .coordinateSpace(name: "topContent")
        .readSize(in: "topContent") { height in
            topContentHeight = height
        }
    }
}

#Preview {
    ContentView()
}
