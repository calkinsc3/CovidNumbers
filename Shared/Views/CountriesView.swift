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
        .task {
            await self.countriesViewModel.getCountryData()
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
            Button(action: {
                self.countriesViewModel.countriesResults = self.countriesViewModel.countriesResults.sorted(by: {$0.population > $1.population})
            }, label: {
                Label("Sort Population", systemImage: "person.3")
            })
            
        }
        .font(.headline)
    }
    
    
}

struct CountryDetailCellView: View {
    
    let givenCountry: CountryDatum
    @StateObject var flagQuery = FlagQuery()
    
    var body: some View {
        HStack(alignment: .top) {
//            AsyncImage(url: self.givenCountry.countryInfo.flag)
//                .shadow(radius: 10.0)
//                .padding()
            Image(uiImage: self.flagQuery.flag!) //TODO:- don't like the force unwrap
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 33, alignment: .trailing)
                .shadow(radius: 10.0)
                .padding()
            VStack(alignment: .leading) {
                Text(givenCountry.country)
                    .font(.title)
                Text("Cases: \(givenCountry.cases.formattedForDisplay())")
                Text("Deaths: \(givenCountry.deaths.formattedForDisplay())")
                Text("Population: \(givenCountry.population.formattedForDisplay())")
            }
        }
        .task {
            self.flagQuery.getFlag(flagImageURL: self.givenCountry.countryInfo.flag)
        }
    }
    
}

struct CountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView()
    }
}
