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
    @State private var isEditing: EditMode = .active
    @Environment(\.presentationMode) var showingEditOptions
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Conversion Name")) {
                    HStack {
                        TextField("\(conversion.title)", text: $conversion.title)
                        if #available(iOS 14.0, *) {
                            ColorPicker("Pick Color", selection: $conversion.color)
                                .labelsHidden()
                        } else {
                            // Fallback on earlier versions
                            Picker("background color", selection: $conversion.color) {
                                ForEach(Colors.allCases, id: \.self) { color in
                                    Text(color.localizedName)
                                        .tag(color)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Conversion Unit Name")) {
                    HStack {
                        TextField("\(conversion.baseUnit)", text: $conversion.baseUnit)
                        Divider()
                        TextField("Acronym", text: $conversion.acronym)
                            .disableAutocorrection(true)
                            .multilineTextAlignment(.center)
                        
                        if #available(iOS 14.0, *) {
                            ColorPicker("Pick Color", selection: $conversion.acronymTextColor)
                                .labelsHidden()
                        } else {
                            // Fallback on earlier versions
                            Picker("Color", selection: $conversion.acronymTextColor) {
                                ForEach(Colors.allCases, id: \.self) { color in
                                    Text(color.localizedName)
                                        .tag(color)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Conversions")) {
                    List {
                        ForEach(conversion.subConversions.indices, id: \.self) { idx in
                            HStack {
//                                Button(action: {
//                                    // Minus button
//                                    self.isEditing = .active
//                                    print("delete")
//                                }) {
//                                    Image(systemName: "minus.circle.fill")
//                                        .foregroundColor(.red)
//                                }
                                TextField("\(self.conversion.subConversions[idx].subUnitName)", text: self.$conversion.subConversions[idx].subUnitName)
                                DecimalKeypad("\(self.conversion.subConversions[idx].factor)", fontSize: 17, text: self.$conversion.subConversions[idx].factor)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
//                                Text(subConversion.subUnitName)
//                                    .multilineTextAlignment(.center)
//                                Spacer()
//                                Divider()
//                                Spacer()
//                                Text(String(format: "%.2f", subConversion.factor))
//                                    .multilineTextAlignment(.center)
                            }
                        }
                        .onDelete(perform: deleteRow)
                    }
                    
                    HStack {
                        Button(action: {
                            self.addRow()
                        }) {
                            HStack {
                                Spacer()
//                                Image(systemName: "plus.circle.fill")
//                                    .foregroundColor(.green)
                                Text("Add row")
                                Spacer()
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
            .environment(\.editMode, $isEditing)
        }
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
    static var conversion = Conversion(title: "Conversion", baseUnit: "BaseUnit", subConversions: [Conversion.SubConversion(subUnitName: "Test", factor: 1), Conversion.SubConversion(subUnitName: "Test2", factor: 2)], color: .black, acronym: "B", acronymTextColor: .white)
    
    static var previews: some View {
        EditConversionView(conversion: .constant(conversion))
    }
}

