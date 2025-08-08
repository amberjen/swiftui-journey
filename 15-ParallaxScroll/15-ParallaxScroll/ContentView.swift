//
//  ContentView.swift
//  15-ParallaxScroll
//
//  Created by Amber Jen on 2025/8/7.
//

import SwiftUI

// MARK: - Data Model
struct TravelDestination: Identifiable {
    let id: UUID = UUID()
    var title: String
    var subtitle: String
    var image: String
}

// MARK: - Parallax Carousel View
struct ParallaxCarousel: View {
    
    let destinations = [
        TravelDestination(title: "Chicago", subtitle: "USA", image: "img1"),
        TravelDestination(title: "Venice", subtitle: "Italy", image: "img2"),
        TravelDestination(title: "Paris", subtitle: "France", image: "img3"),
    ]
    
    var body: some View {
        
    }
}

struct ContentView: View {
    

    
    var body: some View {
        
        
    }
    

    
}

#Preview {
    ContentView()
}
