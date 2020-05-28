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
    var operations: [Operations] = [.multiply, .divide]
    @State var title: String = ""
    @State var operation: Int = 0
    @State var factor: Float = 0
    @State var fromValue: String = ""
    @State var toValue: String = ""
    @Binding var saveForm: Bool // If true, save method will run in parent function
    @State var value: CGFloat = 0
    
    let lowLimit: Float = -1_000
    let highLimit: Float = 1_000
    
    var body: some View {
        NavigationView {
            Form {
                
                // MARK: Conversion Name
                TextField("Conversion name", text: $title)
                    .disableAutocorrection(true)
                Button("Done") {
                    self.hideKeyboard()
                }
                // MARK: - To & From
                Section(header: Text("What are you converting?")) {
                    HStack {
                        TextField("From", text: $fromValue)
                            .disableAutocorrection(true)
                        TextField("To", text: $toValue)
                            .disableAutocorrection(true)
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
                
                // MARK: - Stepper and Text Field
//                if(!fromValue.isEmpty && !toValue.isEmpty) {
                    Section(header: Text("Using \(operations[operation].rawValue), how many \(fromValue.lowercased()) makes one \(toValue.lowercased())?")) {
                        HStack {
                            
                            TextField("Conversion factor", value: $factor, formatter: NumberFormatter())
                                .multilineTextAlignment(.center)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Stepper(value: $factor, in: lowLimit...highLimit, step: 10.0) {
                                Text("\(factor, specifier: "%.2f")")
                            }
                            .labelsHidden()
                        }
                    }
//                }
                
                // MARK: Save and Cancel buttons
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            //Cancel will need be able to close modal without saving changes.
                            self.isPresented.wrappedValue.dismiss()
                            self.saveForm = false
                            print("Cancel action")
                        }) {
                            Text("Cancel")
                        }.buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                        Button(action: {
                            self.isPresented.wrappedValue.dismiss()
                            self.saveForm = true
                            let conversion = Conversion(title: self.title, fromValue: self.fromValue, toValue: self.toValue, operation: self.operations[self.operation], factor: self.factor)
                            print(self.factor)
                            self.personal.create(conversion)
                            print("Save Action")
                        }) {
                            Text("Save")
                                .font(.headline)
                            }.buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                }
            }
            .keyboardAdaptive()
            .navigationBarTitle(Text("New Conversion"))
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

//extension Publishers {
//    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
//        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
//        .map { $0.keyboardHeight }
//
//        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
//            .map { _ in CGFloat(0) }
//
//        return MergeMany(willShow, willHide)
//        .eraseToAnyPublisher()
//    }
//}
//
//extension Notification {
//    var keyboardHeight: CGFloat {
//        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
//    }
//}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(personal: Personal(), saveForm: .constant(true))
    }
}
