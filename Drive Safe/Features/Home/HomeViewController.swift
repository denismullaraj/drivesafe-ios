//
//  HomeViewController.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 06/01/2020.
//  Copyright © 2020 Denis Mullaraj. All rights reserved.
//

import UIKit
import ARKit

import RxCocoa
import RxSwift

final class HomeViewController: UIViewController {
    
    typealias Factory = ViewControllerFactory
    
    var isFaceTrackingSupported: Bool = {
        return ARFaceTrackingConfiguration.isSupported
    }()
    
    private let factory: Factory
    private let viewmodel: HomeViewModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drive safe."
        label.font = UIFont(name: "Georgia", size: 22.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.text = "You will hear an alarm anytime\nyou keep eyes closed for more"
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia", size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelBeforeSeconds: UILabel = {
        let label = UILabel()
        label.text = "than"
        label.font = UIFont(name: "Georgia", size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var secondsTextField: SingleCharUITextField = {
        let textfield = SingleCharUITextField()
        textfield.placeholder = "2"
        textfield.font = UIFont(name: "Georgia", size: 20.0)
        textfield.minimumFontSize = 17.0
        textfield.clearButtonMode = .never
        textfield.adjustsFontSizeToFitWidth = true
        textfield.keyboardType = .numberPad
        textfield.textColor = UIColor(named: "Blue")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var labelAfterSeconds: UILabel = {
        let label = UILabel()
        label.text = "seconds."
        label.font = UIFont(name: "Georgia", size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var keepMeSafeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Keep me safe", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19.0)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "Blue")
        button.layer.cornerRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    init(viewmodel: HomeViewModel, factory: Factory) {
        self.viewmodel = viewmodel
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        guard isFaceTrackingSupported else {
            keepMeSafeButton.isEnabled = false
            MessageAlertController.displayConfirmationDialog("Warning", message: "App requires iPhone X or later in order to use Camera with TrueDepth feature", from: self)
            return
        }
                                
        setupSubscriptions()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(introductionLabel)
        view.addSubview(labelBeforeSeconds)
        view.addSubview(secondsTextField)
        view.addSubview(labelAfterSeconds)
        view.addSubview(keepMeSafeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            
            introductionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            introductionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            introductionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 71),
            
            labelBeforeSeconds.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            labelBeforeSeconds.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 6),

            secondsTextField.leadingAnchor.constraint(equalTo: labelBeforeSeconds.trailingAnchor, constant: 3),
            secondsTextField.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 6),

            labelAfterSeconds.leadingAnchor.constraint(equalTo: secondsTextField.trailingAnchor, constant: 3),
            labelAfterSeconds.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 6),

            keepMeSafeButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            keepMeSafeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -55),
            keepMeSafeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 140),
            keepMeSafeButton.heightAnchor.constraint(equalToConstant: 50),
            keepMeSafeButton.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 100)
        ])
        
        view.backgroundColor = .white

    }
    
    private func setupSubscriptions() {
        keepMeSafeButton.rx.tap.bind { [viewmodel] _ in
            viewmodel.keepMeSafeButtonTapped()
        }.disposed(by: disposeBag)

        viewmodel.isKeyboardHidden
            .drive(onNext: { [weak self] shouldHideKeyboard in
                if shouldHideKeyboard {
                    self?.view.endEditing(true)
                }
            })
            .disposed(by: disposeBag)

        secondsTextField.rx.controlEvent(.editingChanged).withLatestFrom(secondsTextField.rx.text.orEmpty)
                .subscribe(onNext: { [viewmodel] text in
                    viewmodel.secondsTextFieldChanged(newValue: text)
                })
                .disposed(by: disposeBag)
        
        viewmodel.secondsPlaceholderText
            .drive(secondsTextField.rx.placeholder)
            .disposed(by: disposeBag)

        viewmodel.secondsText
            .drive(secondsTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewmodel.didRequestShowNextScreen
            .drive(onNext: { [factory, weak self] _ in
                let vc = factory.makeKeepEyesOpenViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
