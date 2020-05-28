//
//  UniversalView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/12/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct UniversalView: View {
    @EnvironmentObject var personal: Personal
    var body: some View {
        NavigationView {
            List {
                Text("Hello, Universe!")
            }
            .navigationBarTitle("Universal")
        }
        
    }
}

struct UniversalView_Previews: PreviewProvider {
    static var previews: some View {
        UniversalView()
    }
}
