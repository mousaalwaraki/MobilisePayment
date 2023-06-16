//
//  PaymentFieldType.swift
//  MobilisePayment
//
//  Created by Mousa Alwaraki on 14/06/2023.
//

import Foundation
import UIKit

enum PaymentFieldCategory: CaseIterable {
    case delivery
    case billing
    case card
    
    var fieldTypes: [PaymentFieldType] {
        switch self {
        case .delivery:
            return [.deliveryLineOne, .deliveryLineTwo, .deliveryCity, .deliveryPostCode]
        case .billing:
            return [.billingLineOne, .billingLineTwo, .billingCity, .billingPostCode]
        case .card:
            return [.cardNumber, .expiryDate, .CVV]
        }
    }
    
    var header: String {
        switch self {
        case .delivery:
            return "Delivery Address"
        case .billing:
            return "Billing Address"
        case .card:
            return "Card"
        }
    }
    
    var nextCategory: PaymentFieldCategory? {
        switch self {
        case .delivery:
            return .billing
        case .billing:
            return .card
        case .card:
            return nil
        }
    }
    
    var previousCategory: PaymentFieldCategory? {
        switch self {
        case .delivery:
            return nil
        case .billing:
            return .delivery
        case .card:
            return .billing
        }
    }
}

enum PaymentFieldType {
    case deliveryLineOne, deliveryLineTwo, deliveryCity, deliveryPostCode
    case billingLineOne, billingLineTwo, billingCity, billingPostCode
    case cardNumber, expiryDate, CVV
    
    var placeholder: String {
        switch self {
        case .deliveryLineOne:
            return "Line 1"
        case .deliveryLineTwo:
            return "Line 2"
        case .deliveryCity:
            return "City"
        case .deliveryPostCode:
            return "Post Code"
        case .billingLineOne:
            return "Line 1"
        case .billingLineTwo:
            return "Line 2"
        case .billingCity:
            return "City"
        case .billingPostCode:
            return "Post Code"
        case .cardNumber:
            return "Card Number"
        case .expiryDate:
            return "Expiry Date (mm/yy)"
        case .CVV:
            return "CVV"
        }
    }
    
    var contentType: UITextContentType? {
        switch self {
        case .deliveryLineOne:
            return .streetAddressLine1
        case .deliveryLineTwo:
            return .streetAddressLine2
        case .deliveryCity:
            return .addressCity
        case .deliveryPostCode:
            return .postalCode
        case .billingLineOne:
            return .streetAddressLine1
        case .billingLineTwo:
            return .streetAddressLine2
        case .billingCity:
            return .addressCity
        case .billingPostCode:
            return .postalCode
        case .cardNumber:
            return .creditCardNumber
        default:
            return nil
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .cardNumber, .CVV, .expiryDate:
            return .numberPad
        default:
            return .default
        }
    }
    
    var regexValidation: String {
        switch self {
        case .deliveryPostCode, .billingPostCode:
            return "^[A-z]{1,2}\\d[A-z\\d]? ?\\d[A-z]{2}$"
        case .cardNumber:
            return "^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$"
        default:
            return "(.|\\s)*\\S(.|\\s)*"
        }
    }
    
    var isRequired: Bool {
        switch self {
        case .deliveryLineTwo, .billingLineTwo:
            return false
        default:
            return true
        }
    }
}
