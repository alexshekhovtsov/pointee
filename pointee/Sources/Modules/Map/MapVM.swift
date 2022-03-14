//
//  MapVM.swift
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
 Class responsible for creating ViewModel instance for Map Module.
 */
final class MapVM: VMStepper, ProgressLoaderViewable {
    
    /// Flow steps
    var steps = PublishRelay<Step>()
    /// Dispose bag
    private let disposeBag = DisposeBag()
    /// App Action
    let appAction = PublishSubject<AppAction>()
    
    private let businessRepository: BusinessRepository
    
    let businessesList = BehaviorRelay<BusinessesList>(value: [])
    
    let didAppear = PublishSubject<Void>()
    let needUpdateUser = PublishSubject<Void>()
    
    let detailsAction = PublishSubject<Void>()
    let listViewAction = PublishSubject<Void>()
    let filtersAction = PublishSubject<Void>()
    
    /// Localizable strings
    let topTitle = R.string.localizable.map()
    
    init(authManager: AuthenticationManager = AuthenticationManager.shared,
         businessRepository: BusinessRepository =
         BusinessRepository(apiClient: APIClientMock(filename: "BusinessesList", modelType: BusinessesList.self))) {
        
        self.businessRepository = businessRepository
        
        didAppear
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if authManager.isUserEmpty() {
                    self.steps.accept(ExplorerStep.sign(animated: false, needUpdateUser: self.needUpdateUser))
                } else {
                    if self.businessesList.value.isEmpty {
                        self.loadUser()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        filtersAction
            .observeOn(MainScheduler.instance)
            .map({ ExplorerStep.filters })
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
    
    private func loadUser() {
        self.startLoaderAnimating()
        UserManager.shared.refresh { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.loadContent()
            case .error(let error):
                self.stopLoaderAnimation()
                self.appAction.onNext(.error(message: error.localizableError))
            }
        }
    }
    
    private func loadContent() {
        businessRepository.businesses { [weak self] result in
            guard let self = self else { return }
            self.stopLoaderAnimation()
            switch result {
            case .success(let businessesList):
                self.businessesList.accept(businessesList)
            case .error(let error):
                self.appAction.onNext(.error(message: error.localizableError))
            }
        }
    }
    
    deinit {
        print("MapVM deinit")
    }
}
