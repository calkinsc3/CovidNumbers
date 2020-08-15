//
//  Fetchable.swift
//  CovidNumbers
//
//  Created by Bill Calkins on 8/15/20.
//

import Foundation
import Combine

typealias StatesPublisher = AnyPublisher<StateData, StatePublisherErrors>
typealias CountryPublisher = AnyPublisher<CountryData, CountryPublisherErrors>

protocol StatesFetchable {
    func fetchAllStates() -> StatesPublisher
    func fetchGivenStates(stateToSearch givenStates: [String]) -> StatesPublisher
}

protocol CountriesFetchable {
    func fetchAllCountries() -> CountryPublisher
    func fetchGivenCountries(countriesToSearch givenCountries: [String]) -> CountryPublisher
}
