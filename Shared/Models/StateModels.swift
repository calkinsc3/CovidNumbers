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
public struct StateDatum: Codable, Equatable, Hashable {
    
    static let `placeholder` = Self(state: "Wisconsin", updated: 1599609928927, cases: 82477, todayCases: 717, deaths: 1168, todayDeaths: 0, recovered: 73122, active: 8187, casesPerOneMillion: 14165, deathsPerOneMillion: 201, tests: 1312636, testsPerOneMillion: 225445, population: 5822434)
    
    let state: String
    let updated, cases, todayCases, deaths: Int
    let todayDeaths, recovered, active, casesPerOneMillion: Int
    let deathsPerOneMillion, tests, testsPerOneMillion, population: Int
}

extension StateDatum: Identifiable {
    public var id: String { self.state }
}

// MARK: - StateVaccines
struct StateVaccines: Decodable, Equatable, Hashable {
    var state: String
    var timeline: [String: Int]
}

extension StateVaccines: Identifiable {
    public var id: String { self.state }
}
