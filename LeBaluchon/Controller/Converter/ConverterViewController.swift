//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

// comment utiliser coreLocation pour weather et converter
// comment garder la position du sélecteur pickerView lorsqu'on quitte l'app
// comment initialiser le soundManager pour éviter une latence dans la première animation
// comment refresh la liste 2 des devises avec la devise sélectionnée en liste 1 en moins
// comment échanger les listes (boutton swap arrows)
// comment récupérer la liste des devises possibles grâce à l'api fixer.io avec une description francaise et rajouter les ISO codes des pays pour chacun
// comment mettre le 🌍 toujours en première position, mais classer les autres devises par ordre alphabétique
// comment checker qd la vue de partage est en place
// comment avoid une ligne du pickerview
// que veux dire weak dans les iboutlet
// comment changer la font du datepicker


import UIKit
import CoreLocation

class ConverterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
            pickerLabel?.textColor = UIColor.white
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = Currencies.shared.entries[row].isoCode
        
        return pickerLabel!
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var targetDescriptionLabelText = fromCurrencyDescriptionLabel
        var targetRateLabelText = fromCurrencyRateLabel
        
        if pickerView.tag == 1 {
            targetDescriptionLabelText = toCurrencyDescriptionLabel
            targetRateLabelText = toCurrencyRateLabel
        }
        
        targetDescriptionLabelText?.text = Currencies.shared.entries[row].description
        targetRateLabelText?.text = String(Currencies.shared.entries[row].dayRate)
        
        if Currencies.shared.entries[row].isoCode == "📍" {
            targetDescriptionLabelText?.text = "Géolocalisation du pays ..."
            self.pickerView(pickerView, didSelectRow: 2, inComponent: 0)
            pickerView.selectRow(1, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: 1, inComponent: 0)
            targetDescriptionLabelText?.text = "\(String(describing: targetDescriptionLabelText!.text!)) 📍 France"
            
        }
        calculate()
    }
    
    @IBOutlet weak var fromCurrencyPickerView: UIPickerView!
    @IBOutlet weak var toCurrencyPickerView: UIPickerView!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var fromCurrencyRateLabel: UILabel!
    @IBOutlet weak var fromCurrencyDescriptionLabel: UILabel!
    @IBOutlet weak var fromCurrencyAmountLabel: UILabel!
    @IBOutlet weak var toCurrencyDescriptionLabel: UILabel!
    @IBOutlet weak var toCurrencyAmountLabel: UILabel!
    @IBOutlet weak var toCurrencyRateLabel: UILabel!
    
    @IBOutlet weak var ticketDateTimeLabel: UILabel!
    @IBOutlet weak var ticketChangeLabel: UILabel!
    @IBOutlet weak var ticketFirstCurrencyShortLabel: UILabel!
    @IBOutlet weak var ticketFirstCurrencyAmountLabel: UILabel!
    @IBOutlet weak var ticketFirstCurrencyFullLabel: UILabel!
    @IBOutlet weak var ticketSecondCurrencyShortLabel: UILabel!
    @IBOutlet weak var secondCurrencyUnitAmountLabel: UILabel!
    @IBOutlet weak var ticketSecondCurrencyAmountLabel: UILabel!
    @IBOutlet weak var ticketSecondCurrencyFullLabel: UILabel!
    
    @IBOutlet weak var currencyDataDatePicker: UIDatePicker!
    
    @IBOutlet weak var ticketMaskView: UIView!
    @IBOutlet weak var shareTrashStackView: UIStackView!
    
    @IBOutlet weak var ticketView: UIView!
    
    @IBOutlet weak var overAllView: UIView!
    
    // set the color of content status bar in white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ticketView.layer.shadowColor = Color.shared.darkConverterColor.cgColor
        setDatePicker()
    }
    
    func setDatePicker() {
        currencyDataDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
//        currencyDataDatePicker.setValue(UIFont(name: "Arial Rounded MT Bold", size: 20), forKeyPath: "font")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshDate()
    }
    
    private let dateManager = DateManager.shared
    private let soundManager = SoundManager.shared
    
    private var fromCurrencyPickerViewPosition = 1
    private var toCurrencyPickerViewPosition = 0
    
    private var fromAmountBeforeComa = "0"
    private var fromAmountHasComa = false
    private var fromAmountAfterComa = "00"
    
    @IBAction func numberButtonTouchUpInside(_ sender: UIButton) {
        Vibration.For.numbersAndDotButtons.perform()
        guard let entry = sender.title(for: .normal) else {
            return
        }
        
        if entry == "." {
            fromAmountHasComa = true
            return
        }
        if fromAmountBeforeComa.count == 8 {
            fromAmountHasComa = true
        }
        
        if fromAmountHasComa == false {
            if fromAmountBeforeComa == "0" {
                fromAmountBeforeComa = "" + entry
            } else {
                fromAmountBeforeComa += entry
            }
        } else {
            fromAmountAfterComa = String(fromAmountAfterComa.dropFirst()) + entry
        }
    }
    
    @IBAction func acButtonTouchUpInside(_ sender: UIButton) {
        Vibration.For.acResetButton.perform()
        fromAmountBeforeComa = "0"
        fromAmountHasComa = false
        fromAmountAfterComa = "00"
        self.toCurrencyAmountLabel!.text = "0.00"
        self.fromCurrencyAmountLabel!.text = "\(fromAmountBeforeComa).\(fromAmountAfterComa)"
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5) { [self] in
            self.ticketView.frame.origin.y = -ticketMaskView.frame.height
            soundManager.play(.Woop)
            
        }
        UIView.animate(withDuration: 0.25) { [self] in
            self.overAllView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.ticketView.frame.origin.y = self.ticketMaskView.frame.height+20
            self.ticketMaskView.alpha = 0
            self.share(shareImage: self.captureTheTicket())
        }
    }
    
    @IBAction func swipeDownTicketAction(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.33) { [self] in
            self.ticketView.frame.origin.y = +ticketMaskView.frame.height+20
            soundManager.play(.Woop)
        }
        UIView.animate(withDuration: 0.25) { [self] in
            self.overAllView.alpha = 0.011
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            self.soundManager.play(.Paper)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            self.ticketView.frame.origin.y = self.ticketMaskView.frame.height+20
            self.overAllView.alpha = 0
            self.ticketMaskView.alpha = 0
        }
    }
    
    @IBAction func ticketShowUpButton(_ sender: Any) {
        //        self.updateTicketLabels()
        self.overAllView.alpha = 0.011
        self.ticketMaskView.alpha = 1
        
        UIView.animate(withDuration: 1.25) { [self] in
            ticketView.frame.origin.y = ticketMaskView.frame.height - ticketView.frame.height
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [self] in
            UIView.animate(withDuration: 0.25) { [self] in
                self.overAllView.alpha = 1
                ticketView.frame.origin.y = ticketMaskView.frame.origin.y + (shareTrashStackView.frame.size.height/2 - ticketView.frame.size.height/2)
            }
        }
        self.overAllView.appearWithDelay()
        soundManager.play(.Printer)
        
    }
    
    func calculate() {
        let coefficient = (1.0/Double(self.fromCurrencyRateLabel!.text!)!)*Double(self.fromCurrencyAmountLabel!.text!)!
        self.fromCurrencyAmountLabel!.text = "\(fromAmountBeforeComa).\(fromAmountAfterComa)"
        if Double(fromCurrencyAmountLabel!.text!) != 0.0 {
            self.toCurrencyAmountLabel!.text = String(format: "%.2f", Double(self.toCurrencyRateLabel!.text!)!*coefficient)
        }
    }
    
    func updateTicketLabels() {
        self.ticketDateTimeLabel.text = dateManager.getFormattedDate(.CurrentUTCTime)
        self.ticketFirstCurrencyFullLabel.text = self.fromCurrencyDescriptionLabel.text?.uppercased()
        self.ticketFirstCurrencyShortLabel.text = self.fromCurrencyPickerView.selectedRow(inComponent: fromCurrencyPickerViewPosition).description
        self.ticketFirstCurrencyAmountLabel.text = self.fromCurrencyAmountLabel.text
        self.ticketChangeLabel.text = "1 \(fromCurrencyAmountLabel.text!) = \(toCurrencyAmountLabel.text!) \(self.fromCurrencyPickerView.selectedRow(inComponent: toCurrencyPickerViewPosition).description)"
        self.ticketSecondCurrencyFullLabel.text = self.toCurrencyDescriptionLabel.text?.uppercased()
        self.ticketSecondCurrencyShortLabel.text = self.fromCurrencyPickerView.selectedRow(inComponent: toCurrencyPickerViewPosition).description
        self.ticketSecondCurrencyAmountLabel.text = self.toCurrencyAmountLabel.text
    }
    
    private func captureTheTicket() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.ticketView.bounds.size)
        let image = renderer.image { ctx in
            self.ticketView.backgroundColor = UIColor.clear
            self.ticketView.drawHierarchy(in: self.ticketView.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    func share(shareImage:UIImage?){
        
        var objectsToShare = [UIImage]()
        
        if let shareImageObj = shareImage {
            objectsToShare.append(shareImageObj)
        }
        
        if shareImage != nil{
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UIView {
    func appearWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5) {
                self.alpha = 1
            }
        }
    }
    func disappearWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1) {
                self.alpha = 0
            }
        }
    }
}
