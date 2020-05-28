//
//  PersonalConversions.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/12/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import Foundation
import SwiftUI

protocol Conv_Protocol {
    var conversion: [Conversion] { get set }
    func create(_ conversion: Conversion)
}

/// Ouline of a Conversion
struct Conversion: Identifiable {
    var id = UUID()
    var title: String
    var fromValue: String
    var toValue: String
    var operation: Operations
    var factor: Float
    
    init(title: String, fromValue: String, toValue: String, operation: Operations, factor: Float) {
        self.title = title
        self.fromValue = fromValue
        self.toValue = toValue
        self.operation = operation
        self.factor = factor
    }
}

enum Operations: String, CaseIterable {
    case add = "addition"
    case subtract = "subtraction"
    case divide = "division"
    case multiply = "multiplication"
}

///Used for creating personal conversions
class Personal: Conv_Protocol, ObservableObject, Identifiable {
    var id = UUID()
    @Published var conversion = [Conversion]()
    
    func create(_ conversion: Conversion) {
        print(conversion.title)
        self.conversion.append(conversion)
    }
    
    func conversionFactor(input: Int, operation: Operations) -> Int {
        var output: Int
        switch operation {
        case .add:
            output = input
        case .subtract:
            output = input + input - 1
        case .divide:
            output = input/input
        case .multiply:
            output = input*input
        }
        
        return output
    }
 
}
