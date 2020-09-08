//
//  EndPointBuilder.swift
//  CovidNumbers
//
//  Created by Bill Calkins on 8/15/20.
//

import Foundation

enum StateSorts: String {
    case cases, todayCases, deaths, active
}

struct DISEASESH_API {
    
    static let schema = "https"
    static let host = "disease.sh"
    static let version = "v3"
    static let basePath = "\(version)/covid-19"
    
    static let statesBasePath = "/\(basePath)/states"
    static let allBasePath = "/\(basePath)/all"
    static let countriesPath = "/\(basePath)/countries"
    
}
