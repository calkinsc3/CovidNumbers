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
                HStack {
                    TextField("Search", text: self.$statesViewModel.stateSearch) { (true) in
                        //do something
                    } onCommit: {
                        self.statesViewModel.clearSearch()
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Image(systemName: "magnifyingglass")
                    
                }
                .padding()
                
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
            Button(action: {
                self.statesViewModel.stateResults = self.statesViewModel.stateResults.sorted(by: {$0.state > $1.state})
            }, label: {
                Label("Sort Desc", systemImage: "arrow.up.arrow.down.circle")
            })
            
        }
        .font(.headline)
    }
    
}

struct StateDetailCellView: View {
    
    let givenState: StateDatum
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(givenState.state)
                .font(.largeTitle)
            
            Text("Cases: \(givenState.cases.formattedForDisplay())")
            Text("Active: \(givenState.active.formattedForDisplay())")
            Text("Deaths: \(givenState.deaths.formattedForDisplay())")
        }
    }
}

struct StateDetailView: View {
    
    @StateObject var stateVaccineViewModel = StateVaccineViewModel()
    
    var givenState: StateDatum
    
    var body: some View {
        VStack {
            Text("Cases: \(givenState.cases)")
            Text("Active: \(givenState.active)")
            Text("Deaths: \(givenState.deaths)")
            
            Divider()
            Text("State Population: \(givenState.population)")
            
            VStack {
                Divider()
                Text("Vaccinated")
                    .font(.title)
                List(self.stateVaccineViewModel.numberVaccinated) { dateNumbers in
                    HStack {
                        Text(dateNumbers.date)
                        Text(": \(dateNumbers.vaccinated.formattedForDisplay())")
                    }
                }
            }
            
        }
        .navigationTitle(givenState.state)
        .onAppear(perform: {
            self.stateVaccineViewModel.fetchStateVaccines(givenState: givenState.state)
        })
    }
}

struct StatesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatesView()
            StateDetailCellView(givenState: StateDatum.placeholder)
            StateDetailView(givenState: StateDatum.placeholder)
            
        }
    }
}
