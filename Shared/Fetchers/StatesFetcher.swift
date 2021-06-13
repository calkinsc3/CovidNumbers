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
    
    func fectchStateData<T:Decodable>() async throws -> T? {
        
        guard let url = self.makeAllStateComponents(sortBy: .active, includeYesterday: true).url else {
            throw StatePublisherErrors.urlError(description: "Could not create All States URL")
        }
        
        let (data, response) = try await self.session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StatePublisherErrors.apiError(description: "Returned a non-200")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error {
            throw StatePublisherErrors.decoding(description: "Error decoding: \(error)")
        }
    }
}

//MARK:- Fetchablex
extension StatesFetcher: StatesFetchable {
    
    func fetchAllStates() -> StatesPublisher {
        return stateItems(with: self.makeAllStateComponents(sortBy: .active, includeYesterday: true))
    }
    
    func fetchGivenStates(stateToSearch givenStates: [String]) -> StatesPublisher {
        return stateItems(with: self.makeSpecificStateComponents(givenStates: givenStates))
    }
    
    func fetchVaccine(forState state: String) -> StateVaccinePublisher {
        return stateItems(with: self.makeSpecificStateVaccineComponents(givenState: state))
    }
    
    //MARK:- Network Adaptor
    private func stateItems<T:Decodable>(with components:URLComponents) -> AnyPublisher<T, PublisherError> {
        
        guard let url = components.url else {
            return Fail(error: PublisherError.network(description: "Unable to get state URL")).eraseToAnyPublisher()
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
    
    func makeAllStateComponents(sortBy sort: SortOptions, includeYesterday yesterday: Bool) -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = DISEASESH_API.schema
        components.host = DISEASESH_API.host
        components.path = DISEASESH_API.statesBasePath
        components.queryItems = [URLQueryItem(name: "sort", value: sort.rawValue),
                                 URLQueryItem(name: "yesterday", value: yesterday ? "true" : "false")]
        
        return components
    }
    
    func makeSpecificStateComponents(givenStates states: [String]) -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = DISEASESH_API.schema
        components.host = DISEASESH_API.host
        components.path = DISEASESH_API.statesBasePath + "/\(states.joined(separator: ","))"
        
        return components
    }
    
    func makeSpecificStateVaccineComponents(givenState state: String, numberOfDay days: Int = 10) -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = DISEASESH_API.schema
        components.host = DISEASESH_API.host
        components.path = DISEASESH_API.stateVaccineBasePath + "\(state)"
        components.queryItems = [URLQueryItem(name: "lastdays", value: "\(days)")]
        
        return components
    }
}

