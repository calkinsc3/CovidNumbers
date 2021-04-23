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
    @Published var stateSearch: String = "" {
        didSet {
            self.stateResults = self.stateResults.filter({$0.state.contains(stateSearch)})
        }
    }
    
    private let stateDataFetcher = StatesFetcher()
    private var disposables = Set<AnyCancellable>()
    
    init() {
        
        self.fetchStateData()
        
//        $stateSearch
//            .dropFirst(2)
//            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
//            .sink { (searchFor) in
//                self.stateResults = self.stateResults.filter({$0.state.contains(searchFor)})
//            }
//            .store(in: &disposables)
    }
    
    func clearSearch() {
        //self.stateSearch = ""
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

//MARK:- StateVaccinesViewModel
class StateVaccineViewModel: ObservableObject {
    
    @Published var numberVaccinated: [NumberVaccinate] = []
    
    private let stateDataFetcher = StatesFetcher()
    private var disposables = Set<AnyCancellable>()
       
    func fetchStateVaccines(givenState state: String) {
        
        stateDataFetcher.fetchVaccine(forState: state)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .failure(let publisherError) :
                    switch publisherError as PublisherError {
                        case .network: os_log("Network error in fetchVaccinationData.", log: Log.networkLogger, type: .error)
                        case .parsing: os_log("Parsing error in fetchVaccinationData.", log: Log.decodingLogger, type: .error)
                        case .unknown: os_log("Unknown error in fetchVaccinationData.", log: Log.unknownErrorLogger, type: .error)
                    }
                case .finished:
                    break
                }
                
            } receiveValue: { (stateVaccines) in
                
                let mappedNumberOfVaccines = stateVaccines.timeline.map({NumberVaccinate(date: $0.key, vaccinated: $0.value)})
                let sortedVaccines = mappedNumberOfVaccines.sorted { (firstVaccinated, secondVaccinated) -> Bool in
                    guard let realDate1 = firstVaccinated.realDate, let realDate2 = secondVaccinated.realDate else {
                        return false
                    }
                    return realDate1 > realDate2
                }
                
                self.numberVaccinated = sortedVaccines
            }
            .store(in: &disposables)
    }
}

struct NumberVaccinate: Identifiable {
    var id = UUID()
    var date: String
    var realDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.date(from: self.date)
    }
    var vaccinated: Int
}
