//
//  WeatherCitySelectionTableViewCell.swift
//  LeBaluchon
//
//  Created by Greg on 23/09/2021.
//

import UIKit


struct City {
    let title: String
    let country: Country
}

struct Country {
    let iso: String
}


class WeatherCitySelectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var cityTitleLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    
    
    func configure(city: City) {
        cityTitleLabel.text = city.title
        countryLabel.text = city.country.iso
    }

}
