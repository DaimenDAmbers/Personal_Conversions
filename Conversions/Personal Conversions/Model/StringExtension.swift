//
//  StringExtension.swift
//  Conversions
//
//  Created by Daimen Ambers on 12/2/20.
//  Copyright © 2020 Daimen Ambers. All rights reserved.
//

import Foundation

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex , offsetBy: i)])
    }
}
