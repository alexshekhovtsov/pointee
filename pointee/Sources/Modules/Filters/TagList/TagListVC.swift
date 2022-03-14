//
//  TagListVC.swift
//  pointee
//
//  Created by Alexander on 05.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

/**
 Class responsible for displaying tags/cuisines list for selecting.
 */
final class TagListVC: UITableViewController, ViewModelBased {
    
    // MARK: - Properties
    
    var viewModel: TagListVM!

    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func setupUI() {
        tableView.backgroundColor = UIConstants.SpaceBlue
        tableView.register(cellType: TagItemCell.self)
        tableView.separatorStyle = .none
    }
    
    func bindUI() {
        setupTableDataSource()
    }
    
    deinit {
        print("TagListVC deinit")
    }
    
    // MARK: - Logic
    
    /// Setup data source
    private func setupTableDataSource() {
        
        tableView.dataSource = nil
        
        let dataSource = RxTableViewSectionedReloadDataSource<TagListVM.TagSection>(configureCell: {
            (_, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .tagItem(let viewModel):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TagItemCell.self)
                cell.configureCell(viewModel)
                return cell
            }
        })
        
        tableView.rx.itemSelected
            .observeOn(MainScheduler.instance)
            .map({ return $0.section })
            .bind(to: viewModel.selectedItem)
            .disposed(by: disposeBag)
        
        viewModel
            .sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
