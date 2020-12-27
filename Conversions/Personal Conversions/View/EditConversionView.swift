//
//  EditConversionView.swift
//  Conversions
//
//  Created by Daimen Ambers on 6/7/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct EditConversionView: View {
    @Binding var conversion: Conversion
    @State private var isEditing: EditMode = .inactive
    @Environment(\.presentationMode) var showingEditOptions
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Conversion Name")) {
                    TextField("\(conversion.title)", text: $conversion.title)
                }
                
                Section(header: Text("Conversion Unit Name")) {
                    TextField("\(conversion.baseUnit)", text: $conversion.baseUnit)
                }
                
                Section(header: Text("Conversions")) {
                    List {
                        ForEach(conversion.subConversions.indices, id: \.self) { idx in
                            HStack {
                                Button(action: {
                                    // Minus button
                                    self.isEditing = .active
                                    print("delete")
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                TextField("\(self.conversion.subConversions[idx].subUnitName)", text: self.$conversion.subConversions[idx].subUnitName)
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
        self.conversion.subConversions.append(Conversion.SubConversion(subUnitName: "", factor: 1.00))
    }
    
    //Need to fix deleting rows in edit
    // Will need to rethink how subconversion works
    private func deleteRow(at offsets: IndexSet) {
        self.conversion.subConversions.remove(atOffsets: offsets)
    }
    
    
    /// Error handler for the submitting the changes to the conversion.
    /// - Parameters:
    ///   - title: Changes the name of the conversion
    ///   - subUnitName: Changes the name of the conversion unit
    /// - Throws: Will throw an error if there are empty strings in either the conversion name or unit.
    private func handleErrors(title: String, unitName: String) throws {
        let emptyString = String()
        guard conversion.title != emptyString else {
            throw ConversionError.emptyTitle
        }
        
        guard conversion.baseUnit != emptyString else {
            throw ConversionError.emptyUnitName
        }
    }
    
    /// Adds a new items to the conver to value
    private func saveEdits() {
        do {
            print(self.conversion.title)
            try conversion.saveEdits(title: self.conversion.title, baseUnit: self.conversion.baseUnit)
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
        EditConversionView(conversion: .constant(Conversion(title: "Test", baseUnit: "Meters", subConversions: [Conversion.SubConversion(subUnitName: "Test", factor: 2.00)], color: Color.red, acronym: "kg", acronymTextColor: Color.white)))
    }
}

