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
}

struct CreateView: View {
    @Environment(\.presentationMode) var isPresented // Dismissing the modal
    @ObservedObject var personal: Personal // Uses function to create a conversion
    
    @State var newConversion = NewConversion(title: "", operation: 0, factor: [1.00], unitName: "", subUnitName: [""])
    
    @State private var subConversion: [Int] = [0]
    private static var count = 0
    
    @State private var showPopover: Bool = false
    
    var operations: [Operations] = [.multiply, .divide]
    let lowLimit: Float = -1_000
    let highLimit: Float = 1_000
    
    var body: some View {
        NavigationView {
            Form {
                
                // MARK: Conversion Name
                TextField("Conversion name", text: $newConversion.title)
                    .disableAutocorrection(true)
                
                // MARK: - Conversion Unit
                Section(header: Text("What value are you converting from?")) {
                    TextField("Meters, Kilograms, etc.", text: $newConversion.unitName)
                        .disableAutocorrection(true)
                }
                
                // MARK: - Convert to values
                Section(header: Button(action: {
                    // Information
//                    self.showPopover = true
                }) {
                    Text("What value(s) are you converting to?")
                        .foregroundColor(.secondary)
                    Image(systemName: "info.circle")
                }) {
                    
                    List {
                        ForEach(subConversion, id: \.self) { item in
                            SubConversionView(toValue: self.$newConversion.subUnitName[item], factor: self.$newConversion.factor[item])
                        }
                        .onDelete(perform: deleteConvertTo)
                        
                        // Button to add new row
                        Button(action: {
                            self.addItem()
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
                
                // MARK: - Conversion Operator
                // Conversion will always be a multiple of the original input
                Section(header: Text("Operator")) {
                    Picker(selection: $newConversion.operation, label: Text("Operation")) {
                        ForEach(0 ..< operations.count) { index in
                            Text("\(self.operations[index].rawValue)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
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
    private func addItem() {
        self.newConversion.factor.append(1.00)
        self.newConversion.subUnitName.append("")
        Self.count += 1
        self.subConversion.append(Self.count)
    }
    
    /// Cancels the form
    private func cancelForm() {
        self.isPresented.wrappedValue.dismiss()
        print("Cancel Form")
    }
    
    
    /// Saves the form
    private func saveForm() {
        let subConversion = SubConversion(subUnitName: self.newConversion.subUnitName, factor: self.newConversion.factor, operation: self.operations[self.newConversion.operation])
        let conversion = Conversion(title: self.newConversion.title, unitName: self.newConversion.unitName, subConversion: subConversion)
        self.personal.create(conversion)
        Self.count = 0
        print(subConversion)
        print(conversion)
        print("Save Form")
        self.isPresented.wrappedValue.dismiss()
    }
    
    private func deleteConvertTo(at offsets: IndexSet) {
        if(Self.count >= 0) {
            print(offsets)
            Self.count -= 1
            subConversion.remove(atOffsets: offsets)
//            factor.remove(atOffsets: offsets)
//            toValue.remove(atOffsets: offsets)
        } else {
            Self.count = 0
        }
    }
}

struct SubConversionView: View, Identifiable {
    let id = UUID()
    @Binding var toValue: String
    @Binding var factor: Float
    
    var body: some View {
        HStack {
            TextField("Value", text: self.$toValue)
                .disableAutocorrection(true)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Divider()
            
            TextField("", value: self.$factor, formatter: NumberFormatter()){
                UIApplication.shared.endEditing() //Should dismiss keyboard on tap gesture
            }
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            
            Stepper(value: self.$factor, in: -1_000...1_000) {
                Text("\(self.factor, specifier: "%.2f")")
            }
            .labelsHidden()
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
