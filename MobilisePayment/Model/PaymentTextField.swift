//
//  PaymentTextField.swift
//  MobilisePayment
//
//  Created by Mousa Alwaraki on 14/06/2023.
//

import Foundation
import UIKit

class PaymentTextField: UITextField {
    
    var type: PaymentFieldType!
    
    init(type: PaymentFieldType) {
        super.init(frame: .zero)
        self.type = type
        self.clearButtonMode = .whileEditing
    }
    
    var isValid: Bool {
        if !type.isRequired { return true }
        var value = text ?? ""
        
        if type == .cardNumber {
            value = value.replacingOccurrences(of: " ", with: "")
        }
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", type.regexValidation)
        return predicate.evaluate(with: value)
    }
    
    func borderIfInvalid(allowEmpty: Bool = false) {
        if allowEmpty && (text ?? "").isEmpty {
            layer.borderWidth = 0
        } else {
            layer.borderWidth = isValid ? 0 : 1
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
