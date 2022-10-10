//
//  ContentView.swift
//  HealthKitXMLImporter
//
//  Created by Zeref on 10/10/22.
//

import SwiftUI

struct ContentView: View {
    let store = HealthStore()
    var body: some View {
        VStack {
            Image(systemName: "tray")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button(action: importData) {
                Text("Import")
                    .font(.body)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
        }
        .padding()
        .task {
            try? await store.requestHealthDataAccessIfNeeded()
        }
    }
    
    func importData(){
        let importer = SamplesImporter()
        let samples = importer.importSamples()
        Task{
            await store.save(samples: samples)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
