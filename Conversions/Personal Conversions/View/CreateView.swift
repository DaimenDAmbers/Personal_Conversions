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
    
    @State private var title = String()
    @State private var baseUnit = String()
    @State private var subUnitName = String()
    @State private var factor = Float()
    @State private var text = String()
    @State private var color = Color.white
    @State private var acronym = String()
    
    @State private var subConversions: [Conversion.SubConversion]? = nil
    
    @State private var showAddField: Bool = false
    @State private var showHelp: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                
                // MARK: Conversion Name
                Section(header: Text("Name and color of the Conversions")) {
                    HStack {
                        TextField("Conversion name", text: $title)
                            .disableAutocorrection(true)
                        if #available(iOS 14.0, *) {
                            ColorPicker("Pick Color", selection: $color)
                                .labelsHidden()
                        } else {
                            // Fallback on earlier versions
                            Picker("Set the background color", selection: $color) {
                                ForEach(Colors.allCases, id: \.self) { color in
                                    Text(color.localizedName)
                                        .tag(color)
                                }
                            }
                        }
                        
                    }
                    
                }
                
                // MARK: - Conversion Unit
                Section(header: Text("What value are you converting from?")) {
                    HStack {
                        TextField("Meters, Kilograms, etc.", text: $baseUnit)
                            .disableAutocorrection(true)
//                            .frame(width: 245, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Divider()
                        TextField("Acronym", text: $acronym)
                            .disableAutocorrection(true)
                            .multilineTextAlignment(.trailing)
                    }
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
                            if let conversions = subConversions {
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
                            
                            // Button to add new row
                            if showAddField {
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
                                    TextField("Value Name", text: $subUnitName)
                                        .multilineTextAlignment(.center)
                                    Divider()
                                    
                                    DecimalKeypad("0.0", textColor: UIColor.white, fontSize: 17, text: $factor)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                                    Divider()
                                    
                                    HStack {
                                        Button(action: {
                                            self.submit(name: self.subUnitName, factor: self.factor)
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
        self.showAddField = false
    }
    
    /// Cancels the form and dismisses CreateView modal
    private func cancelForm() {
        self.isPresented.wrappedValue.dismiss()
        print("Cancel Form")
    }
    
    
    /// Saves the form and dismisses CreateView modal
    private func saveForm() {
        guard let subConversions = self.subConversions else {
            return
        }
        let conversion = Conversion(title: self.title, baseUnit: self.baseUnit, subConversions: subConversions, color: self.color, acronym: self.acronym)
        self.personal.create(conversion)
        print(conversion.subConversions[0].factor)
        print("Save Form")
        self.isPresented.wrappedValue.dismiss()
    }
    
    private func delete(at offsets: IndexSet) {
        self.subConversions?.remove(atOffsets: offsets)
    }
    
    
    /// Submits the new sub conversion value
    /// - Parameters:
    ///   - name: Name of the sub converions.
    ///   - factor: how many of this item will make one of the value you are converting from.
    private func submit(name: String, factor: Float) {
        guard name != String() else {
            print("Empty sub conversion name")
            return
        }
        
        guard factor != 0 else {
            print("Can't use zero")
            return
        }
        
        if self.subConversions?.isEmpty == nil {
            self.subConversions = [Conversion.SubConversion(subUnitName: self.subUnitName, factor: self.factor)]
        } else {
            self.subConversions?.append(Conversion.SubConversion(subUnitName: self.subUnitName, factor: factor))
        }
        
        self.subUnitName = ""
        self.factor = 1
        self.showAddField = true
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(personal: Personal())
    }
}
