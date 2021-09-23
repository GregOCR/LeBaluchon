//
//  LocationManager.swift
//  LeBaluchon
//
//  Created by Greg on 11/09/2021.
//

import Foundation

protocol LocationManagerDelegate {
    func didUpdateLocation(_ locationManager: LocationManager, location: LocationModel)
    func didFailWithError(error: Error)
}

struct LocationManager {
    var delegate: LocationManagerDelegate?
}
