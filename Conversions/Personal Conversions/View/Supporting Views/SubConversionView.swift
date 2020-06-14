//
//  SubConversionView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/31/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct SubConversionView: View, Identifiable, Hashable {
    static func == (lhs: SubConversionView, rhs: SubConversionView) -> Bool {
        return lhs.factor == rhs.factor && lhs.toValue == rhs.toValue
    }
    
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SubConversionView_Previews: PreviewProvider {
    static var previews: some View {
        SubConversionView(toValue: .constant("Value"), factor: .constant(1.00))
    }
}
