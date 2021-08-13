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
struct CountryDatum: Codable, Equatable, Hashable {
    let updated: Int
    let country: String
    let countryInfo: CountryInfo
    let cases, todayCases, deaths, todayDeaths: Int
    let population, active: Int
    
    var formattedCases: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self.cases))
    }
    
    static let `placeholder` = Self(updated: 1599954756003, country: "Afghanistan", countryInfo: CountryInfo.placeholder, cases: 38606, todayCases: 34, deaths: 1420, todayDeaths: 0, population: 50000, active: 5000)
}

// MARK: - CountryInfo
struct CountryInfo: Codable, Equatable, Hashable {
    let _id: Int?
    let iso2, iso3: String?
    let lat, long: Double
    let flag: URL
    
    static let `placeholder` = Self(_id: 4, iso2: "AF", iso3: "AFG", lat: 33, long: 65, flag: URL(string: "https://disease.sh/assets/img/flags/af.png")!)
    
}

extension CountryDatum: Identifiable { //TODO:- Find a better way
    //public var id: String { self.country }
    var id : String { UUID().uuidString }
}

extension Int {
    func formattedForDisplay() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
