//
//  TagFilterCell.swift
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
import AlignedCollectionViewFlowLayout

class TagsFilterCell: UITableViewCell, NibReusable, UIScrollViewDelegate {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: ContentSizedCollection!
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    private let widthAdditionalSpace: CGFloat = 32
    private let heightAdditionalSpace: CGFloat = 62
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }

        collectionView.register(cellType: TagCell.self)
        
        let layout = AlignedCollectionViewFlowLayout()
        layout.horizontalAlignment = .left
        layout.verticalAlignment = .top
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        collectionView.collectionViewLayout = layout
        
        collectionView.rx.delegate.setForwardToDelegate(self, retainDelegate: false)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: 10000)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
        layoutIfNeeded()
        let size = self.collectionView.collectionViewLayout.collectionViewContentSize
        return CGSize(width: size.width + widthAdditionalSpace, height: size.height + heightAdditionalSpace)
    }

    // MARK: - Logic
    
    func configureCell(_ viewModel: TagsFilterPresentable) {
        
        titleLabel.text = viewModel.title
        
        var sectionedItems: Observable<[TagSection]> {
            let tagSection = viewModel.tags.map { TagSectionModel.tag(viewModel: $0) }
            return Observable.from(optional: [TagSection(model: .tag, items: tagSection)])
        }
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<TagSection>(
            configureCell: { _, collectionView, indexPath, sectionModel in
                switch sectionModel {
                case .tag(let viewModel):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TagCell.self)
                    cell.configureCell(viewModel)
                    return cell
                }
        }, configureSupplementaryView: { (_, _, _, _) in
            return UICollectionReusableView(frame: .zero)
        })
        
        sectionedItems
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let lastItem = self.collectionView.numberOfItems(inSection: indexPath.section) - 1
                if lastItem == indexPath.item {
                    viewModel.addNewAction.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
}

// MARK: - RxDatasource section model
extension TagsFilterCell {
    
    typealias TagSection = SectionModel<TagSectionType, TagSectionModel>
    
    /// Tag Section Type
    ///
    /// - tag: Tag
    enum TagSectionType: Int {
        case tag
    }
    
    /// Tag Section Model
    ///
    /// - tag: Tag
    enum TagSectionModel {
        case tag(viewModel: String)
    }
}
