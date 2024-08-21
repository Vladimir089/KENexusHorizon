//
//  NotesModel.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 21.08.2024.
//

import Foundation


struct Note: Codable {
    var instrument: String
    var name: String
    var job: String
    var level: String
    var imagies: [Data]
    
    init(instrument: String, name: String, job: String, level: String, imagies: [Data]) {
        self.instrument = instrument
        self.name = name
        self.job = job
        self.level = level
        self.imagies = imagies
    }
}
