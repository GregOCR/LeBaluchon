//
//  ConverterManager.swift
//  LeBaluchon
//
//  Created by Greg on 07/10/2021.
//

import Foundation

enum CurrencyNumber: String {
    case first = "first"
    case second = "second"
    case firstAndSecond = "firstAndSecond"

}

protocol ConverterManagerDelegate: AnyObject {
    func setAmountsForCurrencies(first: String, second: String)
    func setInformations(forCurrency: CurrencyNumber, description: String, convertingRate: String)
    func setTicketInformations(date: String, currencyRateToConvert: String, firstIso: String, firstDescription: String, secondIso: String, secondDescription: String)
}

class ConverterManager {

// MARK: - INTERNAL

    weak var delegate: ConverterManagerDelegate?

// MARK: Internal - Properties

//    var sourceCurrency: Currency?
//    var targetCurrency: Currency?
//
//    var conversionRate: Double? {
//        guard
//            let targetCurrency = targetCurrency,
//            let sourceCurrency = sourceCurrency else {
//            return nil
//        }
//        return targetCurrency.dayRate / sourceCurrency.dayRate
//    }

// MARK: Internal - Methods

//    func converterHasResult() -> Bool {
//        guard amountToConvert != "0" else { return false }
//        return true
//    }
    
    func getCurrencyInformations(forCurrency currencyNumber: CurrencyNumber, first: Int, second: Int) {
        if currencyNumber != .firstAndSecond {
            var currency = first
            if currencyNumber == .second {
                currency = second
            }
            delegate?.setInformations(forCurrency: currencyNumber, description: currencyPath[currency].description, convertingRate: getRateForCurrency(first: first, second: second))
        } else {
            delegate?.setInformations(forCurrency: currencyNumber, description: currencyPath[first].description, convertingRate: getRateForCurrency(first: first, second: second))
            delegate?.setInformations(forCurrency: currencyNumber, description: currencyPath[second].description, convertingRate: getRateForCurrency(first: first, second: second))
        }
        
   
    }
    
    private func getCurrenciesInformations() {
        
    }
    
    private func getRateForCurrency(first: Int, second: Int) -> String {
        return String(format: "%.3f", currencyPath[second].rate / currencyPath[first].rate)
    }
    
    func resetAmountToConvert() {
        amountToConvert = "0"
    }
    
    func addNumberOrSymbol(_ symbol: String) {
        
        if amountToConvert == "0" {
            if symbol != "." {
                amountToConvert = symbol
            } else {
                amountToConvert = "0."
            }
        } else {
            if symbol == "." {
                if !amountToConvert.contains(".") {
                    amountToConvert += symbol
                }
                return
            }
            guard !amountToConvertIsComplete() else { return }
            amountToConvert += symbol
        }
    }
    
    // MARK: - PRIVATE
    
    var amountToConvert = "0" {
        didSet {
            
        }
    }
    
//    func updateAmount() {
//        delegate?.getAmountsForCurrencies(first: amountToConvert, second: (amountToConvert*get))
//    }
    
    // MARK: Private - Properties
    
    let currencyPath = Currencies.shared.entries
    
//    private var amountToConvert = "0" {
//        didSet {
//            delegate?.didUpdate(amountToConvert: amountToConvert)
//            convert()
//        }
//    }
//    
//    private var convertedAmount = "0" {
//        didSet {
//            delegate?.didUpdate(convertedAmount: convertedAmount)
//        }
//    }
    
