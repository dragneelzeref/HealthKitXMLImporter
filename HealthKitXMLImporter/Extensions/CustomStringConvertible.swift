//
//  CustomStringConvertible.swift
//  HealthKitXMLImporter
//
//  Created by Zeref on 10/10/22.
//

import Foundation

extension CustomStringConvertible {
    var description: String {
        var description: String = "\(type(of: self))\n"
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value)\n"
            }
        }
        return description
    }
}
