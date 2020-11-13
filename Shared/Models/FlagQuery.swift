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

final class FlagQuery: ObservableObject {
    
    @Published var flag = UIImage(named: "default_flag")
    
    var subscriptions = Set<AnyCancellable>()
    
    private let session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
    
    func getFlag(flagImageURL url: URL) {
        
        let flagPublisher = self.session.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap({ UIImage(data: $0)})
            .mapError {$0 as Error}
        
        flagPublisher.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { flagImage in
                self.flag = flagImage
            })
            .store(in: &subscriptions)
    }
}
