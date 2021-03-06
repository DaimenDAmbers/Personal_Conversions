//
//  DetailView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/13/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI
import Combine


/// Showes the detail of the selected personal conversion
struct DetailView: View {
    
    // MARK: Variables
    @State private var userInput: Float = 0
    @State private var showingActionSheet = false
    @State private var showingEditModal = false
    @State var conversion: Conversion
    
    var body: some View {
        VStack {
            VStack {
                DecimalKeypad("0.0", fontSize: 50, text: $userInput)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                
                Text(conversion.baseUnit)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(conversion.color)
                
                ConvsersionListView(subConversions: conversion.subConversions, userInput: userInput)
            }
            
        }
        .sheet(isPresented: $showingEditModal) {
            EditConversionView(conversion: self.$conversion)
        }
        
        
        .navigationBarTitle(Text("\(conversion.title)"), displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.showingActionSheet = true
                                    print("Edit button")
                                }) {
                                    Image(systemName: "ellipsis.circle")
                                        .font(.system(size: 20))
                                }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("What would you like to do?"),
                            buttons: [
                                .default(Text("Edit Conversion")) {
                                    self.showingActionSheet = false
                                    self.showingEditModal = true
                                },
                                .destructive(Text("Delete")),
                                .cancel()
                            ])
            }
        )
    }
}

struct ConvsersionListView: View {
    var subConversions: [Conversion.SubConversion]
    var userInput: Float
    
    var body: some View {
        List {
            ForEach(subConversions) { item in
                HStack {
                    Text("\(item.subUnitName)")
                    Spacer()
                    Text(String(self.result(input: self.userInput, factor: item.factor, operation: .multiply)))
                }
            }
                 
        }
        .padding()
//        .background(Color.blue)
        .listStyle(DefaultListStyle())
        
        
    }
    
    /**
     Takes the input and makes a decision on how to use the factor based on the operator.
     - Parameters:
        - input : Takes the users' inputs
        - factor: Is how much the input is multiplied or divided by
        - operation: Determines weather to multiply or divide depending on weather using the to or from conversion
     - Returns: Computed conversion
     */
    func result(input: Float?, factor: Float, operation: Operations) -> Float {
        let output: Float
        guard let input = input else {
            return 0
        }
        switch operation {
        case .add:
            output = input + factor
        case .subtract:
            output = input - factor
        case .multiply:
            output = input * factor
        case .divide:
            output = input / factor
        }
        print("input: \(input as Any), operation: \(operation), output: \(output)")
        return output
    }
}



struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(conversion: Conversion(title: "Distance", baseUnit: "Feet", subConversions: [Conversion.SubConversion(subUnitName: "Test", factor:   2.00)], color: Color.red, acronym: "kg", acronymTextColor: Color.white))
    }
}
