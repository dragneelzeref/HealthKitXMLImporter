//
//  SamplesImporter.swift
//  HealthKitXMLImporter
//
//  Created by Zeref on 10/10/22.
//

import Foundation
import HealthKit

class SamplesImporter{
    let file: String
    
    init(file: String = "export") {
        self.file = file
    }
    
    func importSamples() -> [HKSample]{
        guard let url = Bundle.main.url(forResource: file, withExtension: "xml"),
                let parser = XMLParser(contentsOf: url) else {
            return []
        }
        let parseDelegate = SampleXMLParserDalegate()
        parser.delegate = parseDelegate
        parser.parse()
        let samples = parseDelegate.allSamples
        return samples
    }
}
