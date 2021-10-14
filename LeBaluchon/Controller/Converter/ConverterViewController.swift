//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//
 
// quel est l'ordre idéal pour les  func  IBoutlet  didLoad  ... ?
// comment utiliser coreLocation de weather à converter
// comment changer la font du datepicker
// pourquoi une latence aux premières utilisations des sons et d'une animation en même temps
// quand utiliser le model swift ou cocoa ? et comment reconnaitre si l'un l'autre a été utilisé ?
// comment stopper une UIView.animate
// comment utiliser CoreData et UserDefault, quand utiliser l'un ou l'autre ?
// comment garder la position du sélecteur pickerView lorsqu'on quitte l'app


import UIKit
import CoreLocation

class ConverterViewController: UIViewController {
    
    // MARK: - Properties
    
    private let dateManager = DateManager.shared
    private let soundManager = SoundManager.shared
    
    private let calculator = Calculator()
   
    private var fromAmountBeforeComa = "0"
    private var fromAmountHasComa = false
    private var fromAmountAfterComa = "00"

    let currencyPath = Currencies.shared.entries
    
    private var fromCurrencyPickerViewPosition = 0 {
        didSet {
            print("updateData picker 1 >>> \(currencyPath[fromCurrencyPickerViewPosition].description)")
        }
    }
    private var toCurrencyPickerViewPosition = 0 {
        didSet {
            print("updateData picker 2 >>> \(currencyPath[toCurrencyPickerViewPosition].description)")
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var fromCurrencyPickerView: UIPickerView!
    @IBOutlet weak var toCurrencyPickerView: UIPickerView!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var fromCurrencyDescriptionLabel: UILabel!
    @IBOutlet weak var fromCurrencyAmountLabel: UILabel!
    @IBOutlet weak var fromCurrencyRateLabel: UILabel!
    
    @IBOutlet weak var toCurrencyDescriptionLabel: UILabel!
    @IBOutlet weak var toCurrencyAmountLabel: UILabel!
    @IBOutlet weak var toCurrencyRateLabel: UILabel!
    
    @IBOutlet weak var ticketDateTimeLabel: UILabel!
    @IBOutlet weak var ticketChangeLabel: UILabel!
    
    @IBOutlet weak var ticketFromCurrencyISOLabel: UILabel!
    @IBOutlet weak var ticketFromCurrencyAmountLabel: UILabel!
    @IBOutlet weak var ticketFromCurrencyDescriptionLabel: UILabel!
    
    @IBOutlet weak var ticketToCurrencyISOLabel: UILabel!
    @IBOutlet weak var ticketToCurrencyAmountLabel: UILabel!
    @IBOutlet weak var ticketToCurrencyDescriptionLabel: UILabel!
    
    @IBOutlet weak var currencyDataDatePicker: UIDatePicker!
    
    @IBOutlet weak var ticketMaskView: UIView!
    @IBOutlet weak var shareTrashStackView: UIStackView!
    
    @IBOutlet weak var ticketView: UIView!
    
    @IBOutlet weak var overAllView: UIView!
    
    // MARK: - Overrided Methods
    
    // set the color of content status bar in white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
        self.ticketView.layer.shadowColor = Color.shared.darkConverterColor.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshDate()
    }
    
    // MARK: - IBAction
    
    @IBAction func refreshCurrenciesRatesButton(_ sender: Any) {
        print("refreshRates")
    }
    
    @IBAction func didTapNumberButton(_ sender: UIButton) {
        Vibration.For.numbersAndDotButtons.perform()
        
        guard let entry = sender.title(for: .normal) else { return }
        
        if entry == "." {
            fromAmountHasComa = true
            return
        }
        if fromAmountHasComa || fromAmountBeforeComa.count == 8 {
            fromAmountAfterComa = fromAmountAfterComa.last!.description + entry
        } else if fromAmountBeforeComa.count < 8 {
            if fromAmountBeforeComa.asDouble() != 0 && !fromAmountHasComa {
                fromAmountBeforeComa += entry
            } else {
                fromAmountBeforeComa = entry
            }
        }
        updateFromAmountLabel()
        calculate()
    }
    
    @IBAction func didTapACButton(_ sender: UIButton) {
        Vibration.For.acResetButton.perform()
        resetFromCurrencyAmount()
        updateFromAmountLabel()
    }
    
    @IBAction func didSwipeUpGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5) { [self] in
            ticketView.frame.origin.y = ticketMaskView.frame.height
            soundManager.play(.Woop)
        }
        UIView.animate(withDuration: 0.25) { [self] in
            overAllView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            ticketView.frame.origin.y = ticketMaskView.frame.height+20
            ticketMaskView.alpha = 0
            share(image: captureTheTicket())
        }
    }
    
    @IBAction func didSwipeDownGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.33) { [self] in
            ticketView.frame.origin.y = +ticketMaskView.frame.height+20
            soundManager.play(.Woop)
        }
        UIView.animate(withDuration: 0.25) { [self] in
            overAllView.alpha = 0.011
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { [self] in
            soundManager.play(.Paper)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            ticketView.frame.origin.y = ticketMaskView.frame.height+20
            overAllView.alpha = 0
            ticketMaskView.alpha = 0
        }
    }

    
    @IBAction func didTapShowTicketButton(_ sender: UIButton) {
        if converterHasAResult() {
            //        self.updateTicketLabels()
            overAllView.alpha = 0.011
            ticketMaskView.alpha = 1
            
            UIView.animate(withDuration: 1.25) { [self] in
                ticketView.frame.origin.y = ticketMaskView.frame.height - ticketView.frame.height
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [self] in
                UIView.animate(withDuration: 0.25) { [self] in
                    overAllView.alpha = 1
                    ticketView.frame.origin.y = ticketMaskView.frame.origin.y + (shareTrashStackView.frame.size.height/2 - ticketView.frame.size.height/2)
                }
            }
            overAllView.appearWithDelay()
            soundManager.play(.Printer)
        
    } else {
        self.popUpAlert(title: "Ticket", message: "Veuillez sélectionner 2 DEVISES et écrire UN MONTANT pour obtenir un ticket du résultat de la conversion.", asActionSheet: false, autoDismiss: false)
    }
    }
    
    @IBAction func didTapCopyInClipboardButton(_ sender: UIButton) {
        if converterHasAResult() {
            self.popUpAlert(title: "✔︎", message: "Résultat copié dans le presse-papier.", asActionSheet: true, autoDismiss: true)
        } else {
            self.popUpAlert(title: "Copie / presse-papier", message: "Veuillez sélectionner 2 DEVISES et écrire UN MONTANT pour pouvoir copier le résultat de la conversion.", asActionSheet: false, autoDismiss: false)
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
    
    // MARK: - Functions
    
    func converterHasAResult() -> Bool {
        var result = false
        if fromCurrencyPickerViewPosition != 0 && toCurrencyPickerViewPosition != 0 && fromCurrencyAmountLabel.text?.asDouble() != 0 {
            result = true
        }
        return result
    }
    
    func updateFromAmountLabel() {
        fromCurrencyAmountLabel?.text = "\(fromAmountBeforeComa).\(fromAmountAfterComa)"
    }
    
    func resetFromCurrencyAmount() {
        fromAmountBeforeComa = "0"
        fromAmountHasComa = false
        fromAmountAfterComa = "00"
        toCurrencyAmountLabel.text = "0.00"
    }
    
    private func updateTicketLabels() {
        //        self.ticketDateTimeLabel.text = dateManager.getFormattedDate(.CurrentUTCTime)
        //        self.ticketFirstCurrencyFullLabel.text = self.fromCurrencyDescriptionLabel.text?.uppercased()
        //        self.ticketFirstCurrencyShortLabel.text = self.fromCurrencyPickerView.selectedRow(inComponent: fromCurrencyPickerViewPosition).description
        //        self.ticketFirstCurrencyAmountLabel.text = self.fromCurrencyAmountLabel.text
        //        self.ticketChangeLabel.text = "1 \(fromCurrencyAmountLabel.text!) = \(toCurrencyAmountLabel.text!) \(self.fromCurrencyPickerView.selectedRow(inComponent: toCurrencyPickerViewPosition).description)"
        //        self.ticketSecondCurrencyFullLabel.text = self.toCurrencyDescriptionLabel.text?.uppercased()
        //        self.ticketSecondCurrencyShortLabel.text = self.fromCurrencyPickerView.selectedRow(inComponent: toCurrencyPickerViewPosition).description
        //        self.ticketSecondCurrencyAmountLabel.text = self.toCurrencyAmountLabel.text
    }
    
    private func captureTheTicket() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: ticketView.bounds.size)
        let image = renderer.image { ctx in
            self.ticketView.backgroundColor = UIColor.clear
            self.ticketView.drawHierarchy(in: self.ticketView.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    private func share(image:UIImage?) {
        
        var objectsToShare = [UIImage]()
        
        if let shareImageObj = image {
            objectsToShare.append(shareImageObj)
        }
        
        if image != nil {
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func refreshDate() {
        self.currentDateLabel.text = dateManager.getFormattedDate(.FullCurrentDate).uppercased()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.currentDateLabel.text = self.dateManager.getFormattedDate(.FullCurrentDate).uppercased()
        }
    }
}

// MARK: - Extensions

extension ConverterViewController: CalculatorProtocol {
    func didUpdateOperation(operation: String) {
        //                operationLabel.text = operation
    }
}

extension ConverterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBAction func didTapSwapCurrenciesButton(_ sender: UIButton) {
        let fromCurrencyPickerViewSelectedRow = fromCurrencyPickerView.selectedRow(inComponent: 0)
        
        fromCurrencyPickerView.selectRow(toCurrencyPickerView.selectedRow(inComponent: 0), inComponent: 0, animated: true)
        toCurrencyPickerView.selectRow(fromCurrencyPickerViewSelectedRow, inComponent: 0, animated: true)
//
//        let fromCurrencyRateValue = fromCurrencyRate
//        fromCurrencyRate = toCurrencyRate
//        toCurrencyRate = fromCurrencyRateValue
//
//        let fromCurrencyDescriptionLabelValue = fromCurrencyDescriptionLabel.text
//        fromCurrencyDescriptionLabel.text = toCurrencyDescriptionLabel.text
//        toCurrencyDescriptionLabel.text = fromCurrencyDescriptionLabelValue
//
//        updateToCurrencyRateLabelText()
        calculate()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Currencies.shared.entries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Currencies.shared.entries[row].isoCode
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
            pickerLabel?.textColor = UIColor.white
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        pickerLabel?.text = currencyPath[row].isoCode
        return pickerLabel!
    }
    
    func calculate() {
        if fromCurrencyPickerViewPosition != 0 && toCurrencyPickerViewPosition != 0 {
            let operation = rateCalculation() * (fromCurrencyAmountLabel.text?.asDouble())!
            toCurrencyAmountLabel!.text = String(format: "%.2f", operation)
        }
    }
    
    func rateCalculation() -> Double {
        return currencyPath[toCurrencyPickerViewPosition].dayRate/currencyPath[fromCurrencyPickerViewPosition].dayRate
    }
    
    func updateToCurrencyRateLabelText() {
        if currencyPath[fromCurrencyPickerViewPosition].dayRate != 0.0 {
            fromCurrencyRateLabel.text = "1.00"
        }
        if currencyPath[toCurrencyPickerViewPosition].dayRate != 0.0 {
            if currencyPath[fromCurrencyPickerViewPosition].dayRate == 0.0 {
                toCurrencyRateLabel.text = "Choisir une devise de référence ▲"
            } else {
                toCurrencyRateLabel.text = String(format: "%.3f", rateCalculation())
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            fromCurrencyPickerViewPosition = pickerView.selectedRow(inComponent: 0)
        } else {
            toCurrencyPickerViewPosition = pickerView.selectedRow(inComponent: 0)
        }
//
//        if pickerView.tag == 0 {
//            fromCurrencyRate = choosenCurrency.dayRate
//            fromCurrencyDescriptionLabel.text = choosenCurrency.description
//        } else {
//            toCurrencyRate = choosenCurrency.dayRate
//            toCurrencyDescriptionLabel.text = choosenCurrency.description
//        }
//        if choosenCurrency.isoCode == "📍" {
//            pickerView.selectRow(1, inComponent: 0, animated: true)
//            self.pickerView(pickerView, didSelectRow: 1, inComponent: 0)
//            //            targetDescription?.text = "\(Currencies.shared.entries[1].description) 📍 FR"
//        } else if choosenCurrency.isoCode == "－－－" {
//            pickerView.selectRow(row+1, inComponent: 0, animated: true)
//            self.pickerView(pickerView, didSelectRow: row+1, inComponent: 0)
//        }
//        updateToCurrencyRateLabelText()
//        calculate()
    }
}

extension ConverterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
