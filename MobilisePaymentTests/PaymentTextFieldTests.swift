//
//  PaymentTextFieldTests.swift
//  MobilisePaymentTests
//
//  Created by Mousa Alwaraki on 14/06/2023.
//

import XCTest
@testable import MobilisePayment

final class PaymentTextFieldTests: XCTestCase {
    
    var sut: PaymentTextField!
    
    override class func setUp() {
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_whenPostCodeWithoutSpacing_thenValid() {
        // given
        sut = PaymentTextField(type: .deliveryPostCode)
        
        // when
        sut.text = "E162JJ"
        
        // then
        XCTAssertTrue(sut.isValid)
    }
    
    func test_whenPostCodeWithSpacing_thenValid() {
        // given
        sut = PaymentTextField(type: .deliveryPostCode)
        
        // when
        sut.text = "E16 2JJ"
        
        // then
        XCTAssertTrue(sut.isValid)
    }
    
    func test_whenPostCodeWithExtraSpacing_thenInvalid() {
        // given
        let postCodeField = PaymentTextField(type: .deliveryPostCode)

        // when
        postCodeField.text = "E16 2 J J"

        // then
        XCTAssertFalse(postCodeField.isValid)
    }

    func test_whenPostCodeIsEmpty_thenInvalid() {
        // given
        let postCodeField = PaymentTextField(type: .deliveryPostCode)

        // when
        postCodeField.text = ""

        // then
        XCTAssertFalse(postCodeField.isValid)
    }

    func test_whenPostCodeIsFourDigits_thenInvalid() {
        // given
        let postCodeField = PaymentTextField(type: .deliveryPostCode)

        // when
        postCodeField.text = "abcd"

        // then
        XCTAssertFalse(postCodeField.isValid)
    }

    func test_whenPostCodeIsNumerical_thenInvalid() {
        // given
        let postCodeField = PaymentTextField(type: .deliveryPostCode)

        // when
        postCodeField.text = "123"

        // then
        XCTAssertFalse(postCodeField.isValid)
    }
    
    func test_whenCardNumberValidNoSpacing_thenValid() {
        // given
        let cardNumberField = PaymentTextField(type: .cardNumber)
        
        // when
        cardNumberField.text = "4111111111111111"
        
        // then
        XCTAssertTrue(cardNumberField.isValid)
    }

    func test_whenCardNumberValidWithSpacing_thenValid() {
        // given
        let cardNumberField = PaymentTextField(type: .cardNumber)
        
        // when
        cardNumberField.text = "4111 1111 1111 1111"
        
        // then
        XCTAssertTrue(cardNumberField.isValid)
    }

    func test_whenCardNumberValidPartialSpacing_thenValid() {
        // given
        let cardNumberField = PaymentTextField(type: .cardNumber)
        
        // when
        cardNumberField.text = "41111111 11111111"
        
        // then
        XCTAssertTrue(cardNumberField.isValid)
    }

    func test_whenCardNumberInvalidShortNumber_thenInvalid() {
        // given
        let cardNumberField = PaymentTextField(type: .cardNumber)
        
        // when
        cardNumberField.text = "4111"
        
        // then
        XCTAssertFalse(cardNumberField.isValid)
    }

    func test_whenCardNumberInvalidNonNumericCharacters_thenInvalid() {
        // given
        let cardNumberField = PaymentTextField(type: .cardNumber)
        
        // when
        cardNumberField.text = "abcd"
        
        // then
        XCTAssertFalse(cardNumberField.isValid)
    }

    func test_whenCardNumberInvalidEmptyText_thenInvalid() {
        // given
        let cardNumberField = PaymentTextField(type: .cardNumber)
        
        // when
        cardNumberField.text = ""
        
        // then
        XCTAssertFalse(cardNumberField.isValid)
    }

}
