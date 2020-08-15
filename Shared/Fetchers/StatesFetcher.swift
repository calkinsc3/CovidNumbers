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
        
    }
    
    func fetchGivenStates(stateToSearch givenStates: [String]) -> StatesPublisher {
        
    }
    
    //MARK:- Network Adaptor
    private func stateItems<T>(with components:URLComponents) -> AnyPublisher<T, StatePublisherErrors> where T:Decodable {
        
        guard let url = components.url else {
            let error = StatePublisherErrors.network(description: "Could not create URL for State data.")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .mapError { error in
                StatePublisherErrors.network(description: error.localizedDescription)
            }
            .flatMap { returnedPair in
                decode(returnedPair.data)
            }
            .eraseToAnyPublisher()
        
    }
    
}

