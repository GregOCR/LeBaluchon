//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

// comment utiliser CoreData et UserDefault, quand utiliser l'un ou l'autre ?
// bug entry calc > bad

import UIKit

class ConverterViewController: UIViewController {
    
    // MARK: - INTERFACE BUILDER (IB)
    
    // MARK: Interface Builder - Outlets
    
    @IBOutlet private weak var currentDateLabel: UILabel!
    
    @IBOutlet private weak var ticketDateTimeLabel: UILabel!
    @IBOutlet private weak var ticketChangeLabel: UILabel!
    
    @IBOutlet private weak var blurOverShareView: UIView!
    @IBOutlet private weak var centerShareView: UIView!
    @IBOutlet private weak var tabBarBlurVisualEffectView: UIVisualEffectView!
    
    @IBOutlet private weak var ticketView: UIView!
    @IBOutlet private weak var overAllView: UIView!
    
    @IBOutlet private var currencyPickerViews: [UIPickerView]!
    
    @IBOutlet private var currencyDescriptionLabels: [UILabel]!
    @IBOutlet private var currencyAmountLabels: [UILabel]!
    @IBOutlet private var currencyRateLabels: [UILabel]!
    
    @IBOutlet private var ticketCurrencyISOLabels: [UILabel]!
    @IBOutlet private var ticketCurrencyAmountLabels: [UILabel]!
    @IBOutlet private var ticketCurrencyDescriptionLabels: [UILabel]!
    
    @IBOutlet weak var refreshRatesButton: UIButton!
    @IBOutlet weak var refreshRatesActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Interface Builder - Actions
    
    @IBAction private func didTapNumberButton(_ sender: UIButton) {
        Vibration.For.numbersAndDotButtons.perform()
        
        guard let entry = sender.title(for: .normal) else { return }
        
        if amountToConvert == "0" {
            if entry != "." {
                amountToConvert = entry
            } else {
                amountToConvert = "0."
            }
        } else {
            if entry == "." {
                if !amountToConvert.contains(".") {
                    amountToConvert += entry
                }
                return
            }
            guard !amountToConvertIsComplete() else { return }
            amountToConvert += entry
        }
    }
    
    func amountToConvertIsComplete() -> Bool {
        var result = false
        if amountToConvert.contains(".") {
            let dotSplitAmount = amountToConvert.split(separator: ".")
            // if amount to convert is 2 numbers after coma, return amountToConvert is complete
            if dotSplitAmount.count == 2 && dotSplitAmount.last?.count == 2 {
                result = true
            }
        } else {
            guard amountToConvert.count < 8 else { return true }
        }
        return result
    }
    
    @IBAction private func didTapSwapCurrenciesButton(_ sender: UIButton) {
        currencyPickerViewsPosition.swapAt(0, 1)
    }
    
    @IBAction private func didTapACButton(_ sender: UIButton) {
        Vibration.For.acResetButton.perform()
        resetCalculation()
    }
    
    @IBAction private func didTapGetTicketButton(_ sender: UIButton) {
        if converterHasAResult() {
            updateTicketData()
            overAllView.alpha = 1
            UIView.animate(withDuration: 1.25) { [self] in
                ticketView.frame.origin.y = centerShareView.frame.origin.y + 20
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [self] in
                UIView.animate(withDuration: 0.25) { [self] in
                    blurOverShareView.alpha = 1
                }
            }
            //            soundManager.play(.Printer)
        } else {
            self.popUpAlert(title: "Ticket", message: "Veuillez indiquer UN MONTANT\npour obtenir un ticket\ndu résultat de la conversion.", asActionSheet: false, autoDismissTime: 0.0)
        }
    }
    
