//
//  StatesFetcher.swift
//  CovidNumbers
//
//  Created by Bill Calkins on 8/15/20.
//

import Foundation
import Combine

// MARK: - StatesFetcher
final class StatesFetcher: NSObject {
    
    private var session: URLSession?
    
    override init() {
        super.init()
        
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    }
    
    
}

// MARK: - Fetchable
extension StatesFetcher {
    
//    func fetchAllStates() -> StatesPublisher {
//        //return stateItems(with: self.makeAllStateComponents(sortBy: .active, includeYesterday: true))
//    }
//
//    func fetchGivenStates(stateToSearch givenStates: [String]) -> StatesPublisher {
//        //return stateItems(with: self.makeSpecificStateComponents(givenStates: givenStates))
//    }
//
//    func fetchVaccine(forState state: String) -> StateVaccinePublisher {
//        //return stateItems(with: self.makeSpecificStateVaccineComponents(givenState: state))
//    }
    
    // MARK: - Network Adaptor
//    private func stateItems<T:Decodable>(with components:URLComponents) -> AnyPublisher<T, PublisherError> {
//
//        guard let url = components.url else {
//            return Fail(error: PublisherError.network(description: "Unable to get state URL")).eraseToAnyPublisher()
//        }
//
//        return session?.dataTaskPublisher(for: url)
//            .mapError { error in
//                PublisherError(error)
//            }
//            .flatMap { returnedPair in
//                decode(returnedPair.data)
//            }
//            .eraseToAnyPublisher()
//    }
    
    // MARK: - async/await version
    func fectchStateData() async throws -> StateData {
        
        guard let url = self.makeAllStateComponents(sortBy: .active, includeYesterday: true).url, let localSession = self.session else {
            throw StatePublisherErrors.urlError(description: "Could not create All States URL")
        }
        
        let (data, response) = try await localSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw StatePublisherErrors.apiError(description: "Returned a non-200")
        }
        
        do {
            return try JSONDecoder().decode(StateData.self, from: data)
        } catch let error {
            throw StatePublisherErrors.decoding(description: "Error decoding: \(error)")
        }
    }
}

// MARK: - Endpoint Builder
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

// MARK: - URLSessionDelegate
extension StatesFetcher: URLSessionTaskDelegate {
   
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("in metrices: \(metrics)")
    }
   
}

