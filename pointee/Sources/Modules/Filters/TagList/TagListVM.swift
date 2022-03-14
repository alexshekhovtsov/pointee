//
//  TagListVM.swift
//  pointee
//
//  Created by Alexander on 05.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation
import RxSwift
import RxFlow
import RxCocoa
import RxDataSources

/**
 Class responsible for creating ViewModel instance for TagList Module.
 */
final class TagListVM: VMStepper {
    
    // MARK: - Properties
    
    /// Flow steps
    var steps = PublishRelay<Step>()
    /// Dispose bag
    private let disposeBag = DisposeBag()
    /// Selected tags
    private let selectedTags: BehaviorRelay<[String]>
    /// Tags
    private let allTags: [String]
    /// Selected item
    let selectedItem = PublishSubject<Int>()
    /// Tags Items
    private let tagsItems = BehaviorRelay<[TagSection]>(value: [])
    /// Section Items for List
    let sectionedItems: Observable<[TagSection]>
    
    /// Initialize TagListVM ViewModel
    /// - Parameters:
    ///   - selectedTags: Array of selected tags
    ///   - allTags: Array of all available tags
    init(selectedTags: BehaviorRelay<[String]>, allTags: [String]) {
        sectionedItems = tagsItems.asObservable()
        self.selectedTags = selectedTags
        self.allTags = allTags
        
        selectedItem
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let selectedTag = self.allTags[index]
                var tags = self.selectedTags.value
                if let existedIndex = tags.firstIndex(of: selectedTag) {
                    tags.remove(at: existedIndex)
                } else {
                    tags.append(selectedTag)
                }
                self.selectedTags.accept(tags)
                self.configureSections()
            })
            .disposed(by: disposeBag)
        
        configureSections()
    }
    
    deinit {
        print("TagListVM deinit")
    }
    
    // MARK: - Logic
        
    /// Configure sections
    private func configureSections() {
        var sections = [TagSection]()
        
        for tag in allTags {
            sections.append(TagSection(model: .tagItem, items: [
                .tagItem(viewModel: TagViewModel(title: tag, isOn: selectedTags.value.contains(tag)))
            ]))
        }
        tagsItems.accept(sections)
    }
}

/// SelectableTagPresentable
protocol SelectableTagPresentable {
    var title: String { get }
    var isOn: Bool { get }
}

extension TagListVM {
    
    /// TagViewModel
    struct TagViewModel: SelectableTagPresentable {
        let title: String
        let isOn: Bool
    }
    
    typealias TagSection = SectionModel<TagSectionType, TagSectionModel>
    
    /// Tag Section Type
    ///
    /// - tagItem: Tag with title
    enum TagSectionType: Int {
        case tagItem
    }
    
    /// Tag Section Model
    ///
    /// - tagItem: Section with tag
    enum TagSectionModel {
        case tagItem(viewModel: SelectableTagPresentable)
    }
}
