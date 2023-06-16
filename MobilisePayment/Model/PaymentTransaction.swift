//
//  PaymentTransaction.swift
//  MobilisePayment
//
//  Created by Mousa Alwaraki on 16/06/2023.
//

import Foundation

struct PaymentTransaction {
    struct Address: Equatable {
        var lineOne: String
        var lineTwo: String?
        var city: String
        var postCode: String
    }
    
    struct Card {
        var cardNumber: String
        var expiryDate: String
        var cvv: String
    }
    
    var deliveryAddress: Address?
    var billingAddress: Address?
    var cardDetails: Card?
}