    @IBAction private func didSwipeUpTicketGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.33) { [self] in
            ticketView.frame.origin.y = 0 - ticketView.frame.height
            //            soundManager.play(.Woop)
        }
        UIView.animate(withDuration: 0.25) { [self] in
            blurOverShareView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            shareTicket(asImage: renderImageTicket())
            overAllView.alpha = 0
            ticketView.frame.origin.y = view.frame.size.height
        }
    }
    
    @IBAction private func didSwipeDownTicketGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.33) { [self] in
            ticketView.frame.origin.y = view.frame.size.height + 37
            //            soundManager.play(.Woop)
        }
        UIView.animate(withDuration: 0.25) { [self] in
            blurOverShareView.alpha = 0
        }
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { [self] in
        //            soundManager.play(.Paper)
        //        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            overAllView.alpha = 0
        }
    }
    
    @IBAction private func didTapCopyInClipboardButton(_ sender: UIButton) {
        if converterHasAResult() {
            self.popUpAlert(title: "COPIÉ ✔︎", message: "Résultat dans le presse-papier.", asActionSheet: false, autoDismissTime: 2.0)
            UIPasteboard.general.string = getStringOfAmountCalculation()
        } else {
            self.popUpAlert(title: "Copie / presse-papier", message: "Veuillez indiquer UN MONTANT\npour pouvoir copier\nle résultat de la conversion\ndans le presse-papier.", asActionSheet: false, autoDismissTime: 0.0)
        }
    }
    
    @IBAction private func didTapRefreshCurrenciesRatesButton(_ sender: UIButton) {
        refreshRatesButton.alpha = 0
        refreshRatesActivityIndicator.alpha = 1
    }
    
    // MARK: - Overrided Methods
    
    // set the color of content status bar in white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaults.set([1,2], forKey: "currencyPickerViewsPosition")
        calculator.delegate = self
        ticketView.layer.shadowColor = Color.shared.darkConverterColor.cgColor
        getCurrencyPickerViewsPosition()
        updateCurrenciesData()
        resetCalculation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshDate()
    }
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard
    
    private let currencyPath = Currencies.shared.entries
    
    private let dateManager = DateManager.shared
    private let soundManager = SoundManager.shared
    
    private let calculator = Calculator()
    
    private var amountToConvert = "0" {
        didSet {
            updateAmountToConvert()
            updateCalculation()
        }
    }
    
    private var currencyPickerViewsPosition = [1,2] {
        didSet {
            updateCurrenciesData()
            updateCalculation()
        }
    }
    
    // MARK: - Methods
    
    func updateCurrenciesData() {
        getCurrencyPickerViewsPosition()
        getCurrenciesData()
    }
    
    func getCurrencyPickerViewsPosition() {
        for currencyPickerView in 0...1 {
            currencyPickerViews[currencyPickerView].selectRow(currencyPickerViewsPosition[currencyPickerView], inComponent: 0, animated: true)
        }
    }
    
    func getCurrenciesData() {
        getCurrencyDescriptions()
        getCurrencyRateToConvert()
    }
    
    func getCurrencyDescriptions() {
        for currencyPickerView in 0...1 {
            let currencyDescription = currencyPath[currencyPickerViewsPosition[currencyPickerView]].description
            currencyDescriptionLabels[currencyPickerView].text = currencyDescription
        }
    }
    
    func checkIfPickerViewPointerIsAllowed(forCurrencyPickerViewTag pickerTag: Int) {
        let pickerViewPointer = currencyPath[currencyPickerViewsPosition[pickerTag]].isoCode
        var pickerViewPosition = currencyPickerViewsPosition[pickerTag] {
            didSet {
                currencyPickerViewsPosition[pickerTag] = pickerViewPosition
            }
        }
        if pickerViewPointer == "📍" {
            pickerViewPosition = getPickerViewPositionForLocalizedCountryCurrency()
        }
        if pickerViewPointer == "－－－" ||
            (currencyPickerViewsPosition.first == currencyPickerViewsPosition.last) {
            if pickerViewPosition == currencyPath.count-1 {
                pickerViewPosition -= 1
            } else {
                pickerViewPosition += 1
            }
            checkIfPickerViewPointerIsAllowed(forCurrencyPickerViewTag: pickerTag)
        }
    }
    // get the currency of the current localized country
    func getPickerViewPositionForLocalizedCountryCurrency() -> Int {
        return 1
    }
    
    func converterHasAResult() -> Bool {
        guard amountToConvert != "0" else { return false }
        return true
    }
    
    func updateAmountToConvert() {
        print(amountToConvert)
        currencyAmountLabels.first?.text = String(format: "%.2f", amountToConvert.asDouble())
    }
    
    func resetCalculation() {
        amountToConvert = "0"
    }
    
    func getIsoCode(_ isoCode: String) -> String {
        var result: String
        switch isoCode {
        case "€€€": result = "EUR"
        case "$$$": result = "USD"
        case "£££": result = "GBP"
        case "¥¥¥": result = "YEN"
        default: result = isoCode.description
        }
        return result
    }
    
    func getCurrencyIsoCode(forPickerView pickerView: Int) -> String {
        return getIsoCode(currencyPath[currencyPickerViewsPosition[pickerView]].isoCode)
    }
    
    private func updateTicketData() {
        ticketDateTimeLabel.text = dateManager.getFormattedDate(.CurrentUTCTime)
        ticketChangeLabel.text = "1 \(getCurrencyIsoCode(forPickerView: 0)) = \(String(format: "%.3f", rateCalculation())) \(getCurrencyIsoCode(forPickerView: 1))"
        for position in 0...1 {
            ticketCurrencyISOLabels[position].text = getCurrencyIsoCode(forPickerView: position)
            ticketCurrencyAmountLabels[position].text = currencyAmountLabels[position].text
            ticketCurrencyDescriptionLabels[position].text = currencyDescriptionLabels[position].text
        }
    }
    
    func refreshDate() {
        currentDateLabel.text = dateManager.getFormattedDate(.FullCurrentDate).uppercased()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.currentDateLabel.text = self.dateManager.getFormattedDate(.FullCurrentDate).uppercased()
        }
    }
    
    func updateCalculation() {
        if amountToConvert == "0" {
            currencyAmountLabels.last?.text = "0.00"
            return
        } else {
            let convertedAmount = rateCalculation() * amountToConvert.asDouble()
            currencyAmountLabels.last?.text = String(format: "%.2f", convertedAmount)
        }
    }
    
    func rateCalculation() -> Double {
        return currencyPath[currencyPickerViews[1].selectedRow(inComponent: 0)].dayRate/currencyPath[currencyPickerViews[0].selectedRow(inComponent: 0)].dayRate
    }
    
    func getCurrencyRateToConvert() {
        if currencyPath[currencyPickerViewsPosition.first!].dayRate != 0.0 {
            currencyRateLabels.first?.text = "1.00"
        }
        if currencyPath[currencyPickerViewsPosition.last!].dayRate != 0.0 {
            if currencyPath[currencyPickerViewsPosition.first!].dayRate == 0.0 {
                currencyRateLabels.last?.text = "Choisir une devise de référence ▲"
            } else {
                currencyRateLabels.last?.text = String(format: "%.3f", rateCalculation())
            }
        }
    }
    
    func getStringOfAmountCalculation() -> String {
        return "\(amountToConvert) \(getCurrencyIsoCode(forPickerView: 0)) (\(String(describing: currencyDescriptionLabels[0].text!))) = \(String(describing: currencyAmountLabels[1].text!)) \(getCurrencyIsoCode(forPickerView: 1)) (\(String(describing: currencyDescriptionLabels[1].text!)))\n\n1 \(getCurrencyIsoCode(forPickerView: 0)) = \(String(format: "%.3f", rateCalculation())) \(getCurrencyIsoCode(forPickerView: 1))\nSource : fixer.io • \(dateManager.getFormattedDate(.CurrentUTCTime))"
    }
}

// MARK: - Extensions

extension ConverterViewController: CalculatorProtocol {
    func didUpdateOperation(operation: String) {
        //        operationLabel.text = operation
    }
}

extension ConverterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Currencies.shared.entries.count
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyPickerViewsPosition[pickerView.tag] = pickerView.selectedRow(inComponent: 0)
        checkIfPickerViewPointerIsAllowed(forCurrencyPickerViewTag: pickerView.tag)
    }
}

extension ConverterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func renderImageTicket() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: ticketView.bounds.size)
        let image = renderer.image { ctx in
            ticketView.backgroundColor = UIColor.clear
            ticketView.drawHierarchy(in: ticketView.bounds, afterScreenUpdates: true)
        }
        return image
    }
    private func shareTicket(asImage uiImage:UIImage?) {
        
        var elementsToShare = [UIImage]()
        
        if let sharedImageElements = uiImage {
            elementsToShare.append(sharedImageElements)
        }
        if uiImage != nil {
            let activityViewController = UIActivityViewController(activityItems: elementsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        }
    }
}
