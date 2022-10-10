//
//  Importer.swift
//  SampleXMLParserDalegate
//
//  Created by Zeref on 10/10/22.
//

import Foundation
import HealthKit
import OSLog

class SampleXMLParserDalegate: NSObject, XMLParserDelegate{
    var allSamples: [HKSample] = []
    var readCount = 0
    var currentRecord: HealthRecord = HealthRecord.init()
    var numberFormatter: NumberFormatter = NumberFormatter()
    var dateFormatter: DateFormatter = DateFormatter()
    
    override init() {
        super.init()
        
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName{
        case "Record":
            parseRecordFromAttributes(attributeDict)
        case "MetadataEntry":
            parseMetaDataFromAttributes(attributeDict)
        case "Workout":
            parseWorkoutFromAttributes(attributeDict)
        default:
            return
        }
    }
    
    private func parseRecordFromAttributes(_ attributeDict: [String: String]) {
        currentRecord.type = attributeDict["type"]!
        currentRecord.sourceName = attributeDict["sourceName"] ??  ""
        currentRecord.sourceVersion = attributeDict["sourceVersion"] ??  ""
        currentRecord.value = attributeDict["value"] ?? "0"
        currentRecord.unit = attributeDict["unit"] ?? ""
        if let startDate = attributeDict["startDate"],
           let date = dateFormatter.date(from: startDate) {
            currentRecord.startDate = date
        }
        if let endDate = attributeDict["endDate"],
            let date = dateFormatter.date(from: endDate) {
            currentRecord.endDate = date
        }
        if currentRecord.startDate >  currentRecord.endDate {
            currentRecord.startDate = currentRecord.endDate
        }
        if let creationDate = attributeDict["creationDate"],
            let date = dateFormatter.date(from: creationDate) {
            currentRecord.creationDate = date
        }
    }
    
    private func parseMetaDataFromAttributes(_ attributeDict: [String: String]) {
        var key: String?
        var value: Any?
        for (attributeKey, attributeValue) in attributeDict {
            if attributeKey == "key" {
                key = attributeValue
            }
            if attributeKey == "value" {
                if let intValue = Int(attributeValue) {
                    value = intValue
                } else {
                    value = attributeValue
                }
                if attributeValue.hasSuffix("%") {
                    let components = attributeValue.split(separator: " ")
                    value = HKQuantity.init(
                        unit: .percent(),
                        doubleValue: (numberFormatter.number(from: String(components.first!))!.doubleValue)
                    )
                }
            }
        }

        currentRecord.metadata = [String: Any]()
        if let key = key, let value = value, key != "HKMetadataKeySyncIdentifier" {
            currentRecord.metadata?[key] = value
        }
    }
    
    private func parseWorkoutFromAttributes(_ attributeDict: [String: String]) {
        currentRecord.type = HKObjectType.workoutType().identifier
        currentRecord.activityType = HKWorkoutActivityType.activityTypeFromString(attributeDict["workoutActivityType"] ?? "")
        currentRecord.sourceName = attributeDict["sourceName"] ??  ""
        currentRecord.sourceVersion = attributeDict["sourceVersion"] ??  ""
        currentRecord.value = attributeDict["duration"] ?? "0"
        currentRecord.unit = attributeDict["durationUnit"] ?? ""
        currentRecord.totalDistance = Double(attributeDict["totalDistance"] ?? "0") ?? 0
        currentRecord.totalDistanceUnit = attributeDict["totalDistanceUnit"] ??  ""
        currentRecord.totalEnergyBurned = Double(attributeDict["totalEnergyBurned"] ?? "0") ?? 0
        currentRecord.totalEnergyBurnedUnit = attributeDict["totalEnergyBurnedUnit"] ??  ""
        if let startDate = attributeDict["startDate"],
           let date = dateFormatter.date(from: startDate) {
            currentRecord.startDate = date
        }
        if let endDate = attributeDict["endDate"],
           let date = dateFormatter.date(from: endDate) {
            currentRecord.endDate = date
        }
        if currentRecord.startDate > currentRecord.endDate {
            currentRecord.startDate = currentRecord.endDate
        }
        if let creationDate = attributeDict["creationDate"],
           let date = dateFormatter.date(from: creationDate) {
            currentRecord.creationDate = date
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName == "Record" || elementName == "Workout" else{
            return
        }
        readCount += 1
        os_log("Record: %@", currentRecord.description)
        
        // Store in arry
        addSample(item: currentRecord)
        
        // Reset current record
        currentRecord = HealthRecord.init()
    }
    
    func addSample(item: HealthRecord){
        // HealthKit raises an exception if time between end and start date is > 345600
        let duration = item.endDate.timeIntervalSince(item.startDate)
        if duration > 345600 || (item.type == "HKQuantityTypeIdentifierHeadphoneAudioExposure" && duration < 0.001) {
            return
        }
        
        var hkSample: HKSample? = nil
        if let _ = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: item.type)) {
            hkSample = item.toQuantitySample()
        }
        else if let _ = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: item.type)) {
            hkSample = item.toHKCategorySample()
        }
        else if item.type == HKObjectType.workoutType().identifier {
            hkSample = item.toHKWorkout()
        }
        else {
            os_log("Didn't catch this item: %@", item.description)
        }
        
        if let sample = hkSample{
            allSamples.append(sample)
        }
        
    }
}
