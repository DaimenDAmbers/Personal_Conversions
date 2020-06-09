//
//  EditConversionView.swift
//  Conversions
//
//  Created by Daimen Ambers on 6/6/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct EditConversionView: View {
    var conversion: Conversion
    var body: some View {
        NavigationView {
            VStack {
                //                padding(.top)
                Text("Edit \(conversion.conversionUnit)")
                //                Spacer()
            }
            .navigationBarTitle("Editing \(conversion.title)")
        }
    }
}

struct EditConversionView_Previews: PreviewProvider {
    static var previews: some View {
        EditConversionView(conversion: Conversion(title: "Distance", conversionUnit: "Meters"))
    }
}
