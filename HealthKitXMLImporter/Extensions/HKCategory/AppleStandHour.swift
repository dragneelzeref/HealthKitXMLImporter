//
//  AppleStandHour.swift
//  HealthKitXMLImporter
//
//  Created by Zeref on 10/10/22.
//

import Foundation
import HealthKit

extension HKCategoryValueAppleStandHour{
    static let description = "HKCategoryValueAppleStandHour"
    static let allCases: Set<HKCategoryValueAppleStandHour> = [.stood, .idle]
    public init?(string: String) {
        let name = string.replacingOccurrences(of: Self.description, with: "").lowercased()
        guard let value = Self.allCases.first(where: { $0.typeName == name }) else{
            return nil
        }
        self = value
    }
    
    var typeName: String{
        return name.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    var name: String{
        switch self {
        case .stood:
            return "Stood"
        case .idle:
            return "Idle"
        @unknown default:
            return "unknown"
        }
    }
}
