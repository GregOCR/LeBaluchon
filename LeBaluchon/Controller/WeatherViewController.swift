//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var dayPlus1TemperatureView: UIView!
    @IBOutlet weak var dayPlus2TemperatureView: UIView!
    @IBOutlet weak var dayPlus3TemperatureView: UIView!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var dayPlus1DateLabel: UILabel!
    @IBOutlet weak var dayPlus2DateLabel: UILabel!
    @IBOutlet weak var dayPlus3DateLabel: UILabel!
    
    let currentDateTime = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.currentDateLabel.text = getDateInformation(.CurrentDate)
        self.currentTimeLabel.text = getDateInformation(.CurrentTime)
        self.dayPlus1DateLabel.text = getDateInformation(.ShortDatePlus1)
        self.dayPlus2DateLabel.text = getDateInformation(.ShortDatePlus2)
        self.dayPlus3DateLabel.text = getDateInformation(.ShortDatePlus3)
    }
    
    @IBAction func dayPlus1TemperaturesButton(_ sender: Any) {
        showTemperaturesView(dayPlus1TemperatureView)
    }
    @IBAction func dayPlus2TemperaturesButton(_ sender: Any) {
        showTemperaturesView(dayPlus2TemperatureView)
    }
    @IBAction func dayPlus3TemperaturesButton(_ sender: Any) {
        showTemperaturesView(dayPlus3TemperatureView)
    }
    
    func showTemperaturesView(_ target: UIView) {
        UIView.animate(withDuration: 0.33) {
            target.frame.origin.y = 35
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.33) {
                target.frame.origin.y = 125
            }
        }


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
