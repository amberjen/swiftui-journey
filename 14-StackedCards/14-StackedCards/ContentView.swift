//
//  ContentView.swift
//  14-StackedCards
//
//  Created by Amber Jen on 2025/7/27.
//

import SwiftUI

// Data model for each card
struct CardItem: Identifiable {
    let id: Int
    let image: ImageResource
    
    var offset: CGFloat // The horizontal drag offset, used for animating position
    var zIndex: Double // The stacking order of the card (higher = on top)
    
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
    
    let textColors:[Color] = [
        Color(red: 173 / 255, green: 131 / 255, blue: 247 / 255),
        Color(red: 98 / 255, green: 212 / 255, blue: 227 / 255),
        Color(red: 222 / 255, green: 187 / 255, blue: 100 / 255),
        Color(red: 237 / 255, green: 107 / 255, blue: 113 / 255)
    ]
    
    init() {
        let imageList:[ImageResource] = [.card01, .card02, .card03, .card04]
        
        let createdCards:[CardItem] = imageList.enumerated().map{ (index, image) in
            
            CardItem(
                id: index,
                image: image,
                offset: 0.0, // Initial offset is 0, which means the card is centered
                zIndex: Double(imageList.count - 1 - index) // Earlier cards have higher zIndex, so they appear on top
            )
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
                        .foregroundStyle(textColors[currentActiveIndex])
                )
                .animation(.easeInOut(duration: 0.2), value: currentActiveIndex)
                .multilineTextAlignment(.center)
                .font(.system(size: 40, weight: .regular))
                .padding(.horizontal, 24)
            
                
                ZStack {
                    
                    
                    ForEach(cards) { card in
                            CardView(
                                card: card,
                                isActive: card.id == currentActiveIndex,
                                maxOffset: maxOffset,
                                currentOffset: cards[currentActiveIndex].offset
                            )
                            .gesture(
                                // Only the top card  can be dragged
                                card.id != currentActiveIndex ? nil : DragGesture()
                                    .onChanged({ value in
                                        
                                        withAnimation(.linear(duration: 0.1)) {
                                            
                                            // Only allow movement if drag distance is within allowed range
                                            if abs(value.translation.width) <= maxOffset {
                                                // Update card's offset so it visibily moves with the drag
                                                cards[currentActiveIndex].offset = value.translation.width
                                                
                                                // Ensure the active card stays on top using zIndex and animation
                                                withAnimation {
                                                    cards[currentActiveIndex].zIndex = Double(cards.count - 1)
                                                }
                                            } else {
                                                
                                                // If drag exceeds the limit, prepare to move this card to bottom
                                                cards[currentActiveIndex].zIndex = 0
                                            }
                                        }
                                    })
                                    .onEnded({ value in
                                        
                                        // If drag was far enough, initiate card "flip" or "dismiss"
                                        if abs(value.translation.width) > maxOffset {
                                            
                                            // Raise all other cards' zIndex, and push the dragged card to the bottom
                                            cards.forEach { cards[$0.id].zIndex += 1}
                                            cards[currentActiveIndex].zIndex = 0
                                        }
                                        
                                        withAnimation {
                                            // Reset the card's position to center (if still active)
                                            cards[currentActiveIndex].offset = .zero
                                            
                                            // Find the card with highest zIndex and make it the new active card
                                            let topCard = cards.first(where: { $0.zIndex == Double(cards.count - 1)})
                                            currentActiveIndex = topCard?.id ?? 0
                                            finalSelectedIndex = currentActiveIndex
                                            
                                        }
                                        
                                    })
                            )
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 64)
                .padding(.bottom, 104)
//                .overlay(
//                    Rectangle()
//                        .stroke(.cyan, lineWidth: 1)
//                )

                
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

// View of displaying a single card
struct CardView: View {
    
    var card: CardItem
    var isActive: Bool
    var maxOffset: CGFloat
    var currentOffset: CGFloat
    
    var body: some View {
        
        // Compute the 3D Y axis rotation while dragging
        // Max rotation is -25 degrees when dragged to maxOffset
        let rotation3D = (card.offset / maxOffset) * -25.0
        
        let tiltAngle: Double = {
            if isActive {
                return (card.offset / maxOffset) * 10 // Active card tilts up to ±10 degrees based on drag
            } else {
                let baseAngle = 15 * (1 - abs(currentOffset / maxOffset)) // Even-numbered cards tilt -15° toward bottom-left, Odd--numbered cards tilt +15° toward bottom-right
                return card.id % 2 == 0 ? baseAngle : -baseAngle
            }
        }()
        
        let scale: CGSize = {
            if isActive {
                return CGSize( // Active card shrink while dragging to simulate movement away from the viewer
                    width: 1 - abs(currentOffset /  maxOffset) * 0.5, // Shrink up to 50% width
                    height: 1 - abs(currentOffset /  maxOffset) * 0.3 // Shrink up to 70% height
                )
            } else {
                let scaleFactor = 0.8 + 0.2 * abs(currentOffset /  maxOffset)
                return CGSize( // Inactive cards scale up to slighlty as active card moves, to simulate rising up
                    width: scaleFactor,
                    height: scaleFactor
                )
            }
        }()
        
        let anchor: UnitPoint = card.id % 2 == 0 ? .bottomLeading : .bottomTrailing
        
        Image(card.image)
            .resizable()
            .scaledToFill()
            .frame(width: 240, height: 320)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.white.opacity(0.2), lineWidth: 4)
                    .padding(-1)
            )
            .offset(x: card.offset)
            .zIndex(card.zIndex)
            .rotation3DEffect( // Create 3D rotation effect on Y axis while draggin
                .degrees(rotation3D),
                axis: (x: 0, y: 1, z: 0) // Rotate around Y axis (horizontal flip)
            )
            .rotationEffect(
                // Tilt the card based on drag (active card) or give static tilt to background cards
                .degrees(tiltAngle), anchor: anchor
            )
            .scaleEffect(scale)
        
    }
}



#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
