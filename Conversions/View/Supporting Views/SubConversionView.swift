//
//  SubConversionView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/31/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

/// Create multiple conversions in one
struct SubConversion: Identifiable {
    var id = UUID()
    var convertTo: [String]
    var operation: Operations
    var factor: [Float]

}

struct SubConversionView: View, Identifiable {
    var id = UUID()
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

struct SubConversionView_Previews: PreviewProvider {
    static var previews: some View {
        SubConversionView(toValue: .constant("Value"), factor: .constant(1.00))
    }
}
