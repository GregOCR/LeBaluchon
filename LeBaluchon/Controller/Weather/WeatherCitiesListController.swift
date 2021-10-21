//
//  WeatherListController.swift
//  LeBaluchon
//
//  Created by Greg on 08/09/2021.
//

import UIKit

protocol CitySelectionDelegate: AnyObject {
    func didSelect(city: City)
}

class WeatherCitiesListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var selectionDelegate: CitySelectionDelegate!
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    @IBAction func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: citiesTableView)
        guard let indexPath = citiesTableView.indexPathForRow(at: point) else { return }
        Cities.shared.entries.remove(at: indexPath.row)
        citiesTableView.deleteRows(at: [indexPath], with: .left)
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesTableView.tableFooterView = UIView.init(frame: .zero)
        citiesTableView.dataSource = self
        citiesTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cities.shared.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherCityCell = tableView.dequeueReusableCell(withIdentifier: ElementIdentifier.named.weatherCityCell) as? WeatherCitySelectionTableViewCell else {
            return UITableViewCell()
        }
        
        let city = Cities.shared.entries[indexPath.row]
        weatherCityCell.configure(city: city)
        
        return weatherCityCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = Cities.shared.entries[indexPath.row]
        selectionDelegate?.didSelect(city: city)
        dismiss()
    }
}

