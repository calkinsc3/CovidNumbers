//
//  StateModels.swift
//  CovidNumbers
//
//  Created by William Calkins on 8/9/20.
//

import Foundation

// MARK: - StateDatum
public struct StateDatum: Codable {
    let state: String
    let updated, cases, todayCases, deaths: Int
    let todayDeaths, active, casesPerOneMillion, deathsPerOneMillion: Int
    let tests, testsPerOneMillion: Int
}

public typealias StateData = [StateDatum]
