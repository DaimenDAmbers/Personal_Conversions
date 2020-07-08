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

// MARK: Protocols
protocol Conv_Protocol {
    var conversion: [Conversion] { get set }
    func create(_ conversion: Conversion)
}

// MARK: Structs
/// Ouline of a Conversion
struct Conversion: Identifiable {
    
    /// Create multiple conversions in one
    /// - Parameters:
    ///     - subUnitName:
    ///     - factor:
    ///     - operation:
    struct SubConversion: Identifiable, Hashable {
        var id = UUID()
        var subUnitName: String
        var factor: Float
        var operation: Operations
    }
    
    var id = UUID()
    var title: String
    var unitName: String
    var subConversions: [SubConversion]
    init(title: String, unitName: String, subConversions: [SubConversion]) {
        self.title = title
        self.unitName = unitName
        self.subConversions = subConversions
    }

    mutating func saveEdits(title: String, unitName: String) throws {
        let emptyString = String()
        guard title != emptyString else {
            throw ConversionError.emptyTitle
        }
        
        guard unitName != emptyString else {
            throw ConversionError.emptyUnitName
        }
        
//        guard valueName != emptyString else {
//            throw ConversionError.emptyValueName
//        }
//        
//        guard factor != emptyString else {
//            throw ConversionError.zerofactor
//        }
        
        self.title = title
        self.unitName = unitName
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
