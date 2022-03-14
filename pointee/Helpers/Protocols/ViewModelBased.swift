//
//  ViewModelBased.swift
//  pointee
//
//  Created by Alexander on 20.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Reusable

protocol ViewModelBased: AnyObject {
    
    associatedtype ViewModel
    
    var viewModel: ViewModel! { get set }
    
    func setupLocalize()
    func setupUI()
    func bindUI()
}

extension ViewModelBased {
    func setupLocalize() {}
    func setupUI() {}
    func bindUI() {}
}

extension StoryboardBased where Self: UIViewController & ViewModelBased {
    
    static func instantiate(with viewModel: ViewModel) -> Self {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ViewModelBased where Self: UIViewController {
    
    func bindViewModel() {
        setupLocalize()
        setupUI()
        removeBackButtonTitle()
        bindUI()
    }

    static func instantiate(with viewModel: ViewModel) -> Self {
        let viewController = Self()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ViewModelBased where Self: UICollectionViewController {
    
    func bindViewModel() {
        setupLocalize()
        setupUI()
        removeBackButtonTitle()
        bindUI()
        
    }

    static func instantiate(with viewModel: ViewModel) -> Self {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let viewController = Self(collectionViewLayout: layout)
        viewController.viewModel = viewModel
        return viewController
    }
}
