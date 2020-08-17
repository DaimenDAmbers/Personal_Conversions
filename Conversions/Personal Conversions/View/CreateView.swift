//
//  CreateView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/12/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI
import Combine

struct CreateView: View {
    @Environment(\.presentationMode) var isPresented // Dismissing the modal
    @ObservedObject var personal: Personal // Uses function to create a conversion
    
    @State private var newConversion = Conversion(title: "", baseUnit: "", subConversions: [Conversion.SubConversion(subUnitName: "Placeholder", factor: 2.00)])
    
    @State private var newSubConversionName: String = ""
    @State private var newSubConversionFactor: Float = 1.00
    @State private var showAddField: Bool = false
    
    @State private var showHelp: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                
                // MARK: Conversion Name
                Section {
                    TextField("Conversion name", text: $newConversion.title)
                        .disableAutocorrection(true)
                }
                
                // MARK: - Conversion Unit
                Section(header: Text("What value are you converting from?")) {
                    TextField("Meters, Kilograms, etc.", text: $newConversion.baseUnit)
                        .disableAutocorrection(true)
                }
                
                // MARK: - Convert to values
                Section(header: Button(action: {
                    // Information
                    self.showHelp = true
                }) {
                    Text("What value(s) are you converting to?")
                        .foregroundColor(.secondary)
                    Image(systemName: "info.circle")
                }
                .alert(isPresented: $showHelp) {
                    Alert(title: Text("Example"), message: Text("If you are converting from inches to feet, the converting value here will be 12."))
                    }
                ) {
                    
                    // MARK: List of Sub Conversions
                    Group {
                        
                        List {
                            ForEach(self.newConversion.subConversions) { subConversion in
                                ShowSubConversion(subConversion: subConversion)
                            }
                            .onDelete(perform: delete)
                            
                            // Button to add new row
                            if !showAddField {
                                Button(action: {
                                    self.addRow()
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("Add Row")
                                        Spacer()
                                    }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            } else {
                                HStack(alignment: .center) {
                                    TextField("Value Name", text: $newSubConversionName)
                                        .multilineTextAlignment(.center)
                                    Divider()
                                    TextField("Factor", value: $newSubConversionFactor, formatter: NumberFormatter())
                                        .multilineTextAlignment(.center)
                                    Divider()
                                    HStack {
                                        Button(action: {
                                            self.submit(name: self.newSubConversionName, factor: self.newSubConversionFactor)
                                        }) {
                                            Text("Submit")
                                        }
                                        .multilineTextAlignment(.center)
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .keyboardAdaptive()
            .navigationBarTitle(Text("New Conversion"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") { self.cancelForm() },
                trailing: Button("Save") { self.saveForm() }
            )
        }
    }
    // MARK: - Functions
    /// Adds a new items to the conver to value
    private func addRow() {
        self.showAddField = true
    }
    
    /// Cancels the form and dismisses CreateView modal
    private func cancelForm() {
        self.isPresented.wrappedValue.dismiss()
        print("Cancel Form")
    }
    
    
    /// Saves the form and dismisses CreateView modal
    private func saveForm() {
        let conversion = Conversion(title: self.newConversion.title, baseUnit: self.newConversion.baseUnit, subConversions: self.newConversion.subConversions)
        self.personal.create(conversion)
        print(conversion.subConversions[0].factor)
        print("Save Form")
        self.isPresented.wrappedValue.dismiss()
    }
    
    private func delete(at offsets: IndexSet) {
        self.newConversion.subConversions.remove(atOffsets: offsets)
    }
    
    private func submit(name: String, factor: Float) {
        guard name != String() else {
            print("Empty sub conversion name")
            return
        }
        
        guard factor != 0 else {
            print("Can't use zero")
            return
        }
        
        self.newConversion.subConversions.append(Conversion.SubConversion(subUnitName: self.newSubConversionName, factor: Float(self.newSubConversionFactor)))
        self.newSubConversionName = ""
        self.newSubConversionFactor = 1.00
        self.showAddField = false
        
    }
}

// MARK: - Extension to allows Optional Bindings.
extension Optional where Wrapped == String {
    
    var bound: String {
        get {
            return self ?? ""
        }
        set {
            self = newValue
        }
    }
}

struct ShowSubConversion: View {
    var subConversion: Conversion.SubConversion
    
    var body: some View {
        HStack {
            Spacer()
            Text("\(subConversion.subUnitName)")
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            //            Spacer()
            //            Divider()
            Spacer()
            Text(String(format: "%.2f", subConversion.factor))
                .multilineTextAlignment(.center)
            Spacer()
            
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(personal: Personal())
    }
}
