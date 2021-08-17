//
//  StatesView.swift
//  CovidNumbers
//
//  Created by William Calkins on 8/9/20.
//

import SwiftUI

struct StatesView: View {
    
    @Environment(\.isSearching) private var isSearching : Bool
    @Environment(\.dismissSearch) private var dismissStateSearch
    
    @StateObject var statesViewModel = StatesViewModel()
    
    @State private var showingSortMenu = false
    @State private var testSearch = ""
    @State private var query = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if self.isSearching {
                    List(self.statesViewModel.searchStateResults) { state in
                        NavigationLink(destination: StateDetailView(givenState: state)) {
                            StateDetailCellView(givenState: state)
                        }
                    }
                } else {
                    List(self.statesViewModel.stateResults) { state in
                        NavigationLink(destination: StateDetailView(givenState: state)) {
                            StateDetailCellView(givenState: state)
                                .swipeActions {
                                    Button  {
                                        self.statesViewModel.pinnedStates.append(state)
                                    } label: {
                                        Label("Pinned", image: "pin")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
            }
        }
        .toolbar(content: {
            ToolbarItem {
                self.sortButtonMenu
            }
        })
        .searchable(text: $query, prompt: "Search State")
        .onChange(of: query, perform: { newValue in
            self.searchForState(query: newValue)
        })
        .navigationTitle("States")
        .task {
            await self.statesViewModel.getStateData()
        }
    }
    
    //MARK:- UI Search
    func searchForState(query: String) {
        self.statesViewModel.searchStateResults = self.statesViewModel.stateResults.filter({$0.state.contains(query)})
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
            Button(action: {
                self.statesViewModel.stateResults = self.statesViewModel.stateResults.sorted(by: {$0.state < $1.state})
            }, label: {
                Label("Sort Asc", systemImage: "arrow.up.arrow.down.circle.fill")
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
                        Text(": \(dateNumbers.percentageOfPopulationVaccinated(statePopulation: givenState.population))")
                    }
                    .font(.body)
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
