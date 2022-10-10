//
//  SleepAnalysis.swift
//  HealthKitXMLImporter
//
//  Created by Zeref on 10/10/22.
//

import Foundation
import HealthKit

extension HKCategoryValueSleepAnalysis{
    static let description = "HKCategoryValueSleepAnalysis"
    static let allCases: [HKCategoryValueSleepAnalysis] = [.inBed, .awake, .asleepCore, .asleepDeep, .asleepREM, .asleepUnspecified, .awake]
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
        case .inBed:
            return "In Bed"
        case .asleepUnspecified:
            return "Asleep Unspecified"
        case .asleep:
            return "Asleep"
        case .awake:
            return "Awake"
        case .asleepCore:
            return "Asleep Core"
        case .asleepDeep:
            return "Asleep Deep"
        case .asleepREM:
            return "Asleep REM"
        @unknown default:
            return "unknown"
        }
    }
}
