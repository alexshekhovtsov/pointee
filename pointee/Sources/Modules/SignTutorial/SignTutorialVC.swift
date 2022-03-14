//
//  SignTutorialVC.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources
import LBTATools

/**
 Class responsible for displaying First Screen with tutorial and sign in/sign up buttons.
 */
final class SignTutorialVC: UICollectionViewController, ViewModelBased {
    
    // MARK: - UI Properties
    
    lazy var guestButton: BaseButton = {
        let button = BaseButton()
        button.style(.clear(light: true))
        return button
    }()
    
    lazy var signInButton: BaseButton = {
        let button = BaseButton()
        button.isEnabled = false
        button.style(.white)
        button.cornerRadius = UIConstants.cornerRadius
        return button
    }()
    
    lazy var signUpButton: BaseButton = {
        let button = BaseButton()
        button.isEnabled = false
        button.style(.gradient)
        button.cornerRadius = UIConstants.cornerRadius
        return button
    }()

    /// PageController
    private lazy var pageController: UIPageControl = {
        return UIPageControl()
    }()
    
    // MARK: - Properties
    
    var viewModel: SignTutorialVM!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = UIConstants.SpaceBlue
        makeNavigationControllerTrasparent(true)
        bindViewModel()
    }
    
    func setupUI() {
        collectionView.register(cellType: TutorialCell.self)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIConstants.SpaceBlue
        
        let pageContainer = UIView()
        pageContainer.addSubview(pageController)
        let container = UIView().stack(pageContainer.withHeight(UIConstants.buttonHeight),
                                       UIView().hstack(signInButton.withHeight(UIConstants.buttonHeight),
                                                       signUpButton.withHeight(UIConstants.buttonHeight),
                                                       spacing: UIConstants.marginS,
                                                       distribution: .fillEqually),
                                       guestButton.withHeight(UIConstants.buttonHeight),
                                       spacing: UIConstants.marginS,
                                       alignment: .fill)
        view.addSubview(container)
        container.anchor(top: nil,
                         leading: view.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: view.trailingAnchor,
                         padding: UIEdgeInsets(top: 0,
                                               left: UIConstants.marginS,
                                               bottom: UIConstants.marginM,
                                               right: UIConstants.marginS))
        
        pageController.isUserInteractionEnabled = false
        pageController.numberOfPages = viewModel.sectionedItems.value.count
        pageController.centerXTo(pageContainer.centerXAnchor)
        pageController.centerYTo(pageContainer.centerYAnchor)
    }
    
    func setupLocalize() {
        signInButton.setTitle(viewModel.signInTitle, for: .normal)
        signUpButton.setTitle(viewModel.signUpTitle, for: .normal)
        guestButton.setTitle(viewModel.guestTitle, for: .normal)
    }
    
    func bindUI() {
        
        bindCollectionView()
        
        guestButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.guestAction)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.signInAction)
            .disposed(by: disposeBag)

        signUpButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.signUpAction)
            .disposed(by: disposeBag)
        
        viewModel
            .appAction
            .observeOn(MainScheduler.instance)
            .bind(to: rx.appAction)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("SignTutorialVC deinit")
    }
    
    // MARK: - Logic
        
    private func bindCollectionView() {
        
        /// RxDataSources, need to set nil, before binding
        collectionView.dataSource = nil
        
        collectionView.delegate = nil
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SignTutorialVM.TutorialSection>( configureCell: {
            (_, collectionView, indexPath, sectionModel) in
                switch sectionModel {
                case .tutorial(let viewModel):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TutorialCell.self)
                    cell.configureCell(viewModel)
                    return cell
                }
        }, configureSupplementaryView: { (_, _, _, _) in
            return UICollectionReusableView(frame: .zero)
        })
        
        collectionView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel
            .sectionedItems
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SignTutorialVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UIScrollViewDelegate
extension SignTutorialVC {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = collectionView.contentOffset.x
        let pageWidth = self.view.frame.width
        pageController.currentPage = Int((offset + pageWidth / 2) / pageWidth)
    }
}

