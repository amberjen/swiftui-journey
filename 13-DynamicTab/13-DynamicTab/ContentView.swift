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
    var iconFill: String
    var title: String
    var selectedColor: Color
}

struct ContentView: View {
    
    @State private var selectedTab = 2
    
    var tabs: [TabModel] = [
        TabModel(icon:"person", iconFill: "person.fill", title: "Primary", selectedColor: .pink), // Tab 0
        TabModel(icon:"cart", iconFill: "cart.fill", title: "Cart", selectedColor: .indigo), // Tab 1
        TabModel(icon:"creditcard", iconFill: "creditcard.fill", title: "Payment", selectedColor: .blue), // Tab 2
        TabModel(icon:"tag", iconFill: "tag.fill", title: "Promo", selectedColor: .brown) // Tab 3
    ]
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    ForEach(tabs.indices, id:\.self) { tab in
                        
                        HStack {
                            Image(systemName: selectedTab == tab ? tabs[tab].iconFill : tabs[tab].icon)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(selectedTab == tab ? .white : .white.opacity(0.5))
                            
                            if selectedTab == tab {
                                Text(tabs[tab].title).bold()
                                    .font(.system(size: 18, weight: .bold))
                                    .transition(
                                        .asymmetric(
                                            insertion: .scale(scale: 0.95, anchor: .trailing).combined(with: .opacity),
                                            removal: .opacity
                                        )
                                        
                                    )
                            }
                        }
                        .font(.title3)
                        .frame(maxWidth: selectedTab == tab ? .infinity : 56)
                        .frame(height: 56)
                        .background(
                            selectedTab == tab ? tabs[tab].selectedColor : Color.white.opacity(0.1)
                        )
                        .cornerRadius(16)
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.25, bounce: 0.35)) {
                                selectedTab = tab
                            }
                        }
                        
                    } // ForEach
                    
                } // H
                
                
            } // V
            .padding(24)
            
            
        }
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
