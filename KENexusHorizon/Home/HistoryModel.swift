//
//  HistoryModel.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 20.08.2024.
//

import Foundation


struct Hostory: Codable {
    var name: String
    var intrument: String
    var date: String
    var time: String
    
    init(name: String, intrument: String, date: String, time: String) {
        self.name = name
        self.intrument = intrument
        self.date = date
        self.time = time
    }
}
