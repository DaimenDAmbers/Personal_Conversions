//
//  PersonalConversions.swift
//  Conversions
//
//  Created by Daimen Ambers on 5/12/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import Foundation
import SwiftUI


// MARK: Errors
enum ConversionError: Error {
    case emptyTitle
    case emptyUnitName
    case emptyValueName
    case zerofactor
}

// MARK: Enummerations
enum Operations: String, CaseIterable, Equatable {
    case add = "addition"
    case subtract = "subtraction"
    case divide = "division"
    case multiply = "multiplication"
}

enum Colors: String, CaseIterable, Equatable {
    case red = "red"
    case blue = "blue"
    case green = "green"
    case purple = "purple"
    case orange = "orange"
    case yellow = "yellow"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

// MARK: Protocols
protocol Conv_Protocol {
    var conversion: [Conversion] { get set }
    func create(_ conversion: Conversion)
}

// MARK: Structs
/// Ouline of a Conversion
class Conversion: Identifiable {
    
    /// Create multiple conversions that is converted from the unit.
    struct SubConversion: Identifiable {
        var id = UUID()
        var subUnitName: String
        var factor: Float
        var result: Float? = nil
        
        mutating func calcResult(input: Float) {
            let output = input * factor
            self.result = output
        }
    }
    
    var id = UUID() // Used for sorting identifying each personal conversion
    var title: String   // Name of the conversion
    var baseUnit: String // Name of the unit we are converting from
    var baseUnitValue: Float = 1.00 // Base unit that will be used universally for the subconversions
    var subConversions: [SubConversion]
    var color: Color   // Color of the background of the Conversion
    var acronym: String // Acronym of the unit conversion
    var acronymTextColor: Color
    
    init(title: String, baseUnit: String, subConversions: [SubConversion], color: Color, acronym: String, acronymTextColor: Color) {
        self.title = title
        self.baseUnit = baseUnit
        self.subConversions = subConversions
        self.color = color
        self.acronym = acronym
        self.acronymTextColor = acronymTextColor
    }
    
    func unitConverter(input: Float?, subConversion: SubConversion) -> Float {
        let factor: Float = subConversion.factor
        guard let input = input else {
            return 0
        }
        let output: Float

        // multiply
        output = factor * baseUnitValue * input
        // divide
//        output = baseUnitValue / input
        return output
    }

    func saveEdits(title: String, baseUnit: String) throws {
        let emptyString = String()
//        let zeroFactor: Float = 0
        guard title != emptyString else {
            throw ConversionError.emptyTitle
        }
        
        guard baseUnit != emptyString else {
            throw ConversionError.emptyUnitName
        }
        
//        guard subConversion.subUnitName != emptyString else {
//            throw ConversionError.emptyValueName
//        }
//
//        guard subConversion.factor != zeroFactor else {
//            throw ConversionError.zerofactor
//        }
       
        
        self.title = title
        self.baseUnit = baseUnit
    }
    
    func getAcronymColor(color: UIColor) {
        if (!color.isLight) {
            acronymTextColor = Color.white
        } else {
            acronymTextColor = Color.black
        }
    }
}

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}

// MARK: Classes
///Used for creating personal conversions
class Personal: Conv_Protocol, ObservableObject, Identifiable {
    var id = UUID()
    @Published var conversion = [Conversion]() // Used to make the list of conversion on the in the Personal View
    
    func create(_ conversion: Conversion) {
        print(conversion.title)
        self.conversion.append(conversion)
    }
    
}
