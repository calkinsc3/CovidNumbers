//
//  StatesFetcher.swift
//  CovidNumbers
//
//  Created by Bill Calkins on 8/15/20.
//

import Foundation
import Combine

//MARK:- StatesFetcher
class StatesFetcher {
    
    private let session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
}

//MARK:- Fetchable
extension StatesFetcher: StatesFetchable {
    func fetchAllStates() -> StatesPublisher {
        return stateItems(with: self.makeAllStateComponents(sortBy: .active, includeYesterday: true))
    }
    
    func fetchGivenStates(stateToSearch givenStates: [String]) -> StatesPublisher {
        return stateItems(with: self.makeSpecificStateComponents(givenStates: givenStates))
    }
    
    //MARK:- Network Adaptor
    private func stateItems<T>(with components:URLComponents) -> AnyPublisher<T, PublisherError> where T:Decodable {
        
        guard let url = components.url else {
            return Fail(error: PublisherError.network).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .mapError { error in
                PublisherError(error)
            }
            .flatMap { returnedPair in
                decode(returnedPair.data)
            }
            .eraseToAnyPublisher()
    }
}

//MARK:- Endpoint Builder
private extension StatesFetcher {
    
    func makeAllStateComponents(sortBy sort: StateSorts, includeYesterday yesterday: Bool) -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = DISEASESH_API.schema
        components.host = DISEASESH_API.host
        components.path = DISEASESH_API.statesBasePath
        components.queryItems = [URLQueryItem(name: "sort", value: sort.rawValue), URLQueryItem(name: "yesterday", value: yesterday ? "true" : "false")]
        
        return components
    }
    
    func makeSpecificStateComponents(givenStates states: [String]) -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = DISEASESH_API.schema
        components.host = DISEASESH_API.host
        components.path = DISEASESH_API.statesBasePath + "/\(states.joined(separator: ","))"
        
        return components
    }
}

