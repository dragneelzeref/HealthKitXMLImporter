//
//  HealthStore.swift
//  HealthKitXMLImporter
//
//  Created by Zeref on 10/10/22.
//

import Foundation
import HealthKit


class HealthStore{
    let store: HKHealthStore = HKHealthStore()
    
    // MARK: - Data Types
    var readDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    var shareDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    var allHealthDataTypes: [HKSampleType] {
        return Array(allSampleTypes ?? [])
    }
    
    /// Return an HKSampleType based on the input identifier that corresponds to an HKQuantityTypeIdentifier, HKCategoryTypeIdentifier
    /// or other valid HealthKit identifier. Returns nil otherwise.
    func getSampleType(for identifier: String) -> HKSampleType? {
        if let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: identifier)) {
            return quantityType
        }
        
        if let categoryType = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: identifier)) {
            return categoryType
        }
        
        return nil
    }
    
    // MARK: - Authorization
    
    /// Request health data from HealthKit if needed.
    @MainActor
    func requestHealthDataAccessIfNeeded(toShare shareTypes: Set<HKSampleType>,read readTypes: Set<HKObjectType>) async throws {
        if !HKHealthStore.isHealthDataAvailable() {
            return
        }
        debugPrint("Requesting HealthKit authorization...")
        try await store.requestAuthorization(toShare: shareTypes, read: readTypes)
    }
    
    /// Request health data from HealthKit if needed.
    func requestHealthDataAccessIfNeeded() async throws {
        let read = Set(allHealthDataTypes)
        let write = Set(allHealthDataTypes)
        try await requestHealthDataAccessIfNeeded(toShare: write, read: read)
    }
    
    func save(samples: [HKSample]) async{
        do {
            try await store.save(samples)
            debugPrint("Sucsess")
        } catch {
            debugPrint("Error - \(error.localizedDescription)")
        }
        
    }
    
}

