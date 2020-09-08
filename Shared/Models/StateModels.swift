//
//  StateModels.swift
//  CovidNumbers
//
//  Created by William Calkins on 8/9/20.
//

import Foundation

//MARK: - StateData
public typealias StateData = [StateDatum]

// MARK: - StateDatum
public struct StateDatum: Codable, Identifiable {
    public let id = UUID()
    
    let state: String
    let updated, cases, todayCases, deaths: Int
    let todayDeaths, recovered, active, casesPerOneMillion: Int
    let deathsPerOneMillion, tests, testsPerOneMillion, population: Int
}
