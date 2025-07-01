//
//  ContentView.swift
//  02-Snackify
//
//  Created by Amber Jen on 2025/6/30.
//

// Snackify = “Turn your steps into snacks!”

import SwiftUI

struct ContentView: View {
    
    @State private var stepCount: Int? = 0
    @State private var snackType = "🍕"
    @FocusState private var stepsIsFocous: Bool
    
    let snackTypes = ["🍒", "🍿", "🍕", "🍟", "🍔"]
    let caloriesPerStep = 4
    let snackCalories: [String: Int] = [
        "🍒": 80,
        "🍿": 200,
        "🍕": 400,
        "🍟": 700,
        "🍔": 1100
    ]
    
    var earnedSnacks: Int {
        let steps = stepCount ?? 0
        let totalCalories = steps * caloriesPerStep
        let caloriesPerSnack = snackCalories[snackType] ?? 100
        return totalCalories / caloriesPerSnack
    }
    
    var totalCaloriesBurned: Int {
        let steps = stepCount ?? 0
        return steps * caloriesPerStep
    }
    
    
    var body: some View {
        NavigationStack {
            
            Text("Walk some steps to see how many snacks you've earned!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
            
            Form {
                Section("Step Count") {
                    TextField("Steps", value: $stepCount, format: .number.grouping(.automatic))
                        .keyboardType(.numberPad)
                        .focused($stepsIsFocous)
                        .onChange(of: stepsIsFocous) {
                            if stepsIsFocous && stepCount == 0 {
                                stepCount = nil
                            }
                            
                        }
                }
                
                Section("Pick Your Snack") {
                    VStack {
                        Picker("Snack Type", selection: $snackType) {
                            ForEach(snackTypes, id: \.self) { snack in
                                Text("\(snack)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.vertical, 4)
                    
                }
                
                Section("Snack Reward") {
                    let steps = stepCount ?? 0
                    
                    if steps > 0 {
                        Text("\(earnedSnacks) \(snackType)")
                    } else {
                        Text("No \(snackType) yet, keep walking!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
            .navigationTitle("Snackify 🍬")
            .toolbar {
                if stepsIsFocous {
                    Button("Done") {
                        stepsIsFocous = false
                    }
                }
            }
            

        }
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
