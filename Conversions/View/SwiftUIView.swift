//
//  SwiftUIView.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/26/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    @State var text = ""
    
    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Keyboard(text: $text, keyType: UIKeyboardType.phonePad)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.blue, lineWidth: 4)
        )
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
