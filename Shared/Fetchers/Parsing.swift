//
//  Parsing.swift
//  CovidNumbers
//
//  Created by Bill Calkins on 8/15/20.][
//

import Foundation
import Combine

//MARK: Parse State Items
func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, PublisherError> {
    
    let decoder = JSONDecoder()
    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            PublisherError.init(error)
        }
        .eraseToAnyPublisher()
    
}
