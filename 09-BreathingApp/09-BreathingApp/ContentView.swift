//
//  ContentView.swift
//  09-BreathingApp
//
//  Created by Amber Jen on 2025/7/13.
//

import SwiftUI

struct ContentView: View {
    // Animation bools
    @State private var scaleUpDown = false
    @State private var rotateInOut = false
    @State private var moveInOut = false

    var body: some View {
    
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .ignoresSafeArea()
            
            ZStack {
                
                // MARK: - ZStack for 12 & 6 O'clock circles
                ZStack {
                    
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120)
                        .offset(y: moveInOut ? -60 : 0)
                    
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .bottom, endPoint: .top))
                        .frame(width: 120, height: 120, alignment: .center)
                        .offset(y: moveInOut ? 60 : 0)
                    
                }
                .opacity(0.5)
                
                // MARK: - ZStack for 2 & 7 O'clock circles
                ZStack {
                    
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120, alignment: .center)
                        .offset(y: moveInOut ? -60 : 0)
                    
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .bottom, endPoint: .top))
                        .frame(width: 120, height: 120, alignment: .center)
                        .offset(y: moveInOut ? 60 : 0)
                }
                .opacity(0.5)
                .rotationEffect(.degrees(60))
                
                // MARK: - ZStack for 10 & 4 O'clock circles
                ZStack {
                    
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120, alignment: .center)
                        .offset(y: moveInOut ? -60 : 0)
                    
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.indigo, .white]), startPoint: .bottom, endPoint: .top))
                        .frame(width: 120, height: 120, alignment: .center)
                        .offset(y: moveInOut ? 60 : 0)
                }
                .opacity(0.5)
                .rotationEffect(.degrees(120))
            }
            // MARK: - Animations
            .rotationEffect(.degrees(rotateInOut ? 90 : 0))
            .scaleEffect(scaleUpDown ? 1 : 0.25)
            .animation(.easeInOut.repeatForever(autoreverses: true).speed( 1 / 8), value: scaleUpDown)
            .onAppear() {
                rotateInOut.toggle()
                scaleUpDown.toggle()
                moveInOut.toggle()
            }
            
            
        } // END: outer zstack
        
    } // END: body
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
