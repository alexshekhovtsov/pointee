//
//  ProfileVC.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxBiBinding

/**
 Class responsible for displaying user profile.
 */
final class ProfileVC: UIViewController, StoryboardBased, ViewModelBased {
    
    // MARK: - UI Properties
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.style(.title(textColor: UIConstants.SpaceBlue,
                           textAlignment: .left,
                           font: .appFontBold(atSize: UIConstants.fontSizeBig),
                           numberOfLines: 0))
        return label
    }()
    
    lazy var nameTextField: TextValidationField = {
        let field = TextValidationField(viewModel: TextFieldViewModel([.profileField]))
        return field
    }()
    
    lazy var emailTextField: EmailValidationField = {
        let field = EmailValidationField(viewModel: TextFieldViewModel([.profileField]))
        return field
    }()
    
    lazy var phoneTextField: TextValidationField = {
        let field = TextValidationField(viewModel: TextFieldViewModel([.profileField]))
        return field
    }()
    
    lazy var supportButton: BaseButton = {
        let button = BaseButton()
        button.style(.blue)
        button.cornerRadius = UIConstants.cornerRadius
        return button
    }()
    
    lazy var authorizeButton: BaseButton = {
        let button = BaseButton()
        button.style(.green)
        button.cornerRadius = UIConstants.cornerRadius
        return button
    }()
    
    lazy var logoutButton: BaseButton = {
        let button = BaseButton()
        button.style(.red)
        button.cornerRadius = UIConstants.cornerRadius
        return button
    }()
    
    let scrollView = UIScrollView()
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    var viewModel: ProfileVM!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func setupUI() {
        let container = UIView()
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(container)
        container.fillSuperview()
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        let stack = UIView().stack(greetingLabel,
                                   UIView().stack(nameTextField,
                                                  emailTextField,
                                                  phoneTextField,
                                                  spacing: UIConstants.marginMinimum),
                                   authorizeButton.withHeight(UIConstants.buttonHeight),
                                   logoutButton.withHeight(UIConstants.buttonHeight),
                                   spacing: UIConstants.marginM)
        
        container.addSubview(stack)
        
        if UIDevice.current.isPad {
            stack.anchor(top: container.topAnchor,
                         leading: nil,
                         bottom: container.bottomAnchor,
                         trailing: nil,
                         padding: UIEdgeInsets(top: UIConstants.marginS,
                                               left: 0,
                                               bottom: UIConstants.marginS,
                                               right: 0))
            stack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5).isActive = true
        } else {
            stack.anchor(top: container.topAnchor,
                         leading: container.leadingAnchor,
                         bottom: container.bottomAnchor,
                         trailing: container.trailingAnchor,
                         padding: UIEdgeInsets(top: UIConstants.marginS,
                                               left: UIConstants.marginM,
                                               bottom: UIConstants.marginS,
                                               right: UIConstants.marginM))
        }
    }
    
    func setupLocalize() {
        navigationItem.title = viewModel.topTitle
        
        authorizeButton.setTitle(viewModel.authorize, for: .normal)
        logoutButton.setTitle(viewModel.exit, for: .normal)
        
        emailTextField.setTitle(viewModel.emailTextFieldTitle)
        emailTextField.setError(viewModel.emailTextFieldError)
        nameTextField.setTitle(viewModel.nameTextFieldTitle)
        nameTextField.setError(viewModel.nameTextFieldError)
        phoneTextField.setTitle(viewModel.phoneTextFieldTitle)
        phoneTextField.setError(viewModel.phoneTextFieldError)
    }
    
    func bindUI() {
        bindTextFields()
        
        viewModel.greeting
            .asDriver()
            .drive(greetingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isUserGuest
            .observeOn(MainScheduler.instance)
            .bind(to: emailTextField.rx.isHidden,
                  nameTextField.rx.isHidden,
                  phoneTextField.rx.isHidden,
                  supportButton.rx.isHidden,
                  logoutButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isUserGuest
            .observeOn(MainScheduler.instance)
            .map({ !$0 })
            .bind(to: authorizeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        authorizeButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.authorizeAction)
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.authorizeAction)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("ProfileVC deinit")
    }
    
    // MARK: - Logic
    
    /// Bind all text fields
    private func bindTextFields() {
        (emailTextField.textField.rx.text.orEmpty <-> viewModel.emailValue)
            .disposed(by: disposeBag)
        (nameTextField.textField.rx.text.orEmpty <-> viewModel.nameValue)
            .disposed(by: disposeBag)
        (phoneTextField.textField.rx.text.orEmpty <-> viewModel.phoneValue)
            .disposed(by: disposeBag)
    }
}
