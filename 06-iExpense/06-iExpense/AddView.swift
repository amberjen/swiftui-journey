//
//  AddView.swift
//  06-iExpense
//
//  Created by Amber Jen on 2025/7/8.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Personal", "Business"]
    
    var expenses: Expenses
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                
            } // END: form
            .padding(.top, 16)
            .navigationTitle("Add New Expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
            
        } // END: nav
        
    }
}

#Preview {
    AddView(expenses: Expenses())
}

