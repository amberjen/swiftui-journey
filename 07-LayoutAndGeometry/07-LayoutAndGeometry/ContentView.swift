//
//  ContentView.swift
//  07-LayoutAndGeometry
//
//  Created by Amber Jen on 2025/7/10.
//

import SwiftUI

struct ContentView: View {
    
    let colors: [Color] = (0..<7).map { i in
        Color(hue: 0.7, saturation: 0.5 + (Double(i) * 0.07), brightness: 1.0 - (Double(i) * 0.05))
    }
    
    var body: some View {
        
        GeometryReader { fullView in
            ScrollView {
                
                ForEach(0..<75) { index in
                    GeometryReader { proxy in
                    
                        let yPosition = proxy.frame(in: .global).minY
                        let opacity = yPosition < 120 ? yPosition / 120 : 1.0
                        let scale = 0.5 + (yPosition / fullView.size.height) * 0.6
                        
                        Text("Row \(index)")
                            .font(Font.title2)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(colors[index % 7])
                            .rotation3DEffect(
                                .degrees((proxy.frame(in: .global).minY - fullView.size.height / 2) / 4.0),
                                axis: (x: 0, y: 1, z: 0))
                            .opacity(opacity)
                            .scaleEffect(scale)
                        
                    }
                    .frame(height: 44)
                }
                
            } // END: scrollview
        }
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
