//
//  WorldTotals.swift
//  CovidNumbers
//
//  Created by William Calkins on 11/2/20.
//

import Foundation
import Combine

/*
{
    "updated": 1604315304822,
    "cases": 46805168,
    "todayCases": 437261,
    "deaths": 1205049,
    "todayDeaths": 5305,
    "recovered": 33749377,
    "todayRecovered": 269586,
    "active": 11850742,
    "critical": 85243,
    "casesPerOneMillion": 6005,
    "deathsPerOneMillion": 154.6,
    "tests": 823413354,
    "testsPerOneMillion": 105777.68,
    "population": 7784377122,
    "oneCasePerPeople": 0,
    "oneDeathPerPeople": 0,
    "oneTestPerPeople": 0,
    "activePerOneMillion": 1522.38,
    "recoveredPerOneMillion": 4335.53,
    "criticalPerOneMillion": 10.95,
    "affectedCountries": 218
}

*/

struct WorldTotals: Decodable {
    
    let updated: Double
    let cases: Double
    let todayCases: Double
    let deaths: Double
    let active: Double
    let population: Double
}
