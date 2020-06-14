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
}

// MARK: Protocol
protocol Conv_Protocol {
    var conversion: [Conversion] { get set }
    func create(_ conversion: Conversion)
}

// MARK: Struct
/// Create multiple conversions in one
struct SubConversion: Identifiable, Hashable {
    var id = UUID()
    var unitName: [String]
    var factor: [Float]
    var operation: Operations
}

// MARK: Classes
/// Ouline of a Conversion
class Conversion: Identifiable {
    var id = UUID()
    var title: String
    var unitName: String
    var subConversion: SubConversion
    init(title: String, unitName: String, subConversion: SubConversion) {
        self.title = title
        self.unitName = unitName
        self.subConversion = subConversion
    }

    func saveEdits(title: String, unitName: String) throws {
        let emptyString = String()
        guard title != emptyString else {
            throw ConversionError.emptyTitle
        }
        
        guard unitName != emptyString else {
            throw ConversionError.emptyUnitName
        }
        
        self.title = title
        self.unitName = unitName
    }
}

enum Operations: String, CaseIterable, Equatable {
    case add = "addition"
    case subtract = "subtraction"
    case divide = "division"
    case multiply = "multiplication"
}

///Used for creating personal conversions
class Personal: Conv_Protocol, ObservableObject, Identifiable {
    var id = UUID()
    @Published var conversion = [Conversion]() // Used to make the list of conversion on the in the Personal View
    
    func create(_ conversion: Conversion) {
        print(conversion.title)
        self.conversion.append(conversion)
    }
    
}
