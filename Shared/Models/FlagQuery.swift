//
//  FlagQuery.swift
//  CovidNumbers
//
//  Created by William Calkins on 10/30/20.
//

import Combine
#if !os(macOS)
import UIKit
#endif
import os

// TODO: Make Main Actor

final class FlagQuery: ObservableObject {
    
    @Published var flag = UIImage(named: "default_flag")
    
    var subscriptions = Set<AnyCancellable>()
    
    private let session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
    
    // MARK: - Combine Version
    func getFlag(flagImageURL url: URL) {
        
        let flagPublisher = self.session.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap({ UIImage(data: $0)})
            .mapError {$0 as Error}
        
        flagPublisher.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                //print(completion)
            }, receiveValue: { flagImage in
                self.flag = flagImage
            })
            .store(in: &subscriptions)
    }
    
    // MARK: - async/await version
    func getCountryFlag(flatImageURL url: URL) async throws {
        
        let (data, response) = try await self.session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CountryPublisherErrors.apiError(description: "Returned a non-200")
        }
        
        guard let givenImage = UIImage(data: data) else {
            throw CountryPublisherErrors.apiError(description: "Did not get flag data")
        }
        DispatchQueue.main.async {
            self.flag = givenImage
        }
        
    }
}
