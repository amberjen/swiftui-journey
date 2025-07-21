//
//  ContentView.swift
//  Playground
//
//  Created by Amber Jen on 2025/7/18.
//

import SwiftUI

struct ContentView: View {
    
     @State private var change = false
    
    var body: some View {
        
        
        VStack(spacing: 24) {
             
            
            Button("Change") {
                change.toggle()
            }
            
        }
        
       
      
    }
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
