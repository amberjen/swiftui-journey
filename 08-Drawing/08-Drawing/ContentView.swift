//
//  ContentView.swift
//  08-Drawing
//
//  Created by Amber Jen on 2025/7/12.
//

import SwiftUI

struct Flower: Shape {
    var petalOffset: Double = -20
    var petalWidth: Double =  100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            
            let position = rotation.concatenating(
                CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2)
            )
            
            let originalPetal = Path(ellipseIn: CGRect(
                x: petalOffset,
                y: 0,
                width: petalWidth,
                height: rect.width / 2)
            )
            
            let rotatedPetal = originalPetal.applying(position)
            
            path.addPath(rotatedPetal)
            
        }
        
        return path
    }
}

struct ContentView: View {
    
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    @State private var selectedColor = Color.pink
    @State private var isShapeFilled = false
    
    let availableColors: [Color] = [.pink, .yellow, .teal, .indigo]
    let accentColor: Color = .pink
    
    var body: some View {
 
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            
            VStack {
                
                // MARK: - The Flower Drawing
                VStack {
                    Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                        .fill(
                            isShapeFilled ? selectedColor : Color.clear,
                            style: FillStyle(eoFill: true)
                        )
                        .stroke(
                            selectedColor,
                            lineWidth: isShapeFilled ? 0 : 1
                        )
                        .frame(width: 300, height: 300)
                }
                .padding(.vertical, 80)
                
                Spacer()
                
                // MARK: - The Control Panel
                VStack(spacing: 16) {
                    
                    // MARK: - Color
                    HStack {
                        Text("Color")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 24) {
                            ForEach(availableColors, id: \.self) { color in
                                Button(action: {
                                    selectedColor = color
                                }) {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: selectedColor == color ? 1 : 0)
                                        )
                                } //  END: btn
                            }
                        } //  END: inner hstack
                    }
                    
                    Divider()
                    
                    // MARK: - Shape Fill
                    HStack {
                        Text("Shape Fill")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $isShapeFilled)
                            .toggleStyle(SwitchToggleStyle(tint: selectedColor))
                            .labelsHidden()
                    }
                    
                    Divider()
                    
                    // MARK: - Offset
                    HStack(spacing: 4) {
                        Text("Offset: \(Int(petalOffset))")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.white)
                            .frame(maxWidth: 104, alignment: .leading)
                            
                        
                        Spacer()
                        
                        Slider(value: $petalOffset, in: -44...44)
                            .tint(selectedColor)
                    }
                    
                    Divider()
                    
                    // MARK: - Width
                    HStack(spacing: 4) {
                        Text("Wdith: \(Int(petalWidth))")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(.white)
                            .frame(maxWidth: 104, alignment: .leading)
                            
                        
                        Spacer()
                        
                        Slider(value: $petalWidth, in: 0...100)
                            .tint(selectedColor)
                            // .padding(.horizontal)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        // .fill(Color.gray.opacity(0.15))
                        .fill(.ultraThinMaterial)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
            } // END: vstack
        }
        
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
