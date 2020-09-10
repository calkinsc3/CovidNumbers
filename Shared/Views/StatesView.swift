//
//  StatesView.swift
//  CovidNumbers
//
//  Created by William Calkins on 8/9/20.
//

import SwiftUI

struct StatesView: View {
    
    @StateObject var statesViewModel = StatesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                List(self.statesViewModel.stateResults) { state in
                    NavigationLink(destination: StateDetailView(givenState: state)) {
                        StateDetailCellView(givenState: state)
                    }
                }
            }
            
        }
    }
}

struct StateDetailCellView: View {
    
    var givenState: StateDatum
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(givenState.state)
                    .font(.title)
                Text("Cases: \(givenState.cases)")
            }
            HStack {
                Text("Active: \(givenState.active)")
                Text("Deaths: \(givenState.deaths)")
            }
        }
        .navigationTitle("States")
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
        Group {
            StatesView()
            StateDetailCellView(givenState: StateDatum.placeholder)
        }
        
    }
}
