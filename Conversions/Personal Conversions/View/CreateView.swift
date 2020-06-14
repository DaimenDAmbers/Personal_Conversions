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
    @State var title: String = ""
    @State var operation: Int = 0
    @State var factor: [Float] = [1.00]
    @State var fromValue: String = ""
    @State var toValue: [String] = [""]
    @State var value: CGFloat = 0
    @State private var subConversion: [Int] = [0]
    @State private var testConversion = [SubConversion]()
    private static var count = 0
    
    @State private var showPopover: Bool = false
    
    var operations: [Operations] = [.multiply, .divide]
    let lowLimit: Float = -1_000
    let highLimit: Float = 1_000
    
    var body: some View {
        NavigationView {
            Form {
                
                // MARK: Conversion Name
                TextField("Conversion name", text: $title)
                    .disableAutocorrection(true)
                
                // MARK: - Conversion Unit
                Section(header: Text("What value are you converting from?")) {
                    TextField("Meters, Kilograms, etc.", text: $fromValue)
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
                            SubConversionView(toValue: self.$toValue[item], factor: self.$factor[item])
                        }
                        .onDelete(perform: deleteConvertTo)
                        
                        // Button to add new row
                        HStack {
                            Spacer()
                            Button("Add Row", action: addItem)
                                .multilineTextAlignment(.center)
                                .buttonStyle(BorderlessButtonStyle())
                            Spacer()
                        }
                    }
                }
                
                // MARK: - Conversion Operator
                // Conversion will always be a multiple of the original input
                Section(header: Text("Operator")) {
                    Picker(selection: $operation, label: Text("Operation")) {
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
        self.factor.append(1.00)
        self.toValue.append("")
        Self.count += 1
        self.subConversion.append(Self.count)
        self.testConversion.append(SubConversion(convertTo: ["String"], operation: .multiply, factor: [1]))
        print(self.toValue)
    }
    
    /// Cancels the form
    private func cancelForm() {
        self.isPresented.wrappedValue.dismiss()
        print("Cancel Form")
    }
    
    
    /// Saves the form
    private func saveForm() {
        let subConversion = SubConversion(convertTo: self.toValue, operation: self.operations[self.operation], factor: self.factor)
        let conversion = Conversion(title: self.title, conversionUnit: self.fromValue, subConversion: subConversion)
        self.personal.create(conversion)
        Self.count = 0
        print(subConversion)
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
    
    func conversionFactor_Example(fromValue: Int, operation: Operations) -> Int {
        var output: Int
        switch operation {
        case .add:
            output = fromValue / fromValue
        case .subtract:
            output = fromValue + fromValue - 1
        case .divide:
            output = fromValue/fromValue
        case .multiply:
            output = fromValue*fromValue
        }
        
        return output
    }
    
    func converstionFactor(input: Int) -> Int {
        var output: Int
        output = input
        return output
    }
    
    
    func raiseKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { key in
            let value = key.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self.value = value.height
            print(value)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { key in
            self.value = 0
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
            Stepper(value: self.$factor, in: -1_000...1_000) {
                Text("\(self.factor, specifier: "%.2f")")
            }
        }
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
