//
//  ContentView.swift
//  11-GlowText
//
//  Created by Amber Jen on 2025/7/16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animate = false
    
    let gradientColors: [Color] = [
        .yellow, .mint, .yellow, .purple, .orange, .pink, .purple,
        .cyan, .purple, .pink, .orange, .yellow, .mint, .yellow
    ]
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing)
                .frame(width: UIScreen.main.bounds.width * 9, height: 400)
                .offset(x: animate ? UIScreen.main.bounds.width * -3.5 : UIScreen.main.bounds.width * 4 )
                .animation(.linear(duration: 15).repeatForever(autoreverses: false), value: animate)
                .rotationEffect(.degrees(15))
                .rotationEffect(.degrees(180))
                .onAppear {
                    animate = true
                }
                .mask {
                    Text("Gradient Glow Text")
                        .font(.system(size: 40, weight: .semibold))
                }
            
        }
        .frame(width: 340, height: 40)
        
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
