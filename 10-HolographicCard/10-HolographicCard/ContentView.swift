//
//  ContentView.swift
//  10-HolographicCard
//
//  Created by Amber Jen on 2025/7/15.
//

import SwiftUI

struct ContentView: View {
    
    @State private var vertical: Double = 0
    @State private var horizontal: Double = 0
    
    var width: CGFloat = 280
    var height: CGFloat = 428
    var img = "card"
    
    var body: some View {
        
        ZStack {
            
            Image(img)
                .resizable()
                .scaledToFit()
            
            Image(.togographic)
                .renderingMode(.template)
                .resizable()
            
            
        } // END: zstack
        .frame(width: width, height: height)
        .mask(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
