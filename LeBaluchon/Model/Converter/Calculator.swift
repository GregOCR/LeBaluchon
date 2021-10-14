//
//  Calculator.swift
//  LeBaluchon
//
//  Created by Greg on 07/10/2021.
//

import Foundation

protocol CalculatorProtocol: AnyObject {
    func didUpdateOperation(operation: String)
}

class Calculator {
    
    weak internal var delegate: CalculatorProtocol?
        
    var operation: String = "" {
        didSet {
            delegate?.didUpdateOperation(operation: operation)
        }
    }
    
    func addNumber(number: Int) {
        operation += number.description
    }
}
