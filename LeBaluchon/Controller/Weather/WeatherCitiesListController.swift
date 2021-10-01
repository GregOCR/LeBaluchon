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
    
    private var cities: [City] = [
        .init(name: "Paris", longitude: 2.3488, latitude: 48.8534, country: .init(name: "FRANCE", isoCode: "FR")),
        .init(name: "New York", longitude: -74.006, latitude: 40.7143, country: .init(name: "ÉTATS-UNIS", isoCode: "US")),
        .init(name: "Strasbourg", longitude: 7.743, latitude: 48.5834, country: .init(name: "FRANCE", isoCode: "FR"))
    ]
    
    weak var selectionDelegate: CitySelectionDelegate!
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.citiesTableView.tableFooterView = UIView.init(frame: .zero)
        self.citiesTableView.dataSource = self
        self.citiesTableView.delegate = self
        
    }
    
    @objc func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: citiesTableView)
        guard let indexPath = citiesTableView.indexPathForRow(at: point) else {
            return
        }
        cities.remove(at: indexPath.row)
        self.citiesTableView.deleteRows(at: [indexPath], with: .left)
    }

    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addRow(_ sender: UIButton) {
//        cities.insert(contentsOf: ["Annecy":"(FR) France"], at: 0)
//        self.citiesTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherCityCell = tableView.dequeueReusableCell(withIdentifier: ElementIdentifier.named.weatherCityCell) as? WeatherCitySelectionTableViewCell else {
            return UITableViewCell()
        }
        
        let city = cities[indexPath.row]
        weatherCityCell.configure(city: city)
            
        return weatherCityCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        selectionDelegate?.didSelect(city: city)
        self.dismiss()
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

