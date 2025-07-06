//
//  ContentView.swift
//  05-Animations
//
//  Created by Amber Jen on 2025/7/5.
//

import SwiftUI

struct ContentView: View {
    
    @State private var glowAnimationAmount = 1.0
    @State private var spinAnimationAmount = 0.0
    
    @State private var cardDragAmount = CGSize.zero
    
    @State private var enabled = false
    @State private var letterDragAmount = CGSize.zero
    
    
    let letters = Array("Try Me")
    
    var body: some View {
        
        
        VStack(spacing: 64) {
            /* --------------------------------------------------------
             Part I - Btn
             -------------------------------------------------------- */
            Button("Watch Me") {
            }
            .frame(width: 112, height: 112)
            .background(.indigo)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .overlay(
                Circle()
                    .stroke(.indigo)
                    .scaleEffect(glowAnimationAmount)
                    .opacity(2 - glowAnimationAmount)
                    .animation(
                        .easeInOut(duration: 2).repeatForever(autoreverses: false),
                        value: glowAnimationAmount
                    )
            )
            .onAppear {
                glowAnimationAmount = 2
            }
            
            
            /* --------------------------------------------------------
             Part II - Btn
             -------------------------------------------------------- */
            Button("Tap Me") {
                withAnimation(.spring(duration: 1, bounce: 0.5)) {
                    spinAnimationAmount += 360
                }
            }
            .frame(width: 112, height: 112)
            .background(.pink)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .rotation3DEffect(.degrees(spinAnimationAmount), axis:  (x: 0, y: 1, z: 0))
            
            
            /* --------------------------------------------------------
             Part III - Draggable Card
             -------------------------------------------------------- */
            ZStack {
                Rectangle()
                    .fill(Color.cyan)
                    .frame(width: 112, height: 112)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        Text("Drag Me")
                            .foregroundStyle(.black)
                    )
                    .offset(cardDragAmount)
                    .gesture(
                        DragGesture()
                            .onChanged { cardDragAmount = $0.translation }
                            .onEnded { _ in
                                withAnimation(.bouncy) {
                                    cardDragAmount = .zero
                                }
                            }
                    )
            }
            
            
            /* --------------------------------------------------------
             Part IV - Offset + Drag + Delay
             -------------------------------------------------------- */
            HStack(spacing: 4) {
                ForEach(0..<letters.count, id: \.self) { num in
                    Text(String(letters[num]))
                        .textCase(.uppercase)
                        .frame(width: 32, height: 32)
                        .background(enabled ? .white : .gray)
                        .foregroundStyle(enabled ? .black : .white)
                        .offset(letterDragAmount)
                        .animation(.linear.delay(Double(num) / 20), value: letterDragAmount)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { letterDragAmount = $0.translation }
                    .onEnded { _ in
                        letterDragAmount = .zero
                        enabled.toggle()
                    }
                    
                
            )
                
            
            
            
        }
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
