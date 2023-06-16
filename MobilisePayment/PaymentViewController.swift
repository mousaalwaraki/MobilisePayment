//
//  ViewController.swift
//  MobilisePayment
//
//  Created by Mousa Alwaraki on 14/06/2023.
//

import UIKit

class PaymentViewController: UIViewController {

    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        
        let navItem = UINavigationItem(title: "Payment")
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(navigateToPreviousCategory))
        navItem.leftBarButtonItem = backButton
        navigationBar.setItems([navItem], animated: false)
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.shadowColor = .clear
        
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var primaryButton: UIButton = {
        let primaryButton = UIButton()
        primaryButton.backgroundColor = .lightGray
        primaryButton.layer.cornerRadius = 10
        primaryButton.setTitle("Next", for: .normal)
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.addTarget(self, action: #selector(tappedPrimaryButton), for: .touchDown)
        return primaryButton
    }()
    
    lazy var secondaryButton: UIButton = {
        let secondaryButton = UIButton()
        secondaryButton.backgroundColor = .systemGray5
        secondaryButton.setTitleColor(.systemBlue, for: .normal)
        secondaryButton.layer.cornerRadius = 10
        secondaryButton.setTitle("Same as Delivery", for: .normal)
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryButton.addTarget(self, action: #selector(fillBillingFromDelivery), for: .touchDown)
        secondaryButton.isHidden = true
        return secondaryButton
    }()
    
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(progressView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        view.addSubview(primaryButton)
        view.addSubview(secondaryButton)
    }
    
    private func setupConstraints() {
        
        let viewBottomPositionConstraint =
        primaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        viewBottomPositionConstraint.isActive = true
        
        keyboardNotifier = KeyboardNotifier(parentView: view, constraint: viewBottomPositionConstraint)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            progressView.topAnchor.constraint(equalTo: navigationBar.safeAreaLayoutGuide.bottomAnchor, constant: 5),
            
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5),
            scrollView.bottomAnchor.constraint(equalTo: primaryButton.topAnchor, constant: -5),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -5),
            
            secondaryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            secondaryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            secondaryButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            secondaryButton.heightAnchor.constraint(equalToConstant: 40),
            
            primaryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            primaryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            primaryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    var currentCategory: PaymentFieldCategory?
    var paymentTransaction = PaymentTransaction()
    var keyboardNotifier: KeyboardNotifier!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        navigate(to: .delivery)
    }
}
