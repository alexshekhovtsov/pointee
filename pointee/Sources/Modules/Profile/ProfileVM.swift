//
//  ProfileVM.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation
import RxSwift
import RxFlow
import RxCocoa

/**
 Class responsible for creating ViewModel instance for Profile Module.
 */
final class ProfileVM: VMStepper {
    
    // MARK: - Properties
    
    /// Flow steps
    var steps = PublishRelay<Step>()
    /// Dispose bag
    private let disposeBag = DisposeBag()
    /// Need Update User Action
    let needUpdateUser = PublishSubject<Void>()
    /// Support Button Tapped Action
    let supportAction = PublishSubject<Void>()
    /// Authorize Button Tapped Action
    let authorizeAction = PublishSubject<Void>()
    /// Is user a guest
    let isUserGuest = BehaviorRelay<Bool>(value: true)
    
    /// Greeting Value
    let greeting = BehaviorRelay<String>(value: "")
    /// Email Value
    let emailValue = BehaviorRelay<String>(value: "")
    /// Name Value
    let nameValue = BehaviorRelay<String>(value: "")
    /// Phone Value
    let phoneValue = BehaviorRelay<String>(value: "")
    
    /// Localizable strings
    let topTitle = R.string.localizable.profile()
    let writeToSupport = R.string.localizable.write_to_support()
    let exit = R.string.localizable.exit()
    let authorize = R.string.localizable.authorize()
    let emailTextFieldTitle = R.string.localizable.email()
    let emailTextFieldError = R.string.localizable.validation_explanation_email()
    let nameTextFieldTitle = R.string.localizable.name()
    let nameTextFieldError = R.string.localizable.validation_explanation_name()
    let phoneTextFieldTitle = R.string.localizable.phone()
    let phoneTextFieldError = R.string.localizable.validation_explanation_phone()
    
    /// Initialize ProfileVM ViewModel
    /// - Parameters:
    ///   - userManager: UserManager
    ///   - authManager: AuthenticationManager
    init(userManager: UserManager = UserManager.shared,
         authManager: AuthenticationManager = AuthenticationManager.shared) {
        
        authorizeAction
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                authManager.logout()
                self.steps.accept(ProfileStep.sign(animated: true, needUpdateUser: self.needUpdateUser))
            })
            .disposed(by: disposeBag)
        
        needUpdateUser
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let user = userManager.user, user.isRegistered else {
                    self.isUserGuest.accept(true)
                    self.nameValue.accept("")
                    return
                }
                self.isUserGuest.accept(false)
                self.nameValue.accept(user.name)
                self.emailValue.accept(user.email)
                self.phoneValue.accept(user.phone ?? "")
            })
            .disposed(by: disposeBag)
        
        nameValue
            .observeOn(MainScheduler.instance)
            .map({ value -> String in
                let appeal = value.isEmpty ? "" : R.string.localizable.appeal(value)
                
                switch Date().hourAndMinute.hour {
                case 0..<5:
                    return R.string.localizable.good_night_user(appeal)
                case 5..<12:
                    return R.string.localizable.good_morning_user(appeal)
                case 12..<18:
                    return R.string.localizable.good_afternoon_user(appeal)
                case 18..<24:
                    return R.string.localizable.good_evening_user(appeal)
                default:
                    return R.string.localizable.good_afternoon_user("")
                }
            })
            .bind(to: greeting)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("ProfileVM deinit")
    }
}
