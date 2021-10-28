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
    
    @IBOutlet private weak var overAllView: UIView!
    @IBOutlet private weak var blurOverShareView: UIView!
    @IBOutlet private weak var centerShareView: UIView!
    
    @IBOutlet private weak var tabBarBlurVisualEffectView: UIVisualEffectView!
    
    @IBOutlet private weak var firstCurrencyPickerView: UIPickerView!
    @IBOutlet private weak var secondCurrencyPickerView: UIPickerView!
    
    @IBOutlet private weak var firstCurrencyDescriptionLabel: UILabel!
    @IBOutlet private weak var firstCurrencyAmountLabel: UILabel!
    
    @IBOutlet private weak var secondCurrencyDescriptionLabel: UILabel!
    @IBOutlet private weak var secondCurrencyRateLabel: UILabel!
    @IBOutlet private weak var secondCurrencyAmountLabel: UILabel!
    
    @IBOutlet private weak var ticketView: UIView!
    
    @IBOutlet private weak var ticketDateTimeLabel: UILabel!
    @IBOutlet private weak var ticketCurrencyUnitRateLabel: UILabel!
    
    @IBOutlet private weak var ticketFirstCurrencyIsoLabel: UILabel!
    @IBOutlet private weak var ticketFirstCurrencyAmountLabel: UILabel!
    @IBOutlet private weak var ticketFirstCurrencyDescriptionLabel: UILabel!
    
    @IBOutlet private weak var ticketSecondCurrencyIsoLabel: UILabel!
    @IBOutlet private weak var ticketSecondCurrencyAmountLabel: UILabel!
    @IBOutlet private weak var ticketSecondCurrencyDescriptionLabel: UILabel!
    
    @IBOutlet private weak var refreshRatesButton: UIButton!
    @IBOutlet private weak var refreshRatesActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Interface Builder - Actions
    
    @IBAction private func didTapNumberButton(_ sender: UIButton) {
        hapticManager.triggerVibration(.numbersAndSymbolButtons)
        
        guard let entry = sender.title(for: .normal) else { return }
        setDelegateNumberOrSymbol(entry)
    }
    
    
    @IBAction private func didTapACButton(_ sender: UIButton) {
        hapticManager.triggerVibration(.acResetButton)
        //        resetAmounts()
    }
    
    @IBAction private func didTapSwapCurrenciesButton(_ sender: UIButton) {
        hapticManager.triggerVibration(.calcScreenButtons)
        swapCurrencies()
    }
    
    @IBAction private func didTapGetTicketButton(_ sender: UIButton) {
        hapticManager.triggerVibration(.calcScreenButtons)
        guard !amountToConvertIsZero else { return }
        //        getTicket()
    }
    
    @IBAction private func didSwipeUpTicketGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
        shareTicket()
    }
    
    @IBAction private func didSwipeDownTicketGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
        cancelTicketToShare()
    }
    
    @IBAction private func didTapCopyInClipboardButton(_ sender: UIButton) {
        hapticManager.triggerVibration(.calcScreenButtons)
        copyTicketInClipboard()
    }
    
    @IBAction private func didTapRefreshCurrenciesRatesButton(_ sender: UIButton) {
        hapticManager.triggerVibration(.calcScreenButtons)
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
        
        ticketView.layer.shadowColor = Color.shared.darkConverterColor.cgColor
        
        firstCurrencyPickerView.delegate = self
        secondCurrencyPickerView.delegate = self

        converterManager.delegate = self
        
        
        //        userDefaults.set([1,2], forKey: "currencyPickerViewsPosition")
        //        getCurrencyPickerViewsPosition()
        //        updateCurrenciesData()
        //        resetCalculation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updatePickerViewsRow()
        getDelegateCurrencyInformations()
        
        self.currentDateLabel.text = DateManager.shared.refreshDate()
    }
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard
    
    private let currencyPath = Currencies.shared.entries
    
    private let dateManager = DateManager.shared
    
    private let soundManager = SoundManager.shared
    
    private let hapticManager = HapticManager.shared
    
    private let converterManager = ConverterManager()
    
    private var lastUpdatedPickerView: CurrencyNumber = .firstAndSecond
    
    private var currencyPickerViewRows: [CurrencyNumber: Int] = [.first: 0, .second: 1] {
        didSet {
            getDelegateCurrencyInformations()
        }
    }
    
    private var amountToConvertIsZero: Bool {
        guard firstCurrencyAmountLabel.text?.asDouble() != 0 else { return false }
        return true
    }
    
    // MARK: - Methods
    
    
    
    private func shareTicket() {
        UIView.animate(withDuration: 0.33) { [self] in
            ticketView.frame.origin.y = 0 - ticketView.frame.height
            soundManager.play(.Woop)
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
    
    private func cancelTicketToShare() {
        UIView.animate(withDuration: 0.33) { [self] in
            ticketView.frame.origin.y = view.frame.size.height + 37
            soundManager.play(.Woop)
        }
        UIView.animate(withDuration: 0.25) { [self] in
            blurOverShareView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { [self] in
            soundManager.play(.Paper)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            overAllView.alpha = 0
        }
    }
    
    private func copyTicketInClipboard() {
        
        //        if converterHasAResult() {
        //            self.popUpAlert(title: "COPIÉ ✔︎", message: "Résultat dans le presse-papier.", asActionSheet: false, autoDismissTime: 2.0)
        //            UIPasteboard.general.string = getStringOfAmountCalculation()
        //        } else {
        //            self.popUpAlert(title: "Copie / presse-papier", message: "Veuillez indiquer UN MONTANT\npour pouvoir copier\nle résultat de la conversion\ndans le presse-papier.", asActionSheet: false, autoDismissTime: 0.0)
        //        }
    }
    
    private func checkPickerViewsViability() {
        if currencyPickerViewRows[.first] == currencyPickerViewRows[.second] {
            
        }
    }
    
    
//        private func updateCurrenciesInformations(forPickerView: String) {
//            checkPickerViewsViability()
//            converterManager.getCurrenciesInformations(first: first, second: second, forCurrency: currency)
//
//        }
    
    private func updatePickerViewsRow() {
        guard let firstPicker = currencyPickerViewRows[.first],
              let secondPicker = currencyPickerViewRows[.second]
        else { return }
        
        self.firstCurrencyPickerView.selectRow(firstPicker, inComponent: 0, animated: true)
        self.secondCurrencyPickerView.selectRow(secondPicker, inComponent: 0, animated: true)
        getDelegateCurrencyInformations()
    }
    
    private func swapCurrencies() {
        let firstRow = currencyPickerViewRows[.first]
        currencyPickerViewRows[.first] = currencyPickerViewRows[.second]
        currencyPickerViewRows[.second] = firstRow
        lastUpdatedPickerView = .firstAndSecond
        updatePickerViewsRow()
    }
    
    private func getDelegateCurrencyInformations() {
        let firstCurrency = currencyPickerViewRows[.first]!
        let secondCurrency = currencyPickerViewRows[.second]!
        converterManager.getCurrencyInformations(forCurrency: lastUpdatedPickerView, first: firstCurrency, second: secondCurrency)
    }
    
    private func setDelegateNumberOrSymbol(_ entry: String) {
        converterManager.addNumberOrSymbol(entry)
    }
}

// MARK: - Extensions

extension ConverterViewController: ConverterManagerDelegate {
    func setInformations(forCurrency currencyNumber: CurrencyNumber, description: String, convertingRate: String) {
        switch currencyNumber {
        case .first:
            self.firstCurrencyDescriptionLabel.text = description
        case .second:
            self.secondCurrencyDescriptionLabel.text = description
        default:
            return
        }
        self.secondCurrencyRateLabel.text = convertingRate
    }
    
    func setAmountsForCurrencies(first firstAmount: String, second secondAmount: String) {
        self.firstCurrencyAmountLabel.text = firstAmount
        self.secondCurrencyAmountLabel.text = secondAmount
        self.ticketFirstCurrencyAmountLabel.text = firstAmount
        self.ticketSecondCurrencyAmountLabel.text = secondAmount
    }
    
    func setTicketInformations(date: String, currencyRateToConvert: String, firstIso: String, firstDescription: String, secondIso: String, secondDescription: String) {
        self.ticketDateTimeLabel.text = date
        self.ticketCurrencyUnitRateLabel.text = "1 \(firstIso) = \(currencyRateToConvert) \(secondIso)"
        self.ticketFirstCurrencyIsoLabel.text = firstIso
        self.ticketSecondCurrencyIsoLabel.text = secondIso
        self.ticketFirstCurrencyDescriptionLabel.text = firstDescription
        self.ticketSecondCurrencyDescriptionLabel.text = secondDescription
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
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
        pickerLabel.textColor = UIColor.white
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.text = getPickerLabelText(forRow: row)
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencyNumber = getCurrencyNumber(forPickerTag: pickerView.tag)
        currencyPickerViewRows[currencyNumber] = row
        lastUpdatedPickerView = currencyNumber
    }
    
    private func getPickerLabelText(forRow row: Int) -> String {
        var pickerRowLabel = currencyPath[row].isoCode
        if currencyPath[row].isoSymbol != "" {
            pickerRowLabel = currencyPath[row].isoSymbol
        }
        return pickerRowLabel
    }
    
    private func getCurrencyNumber(forPickerTag tag: Int) -> CurrencyNumber {
        var pickerViewNumber: CurrencyNumber = .first
        if tag == 1 {
            pickerViewNumber = .second
        }
        return pickerViewNumber
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
