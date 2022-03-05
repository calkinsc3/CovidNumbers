//
//  CountriesViewModel.swift
//  CovidNumbers
//
//  Created by William Calkins on 9/12/20.
//

import Foundation
import Combine
import os

class CountriesViewModel: ObservableObject {
    
    @Published var countriesResults: CountryData = [CountryDatum.placeholder]
    
    private let countriesFetcher = CountryFetcher()
    private var disposables = Set<AnyCancellable>()
    
    init() {
        //self.fetchCountriesData()
    }
    
    private func fetchCountriesData() {
        
        countriesFetcher.fetchAllCountries()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let publisherError) :
                    switch publisherError as PublisherError {
                        case .network: os_log("Network error in fetchAllCountries.", log: Log.networkLogger, type: .error)
                        case .parsing: os_log("Parsing error in fetchAllCountries.", log: Log.decodingLogger, type: .error)
                        case .unknown: os_log("Unknown error in fetchAllCountries.", log: Log.unknownErrorLogger, type: .error)
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] countriesModels in
                guard let self = self else { return }
                self.countriesResults = countriesModels.sorted(by: {$0.cases > $1.cases})
            }
            .store(in: &disposables)
    }
    
    func getCountryData() async {
        do {
            let fetchCounties = try await countriesFetcher.fetchCountryData().sorted(by: {$0.cases > $1.cases})
            DispatchQueue.main.async {
                self.countriesResults = fetchCounties
            }
            
        } catch {
            os_log("Network error in fetchCountryData. error", log: Log.networkLogger, type: .error)
        }
    }
    
    
    
    
}
