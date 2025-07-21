//
//  ContentView.swift
//  13-DynamicTab
//
//  Created by Amber Jen on 2025/7/21.
//

import SwiftUI

struct TabModel: Identifiable {
    var id = UUID()
    var icon: String
    var title: String
}

struct ContentView: View {
    
    @State private var selectedTab = 0
    
    var tabs: [TabModel] = [
        TabModel(icon: "person.fill", title: "Primary"), // 0
        TabModel(icon: "cart.fill", title: "Transactions"), // 1
        TabModel(icon: "sparkles", title: "Updates"), // 2
        TabModel(icon: "tag.fill", title: "Promotions") // 3
    ]
    
    var body: some View {
        
        GeometryReader { geo in
            
            HStack(spacing: 0) {
                // 0
                view1()
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    
                // 1
                view2()
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                
                // 2
                view3()
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                
                // 3
                view4()
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
            
                
            } // H
            .offset(x: -geo.size.width * 0)
            
            
        } // GR
        .overlay(alignment: .center) {
            HStack {
                ForEach(tabs.indices, id:\.self) { tab in
                    
                    HStack {
                        Image(systemName: tabs[tab].icon)
                        
                        if selectedTab == tab {
                            Text(tabs[tab].title).bold()
                                .transition(.scale(scale: 0, anchor: .trailing).combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: selectedTab == tab ? .infinity : 56)
                    .frame(height: 56)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(16)
                    .clipped()
                    .onTapGesture {
                        withAnimation {
                            selectedTab = tab
                        }
                    } // tapgesture
                    
                } // foreach
            } // h
            
            
        } // overlay
        .padding(24)
    
        
    }
}

struct view1: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
//            Text("View 1")
//                .font(.title)
        } // z
    }
}

struct view2: View {
    var body: some View {
        ZStack {
            Color.indigo
                .ignoresSafeArea()
            
            Text("View 2")
                .font(.title)
        } // z
    }
}

struct view3: View {
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            Text("View 3")
                .font(.title)
        } // z
    }
}

struct view4: View {
    var body: some View {
        ZStack {
            Color.cyan
                .ignoresSafeArea()
            
            Text("View 4")
                .font(.title)
        } // z
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