    // MARK: Private - Methods
    
//    func getStringOfAmountCalculation() -> String {
//        return "\(amountToConvert) \(getCurrencyIsoCode(forPickerView: 0)) (\(String(describing: currencyDescriptionLabels[0].text!))) = \(String(describing: currencyAmountLabels[1].text!)) \(getCurrencyIsoCode(forPickerView: 1)) (\(String(describing: currencyDescriptionLabels[1].text!)))\n\n1 \(getCurrencyIsoCode(forPickerView: 0)) = \(String(format: "%.3f", rateCalculation())) \(getCurrencyIsoCode(forPickerView: 1))\nSource : fixer.io • \(dateManager.getFormattedDate(.CurrentUTCTime))"
//    }
//    
//    private func updateTicketData() {
//        ticketDateTimeLabel.text = dateManager.getFormattedDate(.CurrentUTCTime)
//        ticketChangeLabel.text = "1 \(getCurrencyIsoCode(forPickerView: 0)) = \(String(format: "%.3f", rateCalculation())) \(getCurrencyIsoCode(forPickerView: 1))"
//        for position in 0...1 {
//            ticketCurrencyISOLabels[position].text = getCurrencyIsoCode(forPickerView: position)
//            ticketCurrencyAmountLabels[position].text = currencyAmountLabels[position].text
//            ticketCurrencyDescriptionLabels[position].text = currencyDescriptionLabels[position].text
//        }
//    }
//    func getIsoCode(_ isoCode: String) -> String {
//        var result: String
//        switch isoCode {
//        case "€€€": result = "EUR"
//        case "$$$": result = "USD"
//        case "£££": result = "GBP"
//        case "¥¥¥": result = "YEN"
//        default: result = isoCode.description
//        }
//        return result
//    }
//    private func convert() {
//        guard let conversionRate = conversionRate else {
//            convertedAmount = "ERROR"
//            return
//        }
//        convertedAmount = (conversionRate * amountToConvert.asDouble()).description
//    }
//    
//    func rateCalculation() -> Double {
//        let targetCurrency = currencyPath[targetCurrencySelectionIndex]
//        let sourceCurrency = currencyPath[sourceCurrencySelectionIndex]
//
//        return targetCurrency.dayRate / sourceCurrency.dayRate
//    }
//    
//    func getCurrencyRateToConvert() {
//        if currencyPath[currencyPickerViewsPosition.first!].dayRate != 0.0 {
//            currencyRateLabels.first?.text = "1.00"
//        }
//        if currencyPath[currencyPickerViewsPosition.last!].dayRate != 0.0 {
//            if currencyPath[currencyPickerViewsPosition.first!].dayRate == 0.0 {
//                currencyRateLabels.last?.text = "Choisir une devise de référence ▲"
//            } else {
//                currencyRateLabels.last?.text = String(format: "%.3f", rateCalculation())
//            }
//        }
//    }
//    
//    private func updateConvertedAmountLabel() {
//        if amountToConvert == "0" {
//            convertedAmountLabel?.text = "0.00"
//            return
//        } else {
//            let convertedAmount = rateCalculation() * amountToConvert.asDouble()
//            convertedAmountLabel?.text = String(format: "%.2f", convertedAmount)
//        }
//    }
    private func amountToConvertIsComplete() -> Bool {
        
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
//    
//    
//    func updateCurrenciesData() {
//        getCurrencyPickerViewsPosition()
//        getCurrenciesData()
//    }
//    
//    func getCurrencyPickerViewsPosition() {
//        for currencyPickerView in 0...1 {
//            currencyPickerViews[currencyPickerView].selectRow(currencyPickerViewsPosition[currencyPickerView], inComponent: 0, animated: true)
//        }
//    }
//    
//    func getCurrenciesData() {
//        getCurrencyDescriptions()
//        getCurrencyRateToConvert()
//    }
//    
//    func getCurrencyDescriptions() {
//        for currencyPickerView in 0...1 {
//            let currencyDescription = currencyPath[currencyPickerViewsPosition[currencyPickerView]].description
//            currencyDescriptionLabels[currencyPickerView].text = currencyDescription
//        }
//    }
//    
//    func checkIfPickerViewPointerIsAllowed(forCurrencyPickerViewTag pickerTag: Int) {
//        let pickerViewRow = currencyPath[currencyPickerViewsPosition[pickerTag]].isoCode
//        var pickerViewRowPosition = currencyPickerViewsPosition[pickerTag] {
//            didSet {
//                currencyPickerViewsPosition[pickerTag] = pickerViewRowPosition
//            }
//        }
//
//        if pickerViewRow == "－－－" ||
//            (currencyPickerViewsPosition.first == currencyPickerViewsPosition.last) {
//            if pickerViewRowPosition == currencyPath.count-1 {
//                pickerViewRowPosition -= 1
//            } else {
//                pickerViewRowPosition += 1
//            }
//            checkIfPickerViewPointerIsAllowed(forCurrencyPickerViewTag: pickerTag)
//        }
//    }
//    // get the currency of the current localized country
//    func getPickerViewPositionForLocalizedCountryCurrency() -> Int {
//        return 1
//    }
//    
//    private func updateAmountToConvertLabel(amountToConvert: String) {
//        currencyAmountLabels.first?.text = String(format: "%.2f", amountToConvert.asDouble())
//    }
//    
//    
//    func getCurrencyIsoCode(forPickerView pickerView: Int) -> String {
//        return getIsoCode(currencyPath[currencyPickerViewsPosition[pickerView]].isoCode)
//    }
//    
//    func refreshDate() {
//        currentDateLabel.text = dateManager.getFormattedDate(.FullCurrentDate).uppercased()
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            self.currentDateLabel.text = self.dateManager.getFormattedDate(.FullCurrentDate).uppercased()
//        }
//    }
//    
//    private var convertedAmountLabel: UILabel? {
//        currencyAmountLabels.last
//    }
//    
//    private var targetCurrencyPicker: UIPickerView {
//        currencyPickerViews[1]
//    }
//    
//    private var sourceCurrencyPicker: UIPickerView {
//        currencyPickerViews[0]
//    }
//    
}
