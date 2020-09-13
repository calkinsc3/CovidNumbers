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
            }
        }
    }
}

struct CountryDetailCellView: View {
    
    let givenCountry: CountryDatum
    
    var body: some View {
        VStack {
            Text(givenCountry.country)
            Text("Cases: \(givenCountry.cases)")
        }
    }
    
}

struct CountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView()
    }
}
