//
//  CountryModels.swift
//  CovidNumbers
//
//  Created by William Calkins on 8/9/20.
//

import Foundation
#if !os(macOS)
import UIKit
#endif

//MARK:- CountryData
typealias CountryData = [CountryDatum]

//MARK: - CountryDatum
struct CountryDatum: Codable, Identifiable, Equatable, Hashable {
    let id = UUID()
    let updated: Int
    let country: String
    let countryInfo: CountryInfo
    let cases, todayCases, deaths, todayDeaths: Int
    let recovered, todayRecovered, active, critical: Int
    let casesPerOneMillion: Int
    let deathsPerOneMillion: Double
    let tests, testsPerOneMillion, population: Int
    let continent: String?
    let oneCasePerPeople, oneDeathPerPeople, oneTestPerPeople: Int
    let activePerOneMillion, recoveredPerOneMillion, criticalPerOneMillion: Double
    
    var formattedCases: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self.cases))
    }
    
    static let `placeholder` = Self(updated: 1599954756003, country: "Afghanistan", countryInfo: CountryInfo.placeholder, cases: 38606, todayCases: 34, deaths: 1420, todayDeaths: 0, recovered: 31154, todayRecovered: 25, active: 6032, critical: 93, casesPerOneMillion: 987, deathsPerOneMillion: 36, tests: 106062, testsPerOneMillion: 2713, population: 39095891, continent: "Asia", oneCasePerPeople: 1013, oneDeathPerPeople: 27532, oneTestPerPeople: 369, activePerOneMillion: 154.29, recoveredPerOneMillion: 796.86, criticalPerOneMillion: 2.38)
}

// MARK: - CountryInfo
struct CountryInfo: Codable, Equatable, Hashable {
    let _id: Int?
    let iso2, iso3: String?
    let lat, long: Double
    let flag: URL
    
    static let `placeholder` = Self(_id: 4, iso2: "AF", iso3: "AFG", lat: 33, long: 65, flag: URL(string: "https://disease.sh/assets/img/flags/af.png")!)
    
}

extension Int {
    func formattedForDisplay() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
}


