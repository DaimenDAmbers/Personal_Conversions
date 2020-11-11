//
//  Keyboard.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/26/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import Foundation
import SwiftUI

/// Adds a done button on the keyboard
struct DecimalKeypad: UIViewRepresentable {
    @Binding var factor: Float
    private var placeHolder: String
    
    init(_ placeHolder: String, text: Binding<Float>) {
        self.placeHolder = placeHolder
        self._factor = text
    }
    
//    var keyType: UIKeyboardType
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.keyboardType = .decimalPad
        textfield.textAlignment = .center
        textfield.delegate = context.coordinator
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.floatValue = factor
        print(factor)
    }
    
    func makeCoordinator() -> DecimalKeypad.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DecimalKeypad
        
        init(_ textField: DecimalKeypad) {
            self.parent = textField
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.factor = textField.floatValue
            print(parent.factor)
        }
    }
}

extension  UITextField {
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }
    
    var floatValue: Float {
        set { }
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            let nsNumber = numberFormatter.number(from: text!)
            return nsNumber == nil ? 0.0 : nsNumber!.floatValue
        }
    }

}

struct Example: UIViewRepresentable {
    @Binding var text: String
    var type: UIKeyboardType
    
    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.keyboardType = type
        return field
    
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}


