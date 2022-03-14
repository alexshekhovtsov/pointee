//
//  CartVC.swift
//  pointee
//
//  Created by Alexander on 26.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

/**
 Class responsible for displaying Cart with list of goods and "Make order" button.
 */
final class CartVC: UIViewController, ViewModelBased, UIScrollViewDelegate, UITableViewDelegate {
    
    // MARK: - UI Properties
    
    lazy var emptyImage: UIImageView = {
        let view = UIImageView(image: R.image.man_in_cart())
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var makeOrderButton: BaseButton = {
        let button = BaseButton()
        button.style(.gradient)
        button.cornerRadius = UIConstants.cornerRadius
        return button
    }()
    
    lazy var amountTitleLabel: UILabel = {
        let label = UILabel()
        label.style(.title(textColor: .white,
                           textAlignment: .left,
                           font: .appFont(atSize: UIConstants.fontSize),
                           numberOfLines: 1))
        return label
    }()
    
    lazy var amountValueLabel: UILabel = {
        let label = UILabel()
        label.style(.title(textColor: .white,
                           textAlignment: .right,
                           font: .appFontBold(atSize: UIConstants.fontSize),
                           numberOfLines: 1))
        return label
    }()
    
    let tableView = UITableView()
    
    // MARK: - Properties
    
    var viewModel: CartVM!

    private let disposeBag = DisposeBag()
    
    private let labelHeight: CGFloat = 27
    
    private let tableBottomInset: CGFloat = 136
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.didAppear.onNext(())
    }
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.register(cellType: ProductCell.self)
        tableView.estimatedRowHeight = 98
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIConstants.GreyBackground
        
        let stack = UIView().stack(UIView().hstack(amountTitleLabel,
                                                   amountValueLabel).withHeight(labelHeight),
                                   makeOrderButton.withHeight(UIConstants.buttonHeight), spacing: UIConstants.marginS)
        
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = UIConstants.SpaceBlue
        view.addSubview(buttonContainer)
        buttonContainer.anchor(top: nil,
                               leading: view.leadingAnchor,
                               bottom: view.bottomAnchor,
                               trailing: view.trailingAnchor)
        buttonContainer.addSubview(stack)
        stack.fillSuperview(padding: UIEdgeInsets(top: UIConstants.marginS,
                                                  left: UIConstants.marginS,
                                                  bottom: UIConstants.marginS,
                                                  right: UIConstants.marginS))
        buttonContainer.layer.cornerRadius = UIConstants.cornerRadiusMiddle
        buttonContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.contentInset = UIEdgeInsets(top: UIConstants.marginMinimum,
                                              left: 0,
                                              bottom: tableBottomInset,
                                              right: 0)
        
        view.addSubview(emptyImage)
        emptyImage.centerInSuperview()
        emptyImage.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor,
                                            constant: UIConstants.marginM).isActive = true
        emptyImage.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor,
                                             constant: UIConstants.marginM).isActive = true
    }
    
    func setupLocalize() {
        navigationItem.title = viewModel.topTitle
        amountTitleLabel.text = viewModel.amountTitle
        makeOrderButton.setTitle(viewModel.payWithCardTitle, for: .normal)
    }
    
    func bindUI() {
        setupTableDataSource()
        
        viewModel.amountValueTitle
            .asDriver()
            .drive(amountValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        makeOrderButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.makeOrderAction)
            .disposed(by: disposeBag)
        
        viewModel.amount
            .observeOn(MainScheduler.instance)
            .map { $0 != 0 }
            .bind(to: makeOrderButton.rx.isEnabled, emptyImage.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("CartVC deinit")
    }
    
    // MARK: - Logic
    
    /// Setup data source
    private func setupTableDataSource() {
        let dataSource = RxTableViewSectionedReloadDataSource<CartVM.ProductSection>(configureCell: {
            (_, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .product(let viewModel):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ProductCell.self)
                cell.configureCell(viewModel)
                return cell
            }
        })
        
        dataSource.canEditRowAtIndexPath = { _, _ in return true }
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(CartVM.ProductSectionModel.self)
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.deleteProduct)
            .disposed(by: disposeBag)
        
        viewModel
            .sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            self.tableView.dataSource?.tableView?(self.tableView, commit: .delete, forRowAt: indexPath)
        }
        deleteAction.image = R.image.trash_red()
        if #available(iOS 13.0, *) {
            deleteAction.image?.withTintColor(UIConstants.Red)
            deleteAction.backgroundColor = UIConstants.GreyBackground
        } else {
            deleteAction.backgroundColor = UIConstants.Red
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
