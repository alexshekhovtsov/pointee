//
//  BusinessTypeCell.swift
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

class TypeFilterCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: ContentSizedTableView!
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    private let heightAdditionalSpace: CGFloat = 30
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(cellType: BusinessTypeCell.self)
        tableView.rowHeight = 50
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.tableView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: 10000)
        self.tableView.layoutIfNeeded()
        let size = self.tableView.contentSize
        return CGSize(width: size.width, height: size.height + heightAdditionalSpace)
    }
    
    // MARK: - Logic
    
    func configureCell(_ viewModel: TypeFilterPresentable) {
        
        titleLabel.text = viewModel.title
        
        var sectionedItems: Observable<[TypeSection]> {
            let accountSection = viewModel.types.map {
                TypeSectionModel.type(viewModel: TypeCellViewModel(typeFilter: $0, isEnabled: true))
            }
            return Observable.from(optional: [
                TypeSection(model: .type, items: accountSection),
                TypeSection(model: .soon, items: [TypeSectionModel.soon(viewModel: SoonCellViewModel())])
            ])
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource<TypeSection>(configureCell: {
            (_, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .type(let viewModel):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BusinessTypeCell.self)
                cell.configureCell(viewModel)
                return cell
            case .soon(let viewModel):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BusinessTypeCell.self)
                cell.configureCell(viewModel)
                return cell
            }
        })
        
        tableView.rx.modelSelected(TypeSectionModel.self)
            .asDriver()
            .drive(onNext: { sectionModel in
                guard case .type(let model) = sectionModel else { return }
                viewModel.typeSelected.onNext(model.typeFilter)
            })
            .disposed(by: disposeBag)
        
        sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

protocol TypePresentable {
    var title: String { get }
    var image: UIImage? { get }
    var isEnabled: Bool { get }
    var aplha: CGFloat { get }
}

protocol TypePresentableHasFilter: TypePresentable {
    var typeFilter: BusinessTypeFilter { get }
}

// MARK: - RxDatasource section model
extension TypeFilterCell {
    
    struct TypeCellViewModel: TypePresentableHasFilter {
        let typeFilter: BusinessTypeFilter
        let isEnabled: Bool
        
        var title: String {
            return typeFilter.type.filterDescription
        }
        
        var image: UIImage? {
            return typeFilter.active ? R.image.circleTick() : R.image.circle()
        }
        
        var aplha: CGFloat {
            return isEnabled ? 1 : 0.5
        }
    }
    
    struct SoonCellViewModel: TypePresentable {
        let typeFilter = BusinessTypeFilter(type: .shop, active: false)
        let isEnabled: Bool = false
        let title: String = R.string.localizable.coming_soon()
        let image: UIImage? = R.image.circle()
        
        var aplha: CGFloat {
            return isEnabled ? 1 : 0.5
        }
    }
    
    typealias TypeSection = SectionModel<TypeSectionType, TypeSectionModel>
    
    /// Type Section Type
    ///
    /// - type: Type
    enum TypeSectionType: Int {
        case type
        case soon
    }
    
    /// Type Section Model
    ///
    /// - type: Type
    enum TypeSectionModel {
        case type(viewModel: TypePresentableHasFilter)
        case soon(viewModel: TypePresentable)
    }
}
