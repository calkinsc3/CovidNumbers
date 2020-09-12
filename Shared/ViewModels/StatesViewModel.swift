//
//  StatesViewModel.swift
//  CovidNumbers
//
//  Created by William Calkins on 9/8/20.
//

import Foundation
import Combine
import os

class StatesViewModel: ObservableObject {
    
    @Published var stateResults: StateData = [StateDatum.placeholder, StateDatum.placeholder, StateDatum.placeholder]
    
    private let stateDataFetcher = StatesFetcher()
    private var disposables = Set<AnyCancellable>()
    
    init() {
        self.fetchStateData()
    }
    
    private func fetchStateData() {
        
        stateDataFetcher.fetchAllStates()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let publisherError) :
                    switch publisherError as PublisherError {
                        case .network: os_log("Network error in fetchAllStates.", log: Log.networkLogger, type: .error)
                        case .parsing: os_log("Parsing error in fetchAllStates.", log: Log.decodingLogger, type: .error)
                        case .unknown: os_log("Unknown error in fetchAllStates.", log: Log.unknownErrorLogger, type: .error)
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] stateModels in
                guard let self = self else { return }
                self.stateResults = stateModels.sorted(by: {$0.cases > $1.cases})
            }
            .store(in: &disposables)
    }
    
}
