//
//  Parsing.swift
//  CovidNumbers
//
//  Created by Bill Calkins on 8/15/20.
//

import Foundation
import Combine

//MARK: Parse State Items
func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, StatePublisherErrors> {
    
    let decoder = JSONDecoder()
    
    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            .decoding(description: (error as? DecodingError).debugDescription)
        }
        .eraseToAnyPublisher()
    
}
