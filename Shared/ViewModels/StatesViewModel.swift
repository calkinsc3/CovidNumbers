//
//  StatesViewModel.swift
//  CovidNumbers
//
//  Created by William Calkins on 9/8/20.
//

import Foundation
import Combine
import os

final class StatesViewModel: ObservableObject {
    
    @Published var stateResults: StateData = []
    
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
                    print(publisherError.description)
//                    switch publisherError as PublisherError {
//                    case .network:
//                        os_log("Network error in fetchAllStates.", log: , type: .error)
//                    case .parsing:
//                        os_log("Parsing error in fetchAllStates.", log: Log.decodingLogger, type: .error)
//                    case .unknown:
//                        os_log("Unknown error in fetchAllStates.", log: Log.unknownErrorLogger, type: .error)
//                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] stateModels in
                guard let self = self else { return }
                self.stateResults = stateModels
            }
            .store(in: &disposables)

        
    }
    
}
