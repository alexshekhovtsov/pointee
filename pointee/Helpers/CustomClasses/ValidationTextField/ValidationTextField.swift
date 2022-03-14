//
//  ValidationTextField.swift
//  pointee
//
//  Created by Alexander on 22.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import LBTATools

protocol TextFieldValidatable {
    
    /// Check if TextField data is Valid
    ///
    /// - Parameter value: Data to check
    /// - Returns: Valid or NotValid
    func isValidContent(_ value: String?) -> Bool
    /// Set Validation Error View State
    ///
    /// - Parameter value: Isvalid
    func setValidationErrorViewWith(_ value: Bool)
    /// Set Field Validation State
    ///
    /// - Parameter value: Isvalid
    func setFieldValidationWith(_ value: Bool)
    /// Set Error Message Value
    ///
    /// - Parameter value: Error string value
    func setError(_ value: String?)
    
    /// Configure TextField
    func bindTextFieldActions()
}

/**
 Base Class that's responsible for displaying user input and show error if needed
 */
class ValidationTextField: UIView {

    // MARK: - Properties

    /// ViewModel
    var viewModel: TextFieldViewable

    /// TextField previously was edit
    private let wasEdited = BehaviorRelay(value: false)

    private let contentPadding: CGFloat = UIConstants.marginS
    
    /// Dispose Bag
    private let disposeBag = DisposeBag()
    
    private var innerShadow: CALayer!

    // MARK: - @IBOutlet
    /// Error View
    lazy var errorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    /// Error Message
    lazy var errorMessage: UILabel = {
        let label = UILabel()
        label.style(.body(textColor: UIConstants.Red,
                          textAlignment: .left,
                          font: .appFont(atSize: UIConstants.fontSizeSmall)))
        return label
    }()

    /// TextField
    lazy var textField: UITextField = {
        let field = UITextField()
        return field
    }()

    /// TextField Title View
    let textFieldTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    /// TextField Title
    lazy var textFieldTitle: UILabel = {
        let label = UILabel()
        label.style(.body(textColor: viewModel.titleTextColor,
                          textAlignment: .left,
                          font: .appFont(atSize: UIConstants.fontSizeSmall)))
        return label
    }()
    
    /// TextField Title
    lazy var textFieldRequireTitle: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.style(.body(textColor: UIConstants.Red,
                          textAlignment: .left,
                          font: .appFont(atSize: UIConstants.fontSizeSmall)))
        return label
    }()

    // MARK: - Lifecycle

    init(viewModel: TextFieldViewable) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        cornerRadius = UIConstants.cornerRadius
        setupView()
        bindTextFieldActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        createInnerShadow()
    }

    // MARK: - Logic

    private func reloadTextFieldUI() {

    }
    
    /// Setup View
    private func setupView() {

    }
    
    /// Is Content is Valid
    ///
    /// - Parameter value: String
    /// - Returns: Bool
    func isValidContent(_ value: String?) -> Bool {
        if let value = value {
            if value.isEmpty { return !viewModel.isRequired }
            return true
        }
        return false
    }
}

extension ValidationTextField {
    
    func createInnerShadow() {
        if innerShadow == nil {
            textField.layoutIfNeeded()
            innerShadow = CALayer()
            rebounceShadow()
            innerShadow.masksToBounds = true
            innerShadow.shadowColor = UIColor.black.cgColor
            innerShadow.shadowOffset = CGSize(width: 0, height: 2)
            innerShadow.shadowOpacity = 0.8
            innerShadow.shadowRadius = 4
            innerShadow.cornerRadius = 16
            textField.layer.addSublayer(innerShadow)
            textField.layer.cornerRadius = 16
        } else {
            rebounceShadow()
        }
    }
    
    private func rebounceShadow() {
        innerShadow.frame = textField.bounds
        
        let newBounds = CGRect(x: innerShadow.bounds.minX,
                               y: innerShadow.bounds.minY,
                               width: innerShadow.bounds.width + 2,
                               height: innerShadow.bounds.height + 4)
        let path = UIBezierPath(roundedRect: newBounds.insetBy(dx: -0.5, dy: -1), cornerRadius: cornerRadius)
        let cutout = UIBezierPath(roundedRect: newBounds, cornerRadius: cornerRadius).reversing()
        
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
    }
}

// MARK: - TextFieldValidatable
extension ValidationTextField: TextFieldValidatable {
    
    /// Bind TextField actions
    func bindTextFieldActions() {
        textField.rx.controlEvent([.editingChanged])
            .flatMapLatest({ _ in
                Observable.combineLatest(self.textField.rx.value.orEmpty, self.wasEdited)
            })
            .filter({ !$0.isEmpty && $1 })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (value, _) in
                guard let self = self, !self.viewModel.validateOnEnd else { return }
                if !self.viewModel.allowsEditing.value {
                    self.setFieldValidationWith(true) // Set default field style when no editing allowed
                    self.setValidationErrorViewWith(true)
                } else {
                    let isValid = self.isValidContent(value)
                    self.setFieldValidationWith(isValid) // Set field style depends on data validation
                    self.setValidationErrorViewWith(isValid)
                }
            })
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent([.editingDidEnd])
            .withLatestFrom(textField.rx.value.orEmpty)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (value) in
                guard let self = self else { return }
                if !self.wasEdited.value {
                    self.wasEdited.accept(true)
                    return
                }
                if !self.viewModel.allowsEditing.value {
                    self.setFieldValidationWith(true) // Set default field style when no editing allowed
                    self.setValidationErrorViewWith(true)
                } else {
                    let isValid = self.isValidContent(value)
                    self.setFieldValidationWith(isValid) // Set field style depends on data validation
                    self.setValidationErrorViewWith(isValid)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.editMode
            .filter({ $0 != .none })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] mode in
                guard let self = self else { return }
                self.viewModel.allowsEditing.accept(mode == .active)
                self.reloadTextFieldUI()
                if mode == .unactive {
                    self.textField.resignFirstResponder()
                    self.setValidationErrorViewWith(true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    /// Set Validation Error View
    ///
    /// - Parameter value: Bool
    func setValidationErrorViewWith(_ value: Bool) {
        self.errorView.isHidden = value
    }
    
    /// Set Field Validation
    ///
    /// - Parameter value: Bool
    func setFieldValidationWith(_ value: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.textField.layer.borderColor = value ? self.viewModel.fieldBorderColor : UIConstants.Red.cgColor
            self.textField.layer.borderWidth = value ? self.viewModel.fieldBorderWidth : 2
        }
    }
    
    /// Set Error
    ///
    /// - Parameter value: String
    func setError(_ value: String?) {
        errorMessage.text = value
    }
    
    /// Set Title
    ///
    /// - Parameter value: String
    func setTitle(_ value: String?) {
        if viewModel.showFieldTitle {
            textFieldTitleView.isHidden = false
            textFieldTitle.text = value
        }
    }
}
