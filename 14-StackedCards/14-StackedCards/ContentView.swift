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
    
    var offset: CGFloat // The horizontal drag offset
    var zIndex: Double // The stacking order (higher = on top)
    
}

// MARK: - Helper Funciton
// Create initial cards
private func createInitialCards() -> [CardItem] {
    
    let imageList:[ImageResource] = [.card01, .card02, .card03, .card04]
    
    
    return (
        imageList.enumerated().map{ (index, image) in
            
            CardItem(
                id: index,
                image: image,
                offset: 0.0, // Start in center
                zIndex: Double(imageList.count - 1 - index) // First card on top
            )
        }
    )
    
}



struct ContentView: View {
    
    // MARK: - State properties
    @State private var currentActiveIndex: Int = 0 // Which card is on top
    @State private var cards: [CardItem] = createInitialCards()
    
    // MARK: - Settings
    private let imageSize: CGSize = CGSize(width: 240, height: 320) // Card size
    private let maxDragDistance: CGFloat = 240 * 0.75 // How far you can drag (75% of card width)
    
    private let bgColors: [Color] = [
        Color(red: 19 / 255, green: 11 / 255, blue: 33 / 255),
        Color(red: 6 / 255, green: 21 / 255, blue: 23 / 255),
        Color(red: 28 / 255, green: 22 / 255, blue: 7 / 255),
        Color(red: 33 / 255, green: 11 / 255, blue: 22 / 255)
    ]
    
    private let textColors: [Color] = [
        Color(red: 173 / 255, green: 131 / 255, blue: 247 / 255),
        Color(red: 98 / 255, green: 212 / 255, blue: 227 / 255),
        Color(red: 222 / 255, green: 187 / 255, blue: 100 / 255),
        Color(red: 237 / 255, green: 107 / 255, blue: 113 / 255)
    ]
    
    var body: some View {
        
        ZStack {
            
            bgColors[currentActiveIndex]
                .opacity(0.85)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.3), value: currentActiveIndex)
            
            VStack(spacing: 32) {
                
                // Title Text
                titleText
                
                // The Card Stack
                cardStack
                
                // Page Counter
                pageCounter
                
            }
        }
        
    }
    
    // MARK: - Title Text
    private var titleText: some View {
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
    }
    
    // MARK: - Card Stack
    private var cardStack: some View {
        ZStack {
            
            ForEach(cards) { card in
                    CardView(
                        card: card,
                        isActive: card.id == currentActiveIndex,
                        maxOffset: maxDragDistance,
                        currentOffset: cards[currentActiveIndex].offset
                    )
                    .gesture(dragGesture(for: card))
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 64)
        .padding(.bottom, 96)
    }
    
    // MARK: - Drag Gesture
    private func dragGesture(for card: CardItem) -> some Gesture {
        return DragGesture()
            .onChanged { dragValue in
                // Only process drag if this is the active card
                if card.id == currentActiveIndex {
                    handleDragMoving(dragValue)
                }
            }
            .onEnded { dragValue in
                // Only process drag end if this is the active card
                if card.id == currentActiveIndex {
                    handleDragFinished(dragValue)
                }
            }
    }
    
    // When user is dragging
    private func handleDragMoving(_ dragValue: DragGesture.Value) {
        withAnimation(.linear(duration: 0.1)) {
            
            let dragDistance = dragValue.translation.width
            
            // If drag is within limit
            if abs(dragDistance) <= maxDragDistance {
                // Move the card
                cards[currentActiveIndex].offset = dragDistance
                // Keep it on top
                cards[currentActiveIndex].zIndex = Double(cards.count - 1)
            } else {
                
                // If dragged too far, prepare to send to back
                cards[currentActiveIndex].zIndex = 0
            }
        }
    }
    
    // When user stops dragging
    private func handleDragFinished(_ dragValue: DragGesture.Value) {
        
        let dragDistance = dragValue.translation.width
        
        // If dragged far enough, switch cards
        if abs(dragDistance) > maxDragDistance {
            switchToNextCard()
        }
        
        // Reset position and find new top card
        withAnimation(.easeOut(duration: 0.3)) {
            cards[currentActiveIndex].offset = 0
            findNewActiveCard()
        }
    }
    
    // Move current card to back
    private func switchToNextCard() {
        //Move all other cards up
        for index in cards.indices {
            if index != currentActiveIndex {
                cards[index].zIndex += 1
            }
        }
        
        // Send current card to back
        cards[currentActiveIndex].zIndex = 0
    }
    
    // Find which card should be on top now
    private func findNewActiveCard() {
        // Look for the card with highest zIndex
        if let topCard = cards.max(by: {$0.zIndex < $1.zIndex}) {
            currentActiveIndex = topCard.id
        }
    }
    
    // MARK: - Page Counter
    private var pageCounter: some View {
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

// MARK: - Single card view
struct CardView: View {
    
    var card: CardItem
    var isActive: Bool // Is this the top card?
    var maxOffset: CGFloat
    var currentOffset: CGFloat // How far the top card is dragged
    
    var body: some View {
        
        // Calculate how much to rotate the card
        let spinAmount = (card.offset / maxOffset) * -25.0
        
        // Calcualte how much to tilt the card
        let tiltAmount: Double = {
            if isActive {
                
                // Active card tilts up to ±10 degrees based on drag
                return (card.offset / maxOffset) * 10
            } else {
                let baseTilt = 15 * (1 - abs(currentOffset / maxOffset)) // Even-numbered cards tilt -15° toward bottom-left, Odd--numbered cards tilt +15° toward bottom-right
                return card.id % 2 == 0 ? baseTilt : -baseTilt
            }
        }()
        
        let scaleAmount: CGSize = {
            if isActive {
                // Active cards get smaller when dragged
                let shrink = 1 - abs(currentOffset /  maxOffset) * 0.5
                return CGSize(width: shrink, height: shrink)
            } else {
                // Background card get slightly bigger
                let grow = 0.8 + 0.2 * abs(currentOffset /  maxOffset)
                return CGSize(width: grow, height: grow)
            }
        }()
                
        // Which corner to rotate around
        let rotationCorner: UnitPoint = card.id % 2 == 0 ? .bottomLeading : .bottomTrailing
        
        Image(card.image)
            .resizable()
            .scaledToFill()
            .frame(width: 240, height: 320)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.white.opacity(0.2), lineWidth: 4)
                    .padding(-1)
            )
            .offset(x: card.offset) // Move left or right
            .zIndex(card.zIndex) // Which layer
            .rotation3DEffect( // 3D spin effect
                .degrees(spinAmount),
                axis: (x: 0, y: 1, z: 0) // Spin around Y axis
            )
            .rotationEffect( // 2D tilt effect
                .degrees(tiltAmount),
                anchor: rotationCorner
            )
            .scaleEffect(scaleAmount) // Make bigger or smaller
    }
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
