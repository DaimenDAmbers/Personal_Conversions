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
    @State private var newEntry = String()
    @State private var newFactor = Float()
    @State private var showAddField: Bool = true
    @State private var extraSubConversions: [Conversion.SubConversion]? = nil
    
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
                                TextField("\(self.conversion.subConversions[idx].subUnitName)", text: self.$conversion.subConversions[idx].subUnitName)
                                DecimalKeypad("\(self.conversion.subConversions[idx].factor)", fontSize: 17, text: self.$conversion.subConversions[idx].factor)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                            }
                        }
                        .onDelete(perform: deleteRow)
                        if let conversions = extraSubConversions {
                            ForEach(conversions, id: \.id) { subConversion in
                                HStack {
                                    Text(subConversion.subUnitName)
                                    Spacer()
                                    Text(String(format: "%.2f", subConversion.factor))
                                }
                            }
                            .onDelete(perform: delete)
                            
                        } else {
                            EmptyView()
                        }
                        if showAddField {
                            HStack {
                                Button(action: {
                                    self.addRow()
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("Add row")
                                        Spacer()
                                    }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            
                        } else {
                            HStack {
                                Spacer()
                                TextField("Value", text: self.$newEntry)
                                Spacer()
                                DecimalKeypad("0.0", fontSize: 17, text: self.$newFactor)
                                Spacer()
                            }
                            Button(action: {
                                do {
                                    try submitRow(subUnitName: self.newEntry, factor: self.newFactor)
                                } catch ConversionError.emptyValueName {
                                    print("ERROR: Empty Conversion Value Name")
                                } catch ConversionError.zerofactor {
                                    print("ERROR: Cannot have a factor of zero")
                                } catch {
                                    print("Unexpected error: \(error)")
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Submit")
                                    Spacer()
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
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

    private func delete(at offsets: IndexSet) {
        self.extraSubConversions?.remove(atOffsets: offsets)
    }
    
    private func addRow() {
        self.showAddField = false
    }
    
    // Left off trying to error handle properly //
    
    private func submitRow(subUnitName: String, factor: Float) throws {
//        self.conversion.subConversions.append(Conversion.SubConversion(subUnitName: "", factor: 1.00))
        guard subUnitName != String() else {
            throw ConversionError.emptyValueName
        }
        
        guard factor != 0 else {
            throw ConversionError.zerofactor
        }
        
        if self.extraSubConversions?.isEmpty == nil {
            self.extraSubConversions = [Conversion.SubConversion(subUnitName: subUnitName, factor: factor)]
        } else {
            self.extraSubConversions?.append(Conversion.SubConversion(subUnitName: subUnitName, factor: factor))
        }
        self.newEntry = String()
        self.newFactor = Float()
        self.showAddField = true
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
//    private func handleErrors(title: String, unitName: String) throws {
//        let emptyString = String()
//        guard conversion.title != emptyString else {
//            throw ConversionError.emptyTitle
//        }
//
//        guard conversion.baseUnit != emptyString else {
//            throw ConversionError.emptyUnitName
//        }
//    }
    
    /// Adds a new items to the conver to value
    private func saveEdits() {
        do {
            print(self.conversion.title)
            try conversion.saveEdits(title: self.conversion.title, baseUnit: self.conversion.baseUnit)
            if let extraConversions = extraSubConversions {
                conversion.subConversions.append(contentsOf: extraConversions)
            }
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

