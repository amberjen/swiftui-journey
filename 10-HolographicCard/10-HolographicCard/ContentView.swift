//
//  ContentView.swift
//  10-HolographicCard
//
//  Created by Amber Jen on 2025/7/15.
//

import SwiftUI

struct ContentView: View {
    
    // Track vertical and horizontal rotation angles
    @State private var vertical: Double = 0
    @State private var horizontal: Double = 0
    
    var width: CGFloat = 280
    var height: CGFloat = 428
    var img = "card"
    
    var body: some View {
        
        ZStack {
            
            Image(img)
                .resizable()
                .scaledToFit()
            
            Image(.togographic)
                .renderingMode(.template) //  Treat image as template to apply colors
                .resizable()
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .green, .yellow, .pink, .indigo],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .mask {
                    reflection(blur: 10)
                }
                
            // Call reflection func again to create stronger blur glow effect
            reflection(blur: 60)
                
            
            
        } // END: zstack
        .frame(width: width, height: height)
        .mask(RoundedRectangle(cornerRadius: 20))
        // Rotate around X-axis based on vertical variable (tilt up/down)
        .rotation3DEffect(.degrees(vertical), axis: (x: 1, y: 0, z: 0))
        // Rotate around Y-axis based on horizontal variable (tilt left/right)
        .rotation3DEffect(.degrees(horizontal), axis: (x: 0, y: 1, z: 0))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    withAnimation {
                        // Divide drag distance by 10 to slow down rotation speed
                        // Limit rotation angle range: vertical ±20°, horizontal ±15°
                        vertical = min(max(Double(value.translation.height / 10), -20), 20)
                        horizontal = min(max(Double(value.translation.width / 10), -15), 15)
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        vertical = 0
                        horizontal = 0
                    }
                }
        )
    }
    
    
    func reflection(blur: CGFloat) -> some View {
        Circle()
            .foregroundStyle(.white)
            .frame(width: 150, height: 150)
            // Adjust light source position based on card tilt angle (amplified 10x)
            .offset(x: horizontal * 10, y: vertical * 10)
            .blur(radius: blur)
            // Opacity calculated based on tilt degree, max 0.8 (using Pythagorean theorem for distance)
            .opacity(min(sqrt(vertical * vertical + horizontal * horizontal) / 8, 0.8))
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
