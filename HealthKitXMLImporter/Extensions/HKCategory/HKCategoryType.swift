//
//  HKCategoryType.swift
//  HealthKitXMLImporter
//
//  Created by Zeref on 10/10/22.
//

import Foundation
import HealthKit

extension HKCategoryTypeIdentifier{
    func categoryTypeFromString(_ string: String) -> Int? {
        switch self{
        case .appleStandHour:
            let type = HKCategoryValueAppleStandHour(string: string)
            return type?.rawValue
        case .sleepAnalysis:
            let type = HKCategoryValueSleepAnalysis(string: string)
            return type?.rawValue
        default:
            return nil
        }
    }
}
