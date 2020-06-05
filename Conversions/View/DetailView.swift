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
    @State private var fromValue: Float = 0
    @State private var keyboardHeight: CGFloat = 0
    var conversion: Conversion
    
    var body: some View {
        return NavigationView {
            VStack {
                TextField("", value: $fromValue, formatter: NumberFormatter())
                    .multilineTextAlignment(.center)
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
//                    .keyboardType(.decimalPad)
                
                Text(conversion.conversionUnit)
                    .font(.title)
                
                ConvsersionListView(subConversion: conversion.subConversion[0], fromValue: fromValue)
            }
            .keyboardAdaptive()
        }
        .navigationBarTitle(Text("\(conversion.title)"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                print("Edit button")
            }) {
                Image(systemName: "ellipsis.circle")
        })
    }
}



struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(conversion: Conversion(title: "Distance", conversionUnit: "Feet"))
    }
}
