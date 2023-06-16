//
//  Extensions.swift
//  MobilisePayment
//
//  Created by Mousa Alwaraki on 14/06/2023.
//

import UIKit

extension Array where Element == PaymentTextField {
//    func getField(of type: PaymentTextField) -> PaymentTextField? {
//        return first(where: {$0.type == type})
//    }
}

extension UIView {
    func constraintHeight(to height: CGFloat) {
        NSLayoutConstraint.activate([heightAnchor.constraint(equalToConstant: height)])
    }
    
    func roundCorners() {
        layer.cornerRadius = 6
        layer.masksToBounds = false
        clipsToBounds = false
    }
}

extension UIStackView {
    func addSpacing(_ height: CGFloat) {
        let seperatorView = UIView()
        seperatorView.constraintHeight(to: height)
        addArrangedSubview(seperatorView)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
