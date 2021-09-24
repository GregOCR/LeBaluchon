//
//  WeatherCitySelectionTableViewCell.swift
//  LeBaluchon
//
//  Created by Greg on 23/09/2021.
//

import UIKit

class WeatherCitySelectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var cityCountryIsoLabel: UILabel!
    @IBOutlet private weak var cityCountryNameLabel: UILabel!

    func configure(city: City) {
        cityNameLabel.text = city.name
        cityCountryIsoLabel.text = city.country.isoCode
        cityCountryNameLabel.text = city.country.name
    }
}
