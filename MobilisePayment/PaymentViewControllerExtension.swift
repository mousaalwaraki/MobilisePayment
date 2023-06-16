//
//  PaymentViewControllerExtension.swift
//  MobilisePayment
//
//  Created by Mousa Alwaraki on 16/06/2023.
//

import Foundation
import UIKit

extension PaymentViewController {
    
    // MARK: Navigation
    
    func navigate(to category: PaymentFieldCategory) {
        updatePaymentTransaction()
        showFields(for: category)
        prefillData()
        
        // hide back button if no previous categories
        setBackButtonVisibility(hidden: category.previousCategory == nil)
        
        // change title if no next categories
        primaryButton.setTitle(category.nextCategory == nil ? "Checkout" : "Next", for: .normal)
        setCorrectBackgroundColorForPrimaryButton()
    }
    
    @objc func navigateToPreviousCategory() {
        guard let previousCategory = currentCategory?.previousCategory else {
            // log error
            return
        }
        
        navigate(to: previousCategory)
    }
    
    @objc func handleCheckout() {
        showAlert(title: "Success", message: "Your purchase has been completed ✅")
    }
    
    // MARK: Payment Transaction
    
    func updatePaymentTransaction() {
        let fields = getPaymentTextFields()
        
        switch currentCategory {
        case .delivery:
            setDeliveryAddress(using: fields)
        case .billing:
            setBillingAddress(using: fields)
        case .card:
            setCard(using: fields)
        default:
            // log error
            break
        }
    }
    
    private func setDeliveryAddress(using fields: [PaymentTextField]) {
        guard let lineOne = fields.first(where: {$0.type == .deliveryLineOne})?.text,
              let city = fields.first(where: {$0.type == .deliveryCity})?.text,
              let postCode = fields.first(where: {$0.type == .deliveryPostCode})?.text else {
            return
        }
        
        let lineTwo = fields.first(where: {$0.type == .deliveryLineTwo})?.text
        let deliveryAddress = PaymentTransaction.Address(lineOne: lineOne, lineTwo: lineTwo, city: city, postCode: postCode)
        paymentTransaction.deliveryAddress = deliveryAddress
    }
    
    private func setBillingAddress(using fields: [PaymentTextField]) {
        guard let lineOne = fields.first(where: {$0.type == .billingLineOne})?.text,
              let city = fields.first(where: {$0.type == .billingCity})?.text,
              let postCode = fields.first(where: {$0.type == .billingPostCode})?.text else {
            return
        }
        
        let lineTwo = fields.first(where: {$0.type == .billingLineTwo})?.text
        let billingAddress = PaymentTransaction.Address(lineOne: lineOne, lineTwo: lineTwo, city: city, postCode: postCode)
        paymentTransaction.billingAddress = billingAddress
    }
    
    private func setCard(using fields: [PaymentTextField]) {
        guard let cardNumber = fields.first(where: {$0.type == .cardNumber})?.text,
              let expiryDate = fields.first(where: {$0.type == .expiryDate})?.text,
              let cvv = fields.first(where: {$0.type == .CVV})?.text else {
            return
        }
        
        let card = PaymentTransaction.Card(cardNumber: cardNumber, expiryDate: expiryDate, cvv: cvv)
        paymentTransaction.cardDetails = card
    }
    
    // MARK: Progress View
    
    private func updateProgressValue() {
        guard let currentCategory = currentCategory else {
            //log error
            return
        }
        
        let categories = PaymentFieldCategory.allCases
        let index = Float(categories.firstIndex(of: currentCategory) ?? 0) + 1
        let total = Float(categories.count)
        
        let value = index/total
        progressView.setProgress(value, animated: true)
    }
    
    // MARK: Stack View
    
    private func showFields(for category: PaymentFieldCategory) {
        stackView.subviews.forEach({$0.removeFromSuperview()})
        self.currentCategory = category
        secondaryButton.isHidden = !(currentCategory == PaymentFieldCategory.billing)
        addCheckoutFields(for: category)
        updateProgressValue()
    }
    
    private func addCheckoutFields(for category: PaymentFieldCategory) {

        addHeader(with: category.header)

        for type in category.fieldTypes {
            addCheckoutField(of: type)
        }
    }
    
    private func addHeader(with text: String, showSpacing: Bool = true) {

        stackView.addSpacing(16)

        let headerLabel = UILabel()
        headerLabel.text = text.uppercased()
        headerLabel.textColor = .lightGray
        headerLabel.textAlignment = .left
        headerLabel.font = UIFont.systemFont(ofSize: 12)
        stackView.addArrangedSubview(headerLabel)
    }
    
