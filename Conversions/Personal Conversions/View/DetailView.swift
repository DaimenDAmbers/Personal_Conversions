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
    @State private var showingActionSheet = false
    @State private var showingEditModal = false
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
                
                ConvsersionListView(subConversion: conversion.subConversion, fromValue: fromValue)
            }
        }
        .keyboardAdaptive()
        .sheet(isPresented: $showingEditModal) {
            EditConversionView(conversion: self.conversion)
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



struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(conversion: Conversion(title: "Distance", conversionUnit: "Feet", subConversion: SubConversion(convertTo: ["Test"], operation: .multiply, factor: [2])))
    }
}
