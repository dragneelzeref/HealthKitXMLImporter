//
//  AppleWalkingSteadinessEvent.swift
//  HealthKitXMLImporter
//
//  Created by Zeref on 10/10/22.
//

import Foundation
import HealthKit

extension HKCategoryValueAppleWalkingSteadinessEvent{
    static let description = "HKCategoryValueAppleWalkingSteadinessEvent"
    static let allCases: Set<HKCategoryValueAppleWalkingSteadinessEvent> = [.initialLow, .initialVeryLow, .repeatLow, .repeatVeryLow]
    public init?(string: String) {
        let name = string.replacingOccurrences(of: Self.description, with: "").lowercased()
        guard let value = HKCategoryValueAppleWalkingSteadinessEvent.allCases.first(where: { $0.typeName == name }) else{
            return nil
        }
        self = value
    }
    
    var typeName: String{
        return name.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    var name: String{
        switch self {
        case .initialLow:
            return "Initial Low"
        case .initialVeryLow:
            return "Initial Very Low"
        case .repeatLow:
            return "Repeat Low"
        case .repeatVeryLow:
            return "Repeat Very Low"
        @unknown default:
            return "unknown"
        }
    }
}
