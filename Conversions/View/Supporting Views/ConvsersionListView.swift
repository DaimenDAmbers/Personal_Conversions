//
//  ConvsersionListView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/29/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct ConvsersionListView: View {
    var conversion: Conversion
    var fromValue: Float
    
    var body: some View {
        List {
            ForEach(0 ..< conversion.subConversion[0].convertTo.count) { item in
                HStack {
                    Text("\(self.conversion.subConversion[0].convertTo[item])")
                    Spacer()
                    Text(String(self.result(input: self.fromValue, factor: self.conversion.subConversion[0].factor[item], operation: self.conversion.subConversion[0].operation)))
                }
            }   
        }
    }
    
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
            output = input! / factor
        }
        
        return output
    }
}

struct ConvsersionListView_Previews: PreviewProvider {
    var subConversion = SubConversion(convertFrom: "Money", convertTo: ["Change"], operation: .multiply, factor: [10])
    static var previews: some View {
        ConvsersionListView(conversion: Conversion(title: "Distance"), fromValue: 10)
    }
}
