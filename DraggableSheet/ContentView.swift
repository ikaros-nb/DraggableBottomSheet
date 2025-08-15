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
            ZStack(alignment: .top) {
                topContent()
                
                VStack {
                    Spacer()
                    DraggableBottomSheet(
                        minHeight: 350,
                        maxHeight: 700
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
            .ignoresSafeArea(.all, edges: .bottom)
    }
    
    private func topContent() -> some View {
        VStack(spacing: 0) {
            Color.white
                .frame(height: 100)
            Color.blue
                .frame(height: 100)
            Color.red
                .frame(height: 100)
        }
    }
}

#Preview {
    ContentView()
}
