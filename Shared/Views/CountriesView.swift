//
//  CountriesView.swift
//  CovidNumbers
//
//  Created by William Calkins on 8/9/20.
//

import SwiftUI

struct CountriesView: View {
    
    @StateObject var countriesViewModel = CountriesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                List(self.countriesViewModel.countriesResults) {country in
                    CountryDetailCellView(givenCountry: country)
                }
                .toolbar(content: {
                    ToolbarItem {
                        self.sortButtonMenu
                    }
                })
            }
            .navigationTitle("Counties")
        }
    }
}

private extension CountriesView {
    
    var sortButtonMenu: some View {
        
        Menu("Sort") {
            Button(action: {
                self.countriesViewModel.countriesResults = self.countriesViewModel.countriesResults.sorted(by: {$0.cases > $1.cases })
            }, label: {
                Label("Cases", systemImage: "bed.double")
            })
            Button(action: {
                self.countriesViewModel.countriesResults = self.countriesViewModel.countriesResults.sorted(by: {$0.active > $1.active})
            }, label: {
                Label("Active", systemImage: "bandage")
            })
            Button(action: {
                self.countriesViewModel.countriesResults = self.countriesViewModel.countriesResults.sorted(by: {$0.deaths > $1.deaths})
            }, label: {
                Label("Deaths", systemImage: "waveform.path.ecg")
            })
            Button(action: {
                self.countriesViewModel.countriesResults = self.countriesViewModel.countriesResults.sorted(by: {$0.country > $1.country})
            }, label: {
                Label("Sort Desc", systemImage: "arrow.up.arrow.down.circle")
            })
            
        }
        .font(.headline)
    }
    
    
}

struct CountryDetailCellView: View {
    
    let givenCountry: CountryDatum
    
    var body: some View {
        VStack(alignment: .center) {
            Text(givenCountry.country)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            HStack {
                Text("Cases: \(givenCountry.cases.formattedForDisplay())")
                Text("Deaths: \(givenCountry.deaths.formattedForDisplay())")
            }
            Text("Population: \(givenCountry.population.formattedForDisplay())")
        }
    }
    
}

struct CountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView()
    }
}
