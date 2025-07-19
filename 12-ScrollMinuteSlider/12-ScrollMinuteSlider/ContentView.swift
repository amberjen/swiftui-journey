//
//  ContentView.swift
//  12-ScrollMinuteSlider
//
//  Created by Amber Jen on 2025/7/18.
//

import SwiftUI

struct ContentView: View {
    
    @State private var value: Int = 0
    @State private var tempValue: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    let range: ClosedRange<Int> = 0...60
    let stepWidth: CGFloat = 20
    
    var body: some View {
        
        
            
        VStack(spacing: 40) {
                VStack {
                    Text("\(tempValue)")
                        .font(.system(size: 64, weight: .bold))
                        .contentTransition(.numericText())
                        .sensoryFeedback(.selection, trigger: tempValue)
                    
                    
                    Text("min").font(.system(size: 20, weight: .medium)).foregroundStyle(.gray)
                }
                
                
                GeometryReader { geo in
                    let center = geo.size.width / 2
                    
                    ForEach(range, id: \.self) { tick in
                        
                        let x = center + CGFloat(tick - value) * stepWidth + dragOffset
                        
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .fill(tick == tempValue ? .white : .gray.opacity(0.7))
                                .frame(width: tick == tempValue ? 3: 1, height: tick % 5 == 0 ? 20 : 10)
                            Text("\(tick)")
                                .bold()
                                .foregroundStyle(tick % 5 == 0 ? .white : .clear)
                                .offset(y: 10)
                        }
                        .position(x: x, y: geo.size.height / 2)
                        
                    }
                    .contentShape(Rectangle())
                    
                } // END: geometryreader
                .frame(height: 40)
                .gesture (
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            withAnimation(.interactiveSpring) {
                                let rawOffset = gesture.translation.width
                                let offsetSteps = rawOffset / stepWidth
                                var projected = CGFloat(value) - offsetSteps
                                let lower = CGFloat(range.lowerBound)
                                let upper = CGFloat(range.upperBound)
                                
                                if projected < lower {
                                    let overshoot = lower - projected
                                    projected = lower - log(overshoot + 1) * 2
                                } else if projected > upper {
                                    let overshoot = projected - upper
                                    projected = upper + log(overshoot + 1) * 2
                                }
                                
                                dragOffset = (CGFloat(value) - projected) * stepWidth
                                let rounded = Int(projected.rounded())
                                tempValue = rounded.clamped(to: range)
                                
                            }
                            
                        }
                        .onEnded { gesture in
                            let offsetSteps = gesture.translation.width / stepWidth
                            let projected = CGFloat(value) - offsetSteps
                            let finalValue = Int(projected.rounded()).clamped(to: range)
                            
                            withAnimation(.interpolatingSpring(stiffness: 120, damping: 20)) {
                                value = finalValue
                                tempValue = finalValue
                                dragOffset = 0
                            }
                            
                        }
                        
                )
            }
            .padding()
            
        
        
    }
}


extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
