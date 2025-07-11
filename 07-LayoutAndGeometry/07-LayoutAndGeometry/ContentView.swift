//
//  ContentView.swift
//  07-LayoutAndGeometry
//
//  Created by Amber Jen on 2025/7/10.
//

import SwiftUI

struct ContentView: View {
    
    let colors:[Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]
    
    var body: some View {
        
        GeometryReader { fullView in
            ScrollView {
                
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        Text("Row \(index)")
                            .font(Font.title)
                            .frame(maxWidth: .infinity)
                            .background(colors[index % 7])
                            .rotation3DEffect(
                                .degrees((proxy.frame(in: .global).minY - fullView.size.height / 2) / 5.0),
                                axis: (x: 0, y: 1, z: 0))
                            
                    }
                    .frame(height: 48)
                }
                
            } // END: scrollview
        }
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
