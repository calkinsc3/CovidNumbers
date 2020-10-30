//
//  CountryFetcher.swift
//  CovidNumbers
//
//  Created by Bill Calkins on 8/15/20.
//

import Foundation
import Combine

//MARK:- CountryFetcher
class CountryFetcher {
    
    private let session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
}

//MARK:- Fetchable Conformance
extension CountryFetcher: CountriesFetchable {
    
    func fetchAllCountries() -> CountryPublisher {
        return countryItems(with: self.makeAllCountryComponents(sortBy: .active, includedYesterday: true))
    }
    
    func fetchGivenCountries(countriesToSearch givenCountries: [String]) -> CountryPublisher {
        return countryItems(with: self.makeSpecificCountryComponents(givenCountries: givenCountries))
    }
    
    //MARK:- Network Adaptor - TODO: centralize this function
    private func countryItems<T:Decodable>(with components:URLComponents) -> AnyPublisher<T, PublisherError> {
        
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
private extension CountryFetcher {
    
    func makeAllCountryComponents(sortBy sort: SortOptions, includedYesterday yesterday: Bool) -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = DISEASESH_API.schema
        components.host = DISEASESH_API.host
        components.path = DISEASESH_API.countriesPath
        components.queryItems = [URLQueryItem(name: "sort", value: sort.rawValue),
                                 URLQueryItem(name: "yesterday", value: yesterday ? "true" : "false")]
        
        return components
    }
    
    func makeSpecificCountryComponents(givenCountries countries: [String]) -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = DISEASESH_API.schema
        components.host = DISEASESH_API.host
        components.path = DISEASESH_API.countriesPath + "/\(countries.joined(separator: ","))"
        
        return components
        
    }
}
