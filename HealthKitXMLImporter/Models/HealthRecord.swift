//
//  HealthRecord.swift
//  HealthKitXMLImporter
//
//  Created by Zeref on 10/10/22.
//

import Foundation
import HealthKit

class HealthRecord: CustomStringConvertible {
    var type: String = String()
    var value: String = ""
    var unit: String?
    var sourceName: String = String()
    var sourceVersion: String = String()
    var startDate: Date = Date()
    var endDate: Date = Date()
    var creationDate: Date = Date()

    // Workout data
    var activityType: HKWorkoutActivityType? = HKWorkoutActivityType(rawValue: 0)
    var totalEnergyBurned: Double = 0
    var totalDistance: Double = 0
    var totalEnergyBurnedUnit: String = String()
    var totalDistanceUnit: String = String()

    var metadata: [String: Any]?
    
    var valueDouble: Double{
        return Double(value) ?? 0
    }
    
    func toQuantitySample() -> HKQuantitySample?{
        guard let type = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: type)),
                let unitString = unit else {
            return nil
        }
        let unit = HKUnit(from: unitString)
        let quantity = HKQuantity(unit: unit, doubleValue: valueDouble)
        let sample = HKQuantitySample(
            type: type,
            quantity: quantity,
            start: startDate,
            end: endDate,
            metadata: metadata
        )
        
        return sample
    }
    
    func toHKCategorySample() -> HKCategorySample?{
        let identifier = HKCategoryTypeIdentifier(rawValue: type)
        guard let type = HKCategoryType.categoryType(forIdentifier: identifier),
                let value = identifier.categoryTypeFromString(value) else{
            return nil
        }
        
        let sample = HKCategorySample(
            type: type,
            value: Int(value),
            start: startDate,
            end: endDate,
            metadata: metadata
        )
        return sample
    }
    
    func toHKWorkout() -> HKWorkout?{
        guard type == HKObjectType.workoutType().identifier, let unitString = unit else{
            return nil
        }
        let sample = HKWorkout(
            activityType: activityType ?? HKWorkoutActivityType(rawValue: 0)!,
            start: startDate,
            end: endDate,
            duration: HKQuantity(unit: HKUnit.init(from: unitString), doubleValue: valueDouble).doubleValue(for: HKUnit.second()),
            totalEnergyBurned: HKQuantity(unit: HKUnit.init(from: totalEnergyBurnedUnit), doubleValue: totalEnergyBurned),
            totalDistance: HKQuantity(unit: HKUnit.init(from: totalDistanceUnit), doubleValue: totalDistance),
            device: nil,
            metadata: metadata
        )
        return sample
    }
}

