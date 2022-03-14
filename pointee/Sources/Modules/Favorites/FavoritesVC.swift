//
//  FavoritesVC.swift
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

/**
 Class responsible for displaying list of favorites orders/stores
 */
final class FavoritesVC: UIViewController, StoryboardBased, ViewModelBased, UIScrollViewDelegate {
    
    // MARK: - UI Properties
    
    lazy var segment: UISegmentedControl = {
        let view = UISegmentedControl(backgroundColor: UIConstants.SpaceBlueLight)
        view.insertSegment(withTitle: viewModel.organizationsTitle, at: 0, animated: false)
        view.insertSegment(withTitle: viewModel.ordersTitle, at: 1, animated: false)
        if #available(iOS 13.0, *) {
            view.selectedSegmentTintColor = UIConstants.YellowSelected
        } else {
            view.tintColor = UIConstants.YellowSelected
            view.layer.cornerRadius = UIConstants.cornerRadiusMinimum
        }
        view.setTitleTextAttributes([.font : UIFont.appFontBold(atSize: UIConstants.fontSizeSmall),
                                     .foregroundColor: UIColor.white],
                                    for: .normal)
        view.setTitleTextAttributes([.font : UIFont.appFontBold(atSize: UIConstants.fontSizeSmall),
                                     .foregroundColor: UIConstants.SpaceBlue],
                                    for: .selected)
        view.selectedSegmentIndex = 0
        return view
    }()
    
    let tableView = UITableView()
    
    // MARK: - Properties
    
    var viewModel: FavoritesVM!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        makeNavigationControllerTrasparent(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.didAppear.onNext(())
    }
    
    func setupUI() {
        view.backgroundColor = UIConstants.GreyBackground
        let container = UIView()
        view.addSubview(container)
        container.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        container.addSubview(segment)
        segment.fillSuperview(padding: UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0))
        
        container.backgroundColor = UIConstants.SpaceBlue
        container.cornerRadius = segment.layer.cornerRadius + 1
        container.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        view.addSubview(tableView)
        tableView.anchor(top: container.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
        tableView.backgroundColor = .clear
        tableView.register(cellType: OrganizationCell.self)
        tableView.estimatedRowHeight = 114
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func setupLocalize() {
        title = viewModel.topTitle
    }
    
    func bindUI() {
        setupTableDataSource()
        
        viewModel
            .appAction
            .observeOn(MainScheduler.instance)
            .bind(to: rx.appAction)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Logic
    
    /// Setup data source
    private func setupTableDataSource() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<FavoritesVM.BusinessSection>(configureCell: {
            (_, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .business(let viewModel):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: OrganizationCell.self)
                cell.configureCell(viewModel)
                return cell
            }
        })
        
        dataSource.canEditRowAtIndexPath = { _, _ in return true }
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(FavoritesVM.BusinessSectionModel.self)
            .bind(to: viewModel.modelSelected)
            .disposed(by: disposeBag)
        
        viewModel
            .sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("FavoritesVC deinit")
    }
}
