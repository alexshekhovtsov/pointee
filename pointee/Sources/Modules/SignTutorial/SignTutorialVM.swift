//
//  SignTutorialVM.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation
import RxSwift
import RxFlow
import RxCocoa
import RxDataSources

/**
 Class responsible for creating ViewModel instance for SignTutorial Module.
 */
final class SignTutorialVM: VMStepper {
    
    // MARK: - Properties
    
    /// Flow steps
    var steps = PublishRelay<Step>()
    /// Dispose bag
    private let disposeBag = DisposeBag()
    /// App Action
    let appAction = PublishSubject<AppAction>()
    /// Section Items
    let sectionedItems = BehaviorRelay<[TutorialSection]>(value: [])
    
    /// Actions
    let signInAction = PublishSubject<Void>()
    let signUpAction = PublishSubject<Void>()
    let guestAction = PublishSubject<Void>()
    
    /// Localizable strings
    let guestTitle = R.string.localizable.continue_as_a_guest()
    let signInTitle = R.string.localizable.sign_in()
    let signUpTitle = R.string.localizable.sign_up()
    
    /// Initialize SignTutorialVM ViewModel
    /// - Parameters:
    ///   - authManager: AuthenticationManager
    ///   - userManager: UserManager
    ///   - authRepository: AuthRepository
    init(authManager: AuthenticationManager = AuthenticationManager.shared,
         userManager: UserManager = UserManager.shared,
         authRepository: AuthRepository = AuthRepository(apiClient: APIClientMock(filename: "AuthenticationDataGuest",
                                                                                  modelType: AuthenticationData.self))) {
        guestAction
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                authRepository.guest { result in
                    switch result {
                    case .success(let authData):
                        authManager.guestWith(authenticationData: authData)
                        userManager.configureUser(with: authData)
                        self.steps.accept(SignStep.dismiss)
                    case .error(let error):
                        self.appAction.onNext(.error(message: error.localizableError))
                    }
                }
            })
            .disposed(by: disposeBag)
        
        configureSections()
    }
    
    deinit {
        print("SignTutorialVM deinit")
    }
    
    // MARK: - Logic
    
    /// Configure Tutorial Sections
    private func configureSections() {
        /// Create collection view sections array
        var items = [TutorialSection]()

        /// Add tutorial cells
        items.append(TutorialSection(model: .tutorial, items: [
            .tutorial(viewModel: TutorialCellViewModel(image: nil, text: R.string.localizable.start_here()))
        ]))
        items.append(TutorialSection(model: .tutorial, items: [
            .tutorial(viewModel: TutorialCellViewModel(image: nil, text: R.string.localizable.start_here()))
        ]))
        items.append(TutorialSection(model: .tutorial, items: [
            .tutorial(viewModel: TutorialCellViewModel(image: nil, text: R.string.localizable.start_here()))
        ]))
        items.append(TutorialSection(model: .tutorial, items: [
            .tutorial(viewModel: TutorialCellViewModel(image: nil, text: R.string.localizable.start_here()))
        ]))
        
        sectionedItems.accept(items)
    }
}

protocol TutorialPresentable {
    var image: UIImage? { get }
    var text: String { get }
}

// MARK: - DataSources
extension SignTutorialVM {

    /// Tutorial Cell ViewModel
    struct TutorialCellViewModel: TutorialPresentable {
        let image: UIImage?
        let text: String
    }
    
    typealias TutorialSection = SectionModel<TutorialSectionType, TutorialSectionModel>

    /// TutorialSectionType
    ///
    /// - tutorial: Section for displaying tutorial information
    enum TutorialSectionType: Int {
        case tutorial
    }

    /// TutorialSectionModel
    ///
    /// - tutorial: TriggerDetailPresentable
    enum TutorialSectionModel {
        case tutorial(viewModel: TutorialPresentable)
    }
}

