//
//  ContentView.swift
//  15-ParallaxScroll
//
//  Created by Amber Jen on 2025/8/7.
//

import SwiftUI

// MARK: - Data Model
struct TravelDestination: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let subtitle: String
    let image: String
}

// MARK: - Parallax Carousel View
struct ParallaxCarousel: View {
    
    private let destinations = [
        TravelDestination(title: "Chicago", subtitle: "USA", image: "img1"),
        TravelDestination(title: "Venice", subtitle: "Italy", image: "img2"),
        TravelDestination(title: "Paris", subtitle: "France", image: "img3"),
        TravelDestination(title: "London", subtitle: "United Kingdom", image: "img4")
    ]
    
    private let cardWidth: CGFloat = 320
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 4) {
                    ForEach(destinations) { destination in
                        ParallaxCard(destination: destination)
                    }
                }
                .padding(.horizontal, (geometry.size.width - cardWidth) / 2)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
}

// MARK: - Parallax Card View
struct ParallaxCard: View {
    
    let destination: TravelDestination
    
    private let cardWidth: CGFloat = 320
    private let cardHeight: CGFloat = 560
    private let imageWidth: CGFloat = 400
    private let parallaxMultiplier: CGFloat = 80
    
    var body: some View {
        GeometryReader { geo in
            let minX = geo.frame(in: .global).minX
            
            ZStack(alignment: .bottomLeading) {
                Image(destination.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageWidth, height: cardHeight)
                    .offset(x: parallaxOffset(minX: minX))
                    .clipped()
                
                Rectangle()
                    .fill(
                        .linearGradient(
                            colors: [.clear, .clear, .black.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                textContent

                
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(.rect(cornerRadius: 16))
        .scrollTransition(.animated) { content, phase in
            content
                .scaleEffect(phase.isIdentity ? 1 : 0.95)
                .opacity(phase.isIdentity ? 1 : 0.8)
        }
        
    }
    
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(destination.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text(destination.subtitle)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(32)
    }
    
    private func parallaxOffset(minX: CGFloat) -> CGFloat {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let cardWidth: CGFloat = 320
        let progress = (minX - screenWidth / 2 + cardWidth / 2) / screenWidth
        return progress * parallaxMultiplier
    }
    
}

struct ContentView: View {
    

    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 4) {
                
                headerView
                ParallaxCarousel()
                
                Spacer()
            }
            .toolbar(.hidden)
        }
        
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text("Where do you want to travel?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }
    

    
}

#Preview {
    ContentView()
}
