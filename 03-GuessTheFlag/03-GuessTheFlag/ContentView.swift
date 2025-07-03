//
//  ContentView.swift
//  03-GuessTheFlag
//
//  Created by Amber Jen on 2025/7/2.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var scoreMsg = ""
    
    var body: some View {
            
            
            ZStack {

                
                VStack(spacing: 20) {
                    
                    Text("Guess The Flag")
                        .foregroundStyle(.white)
                        .font(.headline)
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { number in
                            Button {
                                // btn tapped
                                flagTapped(number)
                            } label: {
                                Image(countries[number])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 88, height: 64)
                                    .clipShape(.rect(cornerRadius: 12))
                                    .shadow(radius: 3)
                            }
                            
                        } // end foreach
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 32)
                    Spacer()
                    
                    Text("Score: \(score)")
                        .padding(.bottom, 12)
                    
                } // end outer vstack
                
            }
            .alert(scoreTitle, isPresented: $showScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text(scoreMsg)
            }
            
        
    }
    
    func flagTapped(_ number: Int) {
        if (number == correctAnswer) {
            scoreTitle = "Correct"
            score += 1
            scoreMsg = "Great job!"
        } else {
            scoreTitle = "Wrong"
            if (score >= 1) {
                score -= 1
            }
            scoreMsg = "That's the flag of \(countries[number])"
        }
        
        showScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
