//
//  ContentView.swift
//  14-StackedCards
//
//  Created by Amber Jen on 2025/7/27.
//

import SwiftUI

struct CardItem: Identifiable {
    let id: Int
    let image: ImageResource
    var zIndex: Double
    var offset: CGFloat
}

struct ContentView: View {
    
    @State private var currentActiveIndex = 0
    @State private var finalSelectedIndex = 0
    @State private var cards: [CardItem] = []
    
    let imageSize: CGSize = CGSize(width: 240, height: 320)
    let maxOffset: CGFloat
    
    let bgColors:[Color] = [
        Color(red: 19 / 255, green: 11 / 255, blue: 33 / 255),
        Color(red: 6 / 255, green: 21 / 255, blue: 23 / 255),
        Color(red: 28 / 255, green: 22 / 255, blue: 7 / 255),
        Color(red: 33 / 255, green: 11 / 255, blue: 22 / 255)
    ]
    
    init() {
        let images:[ImageResource] = [.card01, .card02, .card03, .card04]
        
        let createdCards = images.enumerated().map{ (id, image) in
            
            CardItem(id: id, image: image, zIndex: Double(images.count - 1 - id), offset: 0.0)
        }
        
        
        self.maxOffset = imageSize.width * 0.75
        self._cards = State(initialValue: createdCards)
    }
    
    var body: some View {
        
        ZStack {
            
            Color(bgColors[currentActiveIndex])
                .opacity(0.85)
                .ignoresSafeArea()
            
            VStack {
                
                (
                    Text("Unleash The") +
                    Text(" chromatic magic ")
                        .font(.system(size: 40, weight: .ultraLight , design: .serif))
                        .italic()
                )
                    .multilineTextAlignment(.center)
                    .font(.system(size: 40, weight: .regular))
                    .padding(.horizontal, 24)
                
                
                ZStack {
                    
                    
                    ForEach(cards) { card in
                        Image(card.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageSize.width, height: imageSize.height)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white.opacity(0.2), lineWidth: 4)
                                    .padding(-1)
                                    
                            )
                            .offset(x: card.offset)
                            .zIndex(card.zIndex)
                            .rotation3DEffect(
                                .degrees(card.offset / maxOffset * -25.0),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                            .rotationEffect(
                                .degrees(
                                    card.id == currentActiveIndex ?
                                    (card.offset / maxOffset * 10.0) : card.id % 2 == 0 ?
                                    (15 * (1 - abs(cards[currentActiveIndex].offset / maxOffset))) :
                                    (-15 * (1 - abs(cards[currentActiveIndex].offset / maxOffset)))
                                ),
                                anchor: card.id % 2 == 0 ? .bottomLeading : .bottomTrailing
                            )
                            .scaleEffect(
                                card.id == currentActiveIndex ?
                                CGSize(
                                    width: 1 - (abs(card.offset / maxOffset) * 0.5),
                                    height: 1 - (abs(card.offset / maxOffset) * 0.3)
                                ) :
                                CGSize(
                                    width: 0.8 + (0.2 * abs(cards[currentActiveIndex].offset / maxOffset)),
                                    height: 0.8 + (0.2 * abs(cards[currentActiveIndex].offset / maxOffset))
                                )
                                    
                            )
                            .gesture(
                                card.id != currentActiveIndex ? nil : DragGesture()
                                    .onChanged({ value in
                                        withAnimation(.linear(duration: 0.1)) {
                                            if abs(value.translation.width) <= maxOffset {
                                                cards[currentActiveIndex].offset = value.translation.width
                                                withAnimation {
                                                    cards[currentActiveIndex].zIndex = Double(cards.count - 1)
                                                }
                                            } else {
                                                cards[currentActiveIndex].zIndex = 0
                                            }
                                        }
                                    })
                                    .onEnded({ value in
                                        if abs(value.translation.width) > maxOffset {
                                            cards.forEach { cards[$0.id].zIndex += 1}
                                            cards[currentActiveIndex].zIndex = 0
                                        }
                                        
                                        withAnimation {
                                            cards[currentActiveIndex].offset = .zero
                                            let topCard = cards.first(where: { $0.zIndex == Double(cards.count - 1)})
                                            currentActiveIndex = topCard?.id ?? 0
                                            finalSelectedIndex = currentActiveIndex
                                            
                                        }
                                        
                                    })
                            )
                    }
                }
                .padding(80)
                
                
                Text("\(currentActiveIndex + 1) / \(cards.count)")
                    .font(.system(size: 14))
                    .monospacedDigit()
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(width: 64, height: 40)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.15))
                    )
                
                
            }
        }
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
