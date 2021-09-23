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
        .init(title: "Paris", country: .init(iso: "FR")),
        .init(title: "New York", country: .init(iso: "US"))
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "city") as? WeatherCitySelectionTableViewCell else {
            return UITableViewCell()
        }
        
        let city = cities[indexPath.row]
        
        cell.configure(city: city)
        
        return cell
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

