//
//  PaymentViewControllerTests.swift
//  MobilisePaymentTests
//
//  Created by Mousa Alwaraki on 16/06/2023.
//

import XCTest
@testable import MobilisePayment

final class PaymentViewControllerTests: XCTestCase {
    
    var sut: PaymentViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PaymentViewController()
        sut.viewDidLoad()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_whenNavigatingToCategory_thenFieldsUpdated() {
        // given
        sut.navigate(to: .delivery)
        
        // when
        sut.navigate(to: .billing)
        
        // then
        let textFields = sut.getPaymentTextFields()
        
        for fieldType in PaymentFieldCategory.billing.fieldTypes {
            XCTAssertTrue(textFields.contains(where: {$0.type == fieldType}))
        }
    }
    
    func test_whenTappingOnPrimaryButtonInDeliveryCategory_thenCategoryChangesToBilling() {
        // given
        sut.navigate(to: .delivery)
        
        // when
        sut.tappedPrimaryButton()
        
        // then
        XCTAssertEqual(sut.currentCategory, .billing)
    }
    
    func test_whenTappingOnPrimaryButtonInBillingCategory_thenCategoryChangesToCard() {
        // given
        sut.navigate(to: .billing)
        
        // when
        sut.tappedPrimaryButton()
        
        // then
        XCTAssertEqual(sut.currentCategory, .card)
    }
    
    func test_whenTappingOnPrimaryButtonInCardCategory_thenCategoryDoesntChange() {
        // given
        sut.navigate(to: .card)
        
        // when
        sut.tappedPrimaryButton()
        
        // then
        XCTAssertEqual(sut.currentCategory, .card)
    }
    
    func test_whenFillingDeliveryFromBilling_thenAllFieldsFilledCorrectly() {
        // given
        sut.navigate(to: .billing)
        let deliveryAddress = PaymentTransaction.Address(lineOne: "1234", lineTwo: "Street", city: "London", postCode: "E16 2JJ")
        sut.paymentTransaction.deliveryAddress = deliveryAddress
        
        // when
        sut.fillBillingFromDelivery()
        sut.updatePaymentTransaction()
        
        // then
        XCTAssertEqual(sut.paymentTransaction.deliveryAddress, sut.paymentTransaction.billingAddress)
        XCTAssertEqual(deliveryAddress, sut.paymentTransaction.billingAddress)
    }
}
