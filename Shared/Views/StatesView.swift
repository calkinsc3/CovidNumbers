//
//  StatesView.swift
//  CovidNumbers
//
//  Created by William Calkins on 8/9/20.
//

import SwiftUI

struct StatesView: View {
    
    @StateObject var statesViewModel = StatesViewModel()
    
    @State private var showingSortMenu = false
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                List(self.statesViewModel.stateResults) { state in
                    NavigationLink(destination: StateDetailView(givenState: state)) {
                        StateDetailCellView(givenState: state)
                    }
                }
                .toolbar(content: {
                    ToolbarItem {
                        self.sortButtonMenu
                    }
                })
            }
            .navigationTitle("States")
        }
    }
}

private extension StatesView {
    
    var sortButtonMenu: some View {
        
        Menu("Sort") {
            Button(action: {
                self.statesViewModel.stateResults = self.statesViewModel.stateResults.sorted(by: {$0.cases > $1.cases })
            }, label: {
                Label("Cases", systemImage: "bed.double")
            })
            Button(action: {
                self.statesViewModel.stateResults = self.statesViewModel.stateResults.sorted(by: {$0.active > $1.active})
            }, label: {
                Label("Active", systemImage: "bandage")
            })
            Button(action: {
                self.statesViewModel.stateResults = self.statesViewModel.stateResults.sorted(by: {$0.deaths > $1.deaths})
            }, label: {
                Label("Deaths", systemImage: "waveform.path.ecg")
            })
        }
        .font(.headline)
    }
    
}

struct StateDetailCellView: View {
    
    var givenState: StateDatum
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(givenState.state)
                    .font(.headline)
                Text("Cases: \(givenState.cases)")
            }
            HStack {
                Text("Active: \(givenState.active)")
                Text("Deaths: \(givenState.deaths)")
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
        Group {
            StatesView()
            StateDetailCellView(givenState: StateDatum.placeholder)
        }
        
    }
}
