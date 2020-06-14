//
//  EditConversionView.swift
//  Conversions
//
//  Created by Daimen Ambers on 6/7/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct EditConversionView: View {
    @State var conversion: Conversion
    @State private var isEditing: EditMode = .inactive
    @Environment(\.presentationMode) var showingEditOptions
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Conversion Name")) {
                    TextField("\(conversion.title)", text: $conversion.title)
                }
                
                Section(header: Text("Conversion Unit Name")) {
                    TextField("\(conversion.unitName)", text: $conversion.unitName)
                }
                
                Section(header: Text("Conversions")) {
                    List {
                        ForEach(0 ..< conversion.subConversion.unitName.count) { item in
                            HStack {
                                Button(action: {
                                    // Minus button
                                    self.isEditing = .active
                                    print("delete")
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                TextField("\(self.conversion.subConversion.unitName[item])", text: self.$conversion.subConversion.unitName[item])
                            }
                        }
                    .onDelete(perform: deleteRow)
                    }
                    HStack {
                        Button(action: {
                            self.addRow()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                Text("add row")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Conversion", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") { self.cancelEdits() },
                trailing: Button("Save") { self.saveEdits() }
            )
        }
        .keyboardAdaptive()
    }

    
    private func addRow() {
        conversion.subConversion.unitName.append("Value")
    }
    
    //Need to fix deleting rows in edit
    // Will need to rethink how subconversion works
    private func deleteRow(at offsets: IndexSet) {
        conversion.subConversion.unitName.remove(atOffsets: offsets)
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
        
        guard conversion.unitName != emptyString else {
            throw ConversionError.emptyUnitName
        }
    }
    
    /// Adds a new items to the conver to value
    private func saveEdits() {
        do {
            try conversion.saveEdits(title: self.conversion.title, unitName: self.conversion.unitName)
            self.showingEditOptions.wrappedValue.dismiss()
            print("Save Edits")
        } catch ConversionError.emptyTitle {
            print("ERROR: Empty Conversion Name")
        } catch ConversionError.emptyUnitName {
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
        EditConversionView(conversion: Conversion(title: "Test", unitName: "Meters", subConversion: SubConversion(unitName: ["Miles"], factor: [2], operation: .multiply)))
    }
}
