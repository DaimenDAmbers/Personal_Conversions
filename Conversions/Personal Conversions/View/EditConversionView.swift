//
//  EditConversionView.swift
//  Conversions
//
//  Created by Daimen Ambers on 6/7/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

enum ConversionError: Error {
    case emptyTitle
    case emptyConversionUnit
}

struct EditConversionView: View {
    @State var conversion: Conversion
    @Environment(\.presentationMode) var showingEditOptions
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Conversion Name")) {
                    TextField("\(conversion.title)", text: $conversion.title)
                }
                
                Section(header: Text("Conversion Unit Name")) {
                    TextField("\(conversion.conversionUnit)", text: $conversion.conversionUnit)
                }
            }
            .navigationBarTitle("Edit Conversion", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") { self.cancelEdits() },
                trailing: Button("Save") { self.saveEdits() }
            )
        }
    }
    
    /// Error handler for the submitting the changes to the conversion.
    /// - Parameters:
    ///   - title: Changes the name of the conversion
    ///   - conversionUnit: Changes the name of the conversion unit
    /// - Throws: Will throw an error if there are empty strings in either the conversion name or unit.
    private func handleErrors(title: String, conversionUnit: String) throws {
        let emptyString = String()
        guard conversion.title != emptyString else {
            throw ConversionError.emptyTitle
        }
        
        guard conversion.conversionUnit != emptyString else {
            throw ConversionError.emptyConversionUnit
        }
    }
    
    /// Adds a new items to the conver to value
    private func saveEdits() {
        do {
            try handleErrors(title: conversion.title, conversionUnit: conversion.conversionUnit)
            self.showingEditOptions.wrappedValue.dismiss()
            print("Save Edits")
        } catch ConversionError.emptyTitle {
            print("ERROR: Empty Conversion Name")
        } catch ConversionError.emptyConversionUnit {
            print("ERROR: Empty Conversion Unit")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    /// Cancels the form
    private func cancelEdits() {
        self.showingEditOptions.wrappedValue.dismiss()
        print("Cancel Edits")
    }
}

struct EditConversionView_Previews: PreviewProvider {
    static var previews: some View {
        EditConversionView(conversion: Conversion(title: "Distance", conversionUnit: "Miles", subConversion: SubConversion(convertTo: ["Test"], operation: .multiply, factor: [2])))
    }
}