    private func addCheckoutField(of type: PaymentFieldType) {
        let textField = PaymentTextField(type: type)

        textField.placeholder = type.placeholder
        textField.keyboardType = type.keyboardType
        textField.textContentType = type.contentType

        textField.delegate = self
        textField.layer.borderColor = UIColor.systemRed.cgColor
        textField.backgroundColor = .systemGray6
        textField.constraintHeight(to: 40)
        textField.borderStyle = .roundedRect
        stackView.addArrangedSubview(textField)
    }
    
    // MARK: Primary Button
    
    func setCorrectBackgroundColorForPrimaryButton() {
        let fields = getPaymentTextFields()
        let invalidFields = fields.filter({!$0.isValid})
        primaryButton.backgroundColor = invalidFields.isEmpty ? .systemBlue : .lightGray
    }
    
    @objc func tappedPrimaryButton() {
        let fields = getPaymentTextFields()
        let invalidFields = fields.filter({!$0.isValid})
        
        guard invalidFields.isEmpty else {
            invalidFields.forEach({$0.borderIfInvalid()})
            showAlert(title: "Error", message: "Please correct invalid fields")
            return
        }
        
        if let nextCategory = currentCategory?.nextCategory {
            navigate(to: nextCategory)
        } else {
            handleCheckout() // checkout if no more categories
        }
    }
    
    private func setBackButtonVisibility(hidden: Bool) {
        guard let navigationItem = navigationBar.items?.first else {
            // log no navigation item
            return
        }
        
        if hidden {
            navigationItem.leftBarButtonItem = nil
            navigationBar.setItems([navigationItem], animated: false)
        } else {
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(navigateToPreviousCategory))
            navigationItem.setLeftBarButton(backButton, animated: true)
            navigationBar.setItems([navigationItem], animated: false)
        }
    }
    
    // MARK: Payment Fields
    
    @objc func prefillData() {
        let fields = getPaymentTextFields()
        for field in fields {
            let fieldType = field.type
            switch fieldType {
            case .deliveryLineOne:
                field.text = paymentTransaction.deliveryAddress?.lineOne
            case .deliveryLineTwo:
                field.text = paymentTransaction.deliveryAddress?.lineTwo
            case .deliveryCity:
                field.text = paymentTransaction.deliveryAddress?.city
            case .deliveryPostCode:
                field.text = paymentTransaction.deliveryAddress?.postCode
            case .billingLineOne:
                field.text = paymentTransaction.billingAddress?.lineOne
            case .billingLineTwo:
                field.text = paymentTransaction.billingAddress?.lineTwo
            case .billingCity:
                field.text = paymentTransaction.billingAddress?.city
            case .billingPostCode:
                field.text = paymentTransaction.billingAddress?.postCode
            case .cardNumber:
                field.text = paymentTransaction.cardDetails?.cardNumber
            case .expiryDate:
                field.text = paymentTransaction.cardDetails?.expiryDate
            case .CVV:
                field.text = paymentTransaction.cardDetails?.cvv
            case .none:
                // log error
                break
            }
        }
    }
    
    @objc func fillBillingFromDelivery() {
        let fields = getPaymentTextFields()
        for field in fields {
            let fieldType = field.type
            switch fieldType {
            case .billingLineOne:
                field.text = paymentTransaction.deliveryAddress?.lineOne
            case .billingLineTwo:
                field.text = paymentTransaction.deliveryAddress?.lineTwo
            case .billingCity:
                field.text = paymentTransaction.deliveryAddress?.city
            case .billingPostCode:
                field.text = paymentTransaction.deliveryAddress?.postCode
            default:
                // log error
                break
            }
        }
        setCorrectBackgroundColorForPrimaryButton()
    }
    
    func getPaymentTextFields() -> [PaymentTextField] {
        return stackView.subviews.filter({$0 is PaymentTextField}) as? [PaymentTextField] ?? []
    }
}

extension PaymentViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let paymentTextField = textField as? PaymentTextField else {
            return
        }
        
        paymentTextField.borderIfInvalid(allowEmpty: true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setCorrectBackgroundColorForPrimaryButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let paymentTextField = textField as? PaymentTextField,
              paymentTextField.type == .expiryDate else {
            return true
        }
        
        if textField.text?.count == 1 && string.count == 1 {
            textField.text?.append("\(string)/")
            return false
        } else if textField.text?.count == 3 && string.isEmpty {
            let substring = textField.text?.dropLast(2) ?? ""
            textField.text = String(substring)
            return false
        }
        
        return true
    }
}
