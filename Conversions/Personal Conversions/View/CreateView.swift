//
//  CreateView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/12/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI
import Combine

struct NewConversion {
    var title: String
    var operation: Int
    var factor: [Float]
    var unitName: String
    var subUnitName: [String]
    var subConversions: [Binding<Conversion.SubConversion>]
}
struct SubUnits: Identifiable, Hashable {
    var id: Int
    @State var subUnitName = ""
    var hashValue: Int {
        return self.id
    }
    static func == (lhs: SubUnits, rhs: SubUnits) -> Bool {
        return lhs.id == rhs.id
    }
}
struct Unit: Identifiable {
    var id = UUID()
    var unitName = ""
//    var subUnit = [SubUnits()]
    var subUnit = [
        SubUnits(id: 1, subUnitName: "Name"),
        SubUnits(id: 2, subUnitName: "Last")
    ]
}

struct CreateView: View {
    @Environment(\.presentationMode) var isPresented // Dismissing the modal
    @ObservedObject var personal: Personal // Uses function to create a conversion
    
    @State private var newConversion = Conversion(title: "", baseUnit: "", subConversions: [Conversion.SubConversion(subUnitName: "", factor: 1.00)])
    
    @State private var testConversion = Conversion.SubConversion(subUnitName: "", factor: 1.00)
    @State private var count = [Int]() //Counts the number of subconversions
    @State private var currentNumber = 1
    
    @State private var unit = Unit()
    
    @State private var subUnitValue = [String]()
    
    @State private var showHelp: Bool = false

    let lowLimit: Float = -1_000
    let highLimit: Float = 1_000
    
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
                    
                    List {
                        ForEach(self.newConversion.subConversions.indices, id: \.self) { index in
                            SubConversionView(subConversion: self.$newConversion.subConversions[index])
                        }
                        .onDelete(perform: deleteRow)
//                        ForEach(self.count, id: \.self) {
////                            TextField("", text: self.$subUnitValue[self.count.capacity])
////                            TextField(Text(""), text: self.$subUnitValue[0])
//                            Text("\($0)")
//                            TextField("", text: self.$subUnitValue[0])
//                        }
//                        .onDelete(perform: deleteRow)
//                        ForEach(self.unit.subUnit, id: \.self) { subUnit in
//                            TextField("Name", text: subUnit.$subUnitName, onCommit: {
//                                let name = subUnit.subUnitName
//                                print(name)
//                            })
//                        }
                        
//                         Button to add new row
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
    
    /// Adds a new items to the conver to value
    private func addRow() {
//        self.unit.subUnit.append(SubUnits(id: 3, subUnitName: "New"))
        self.count.append(self.currentNumber)
        self.currentNumber += 1
        self.subUnitValue.append("")
        self.newConversion.subConversions.append(Conversion.SubConversion(subUnitName: "", factor: 1.00))
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
    
    private func deleteRow(at offsets: IndexSet) {
        
//        conversion.subConversions.remove(atOffsets: offsets)
    }
}

struct SubConversionView: View, Identifiable {
    let id = UUID()
    @Binding var subConversion: Conversion.SubConversion
    
    var body: some View {
        HStack {
            TextField("Value", text: self.$subConversion.subUnitName)
                .disableAutocorrection(true)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Divider()
            
            TextField("", value: self.$subConversion.factor, formatter: NumberFormatter()){
                UIApplication.shared.endEditing() //Should dismiss keyboard on tap gesture
            }
//            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            
//            Stepper(value: self.$subConversion.factor, in: -1_000...1_000) {
//                Text("\(self.subConversion.factor, specifier: "%.2f")")
//            }
//            .labelsHidden()
        }
        .onTapGesture {
            self.endEditing()
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
