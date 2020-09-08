//
//  StatesView.swift
//  CovidNumbers
//
//  Created by William Calkins on 8/9/20.
//

import SwiftUI

struct StatesView: View {
    
    @ObservedObject var statesViewModel = StatesViewModel()
    
    var body: some View {
        NavigationView {
            Divider()
            
            List(self.statesViewModel.stateResults) { state in
                StateDetailView(givenState: state)
            }
        }
    }
}

struct StateDetailView: View {
    
    var givenState: StateDatum
    
    var body: some View {
        VStack {
            Text(givenState.state)
            Text("Cases: \(givenState.cases)")
            Text("Active: \(givenState.active)")
            Text("Deaths: \(givenState.deaths)")
        }
    }
    
}

struct StatesView_Previews: PreviewProvider {
    static var previews: some View {
        StatesView()
    }
}
