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
    case apiError(description: String)
}

enum CountryPublisherErrors: Error {
    case network(description: String)
    case decoding(description: String)
    case apiError(description: String)
}
