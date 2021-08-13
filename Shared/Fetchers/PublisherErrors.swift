//
//  PublisherErrors.swift
//  CovidNumbers
//
//  Created by Bill Calkins on 8/15/20.
//

import Foundation

enum StatePublisherErrors: Error {
    case network(description: String)
    case decoding(description: String)
    case urlError(description: String)
    case apiError(description: String)
}

enum CountryPublisherErrors: Error {
    case network(description: String)
    case decoding(description: String)
    case urlError(description: String)
    case apiError(description: String)
}

enum PublisherError: Swift.Error, CustomStringConvertible {
    
    case network(description: String)
    case parsing(description: String)
    case unknown
    
    var description: String {
        switch self {
        case .network: return "A network error occured."
        case .parsing: return "A parsing error occured."
        case .unknown: return "An unknown error occured."
        }
    }
    
    init(_ error: Swift.Error) {
        switch error {
        case is URLError: self = .network(description: error.localizedDescription)
        case is DecodingError: self = .parsing(description: error.localizedDescription)
        default:
            self = error as? PublisherError ?? .unknown
        }
    }
    
}
