//
//  ContentView.swift
//  04-BetterRest
//
//  Created by Amber Jen on 2025/7/4.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Sleep Goal") {
                    
                    VStack {
                        Stepper(
                            "\(sleepAmount.formatted()) hours",
                            value: $sleepAmount,
                            in: 4...12,
                            step: 0.5
                        )
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Wake-Up Time") {
                    
                    VStack {
                        DatePicker(
                            "Enter a date",
                            selection: $wakeUp,
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                    }
                }
                
                
                Section("Daily Coffee Intake") {
                    VStack {
                        Stepper(
                            "^[\(coffeeAmount) cup](inflect: true)",
                            value: $coffeeAmount,
                            in: 1...15
                        )
                    }
                    .padding(.vertical, 4)
                }
                
                
                Section("Recommended Bedtime") {
                    
                    HStack {
                        Text(calculatedBedtime)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(8)
                }
                
                
            } // END: form
            .navigationTitle("BetterRest")
            
        } // END: nav
        
    }
    
    var calculatedBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            
            let sleepTime = wakeUp - prediction.actualSleep
    
            return sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            return "Error calculating"
        }
    }
    
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
