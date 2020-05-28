//
//  DetailView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/13/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI
import Combine


/// Showes the detail of the selected personal conversion
struct DetailView: View {
    
    // MARK: Variables
    var operations: [Operations] = [.add, .subtract, .divide, .multiply]
    @State private var fromValue: Float = 0
    @State private var toValue: Float = 0
    @State private var keyboardHeight: CGFloat = 0
    var conversion: Conversion
//    init() {
//        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
//    }
    
    var body: some View {
        let fmValue = Binding<Float>(get: {
            self.fromValue
        }, set: {
            self.fromValue = $0
            self.toValue = self.result(input: self.fromValue, factor: self.conversion.factor, operation: self.conversion.operation)
        })
        let tmValue = Binding<Float>(get: {
            self.toValue
        }, set: {
            self.toValue = $0
        })
        return NavigationView {
            
            Form {
                HStack {
                    //Picker
                    Section(header: Text("\(conversion.fromValue):")) {
                        TextField("From", value: fmValue, formatter: NumberFormatter())
                            .multilineTextAlignment(.center)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }

                    Section(header: Text("\(conversion.toValue):")) {
                        TextField("To Value", value: tmValue, formatter: NumberFormatter())
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                Button("Done") {
                    self.hideKeyboard()
                }
            }
            .keyboardAdaptive()
        }
        .navigationBarTitle(Text("\(conversion.title)"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
            print("Edit button")
            }) {
                Image(systemName: "ellipsis.circle")
            })
    }
    
    // MARK: Functions
    
    /**
     Takes the input and makes a decision on how to use the factor based on the operator.
     - Parameters:
        - input : Takes the users' inputs
        - factor: Is how much the input is multiplied or divided by
        - operation: Determines weather to multiply or divide depending on weather using the to or from conversion
     - Returns: Computed conversion
     */
    func result(input: Float?, factor: Float, operation: Operations) -> Float {
        let output: Float
        guard input != nil else {
            return 0
        }
        switch operation {
        case .add:
            output = input! + factor
        case .subtract:
            output = input! - factor
        case .multiply:
            output = input! * factor
            print(input as Any)
            print(factor)
        case .divide:
            //Change int to float
            output = input! / factor
        }
        
        return output
    }
}



struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(conversion: Conversion(title: "Distance", fromValue: "kg", toValue: "g", operation: .divide, factor: 1000))
    }
}
