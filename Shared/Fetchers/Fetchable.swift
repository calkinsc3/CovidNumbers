//
//  Fetchable.swift
//  CovidNumbers
//
//  Created by Bill Calkins on 8/15/20.
//

import Foundation
import Combine

typealias StatesPublisher = AnyPublisher<StateData, PublisherError>
typealias CountryPublisher = AnyPublisher<CountryData, PublisherError>
typealias TotalsPublisher = AnyPublisher<WorldTotals, PublisherError>

protocol StatesFetchable {
    func fetchAllStates() -> StatesPublisher
    func fetchGivenStates(stateToSearch givenStates: [String]) -> StatesPublisher
}

protocol CountriesFetchable {
    func fetchAllCountries() -> CountryPublisher
    func fetchGivenCountries(countriesToSearch givenCountries: [String]) -> CountryPublisher
}

protocol TotalsFetchable {
    func fetchTotals() -> TotalsPublisher
}
