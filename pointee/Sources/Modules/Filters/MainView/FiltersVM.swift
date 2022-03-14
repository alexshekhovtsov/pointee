//
//  FiltersVM.swift
//  pointee
//
//  Created by Alexander on 04.05.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation
import RxSwift
import RxFlow
import RxCocoa
import RxDataSources

/**
 Class responsible for creating ViewModel instance for Filters Module.
 */
final class FiltersVM: VMStepper {
    
    // MARK: - Properties
    
    /// Flow steps
    var steps = PublishRelay<Step>()
    /// Dispose bag
    private let disposeBag = DisposeBag()
    
    private let filterManager: FilterManager
    
    /// Filter Items
    private let filterItems = BehaviorRelay<[FilterSection]>(value: [])
    /// Section Items
    let sectionedItems: Observable<[FilterSection]>
    
    private let typeSelected = PublishSubject<BusinessTypeFilter>()
    private let addNewTagAction = PublishSubject<Void>()
    private let addNewCuisineAction = PublishSubject<Void>()
    let applyAction = PublishSubject<Void>()
    let clearAction = PublishSubject<Void>()
    
    /// Localizable strings
    let topTitle = R.string.localizable.filters()
    let clearTitle = R.string.localizable.clear()
    let applyTitle = R.string.localizable.apply()
    private let addTitle = R.string.localizable.add_plus()
    
    private let selectedTags: BehaviorRelay<[String]>
    
    private let selectedCuisines: BehaviorRelay<[String]>
    
    /// Initialize FiltersVM ViewModel
    /// - Parameter filterManager: FilterManager
    init(filterManager: FilterManager = FilterManager.shared) {
        self.filterManager = filterManager
        self.selectedTags = BehaviorRelay<[String]>(value: filterManager.tagsFilter)
        self.selectedCuisines = BehaviorRelay<[String]>(value: filterManager.cuisinesFilter)
        sectionedItems = filterItems.asObservable()
        
        addNewTagAction
            .throttle(UIConstants.throttle, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.steps.accept(FiltersStep.tagsList(selectedTags: self.selectedTags, allTags: filterManager.allTags))
            })
            .disposed(by: disposeBag)
        
        addNewCuisineAction
            .throttle(UIConstants.throttle, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.steps.accept(FiltersStep.tagsList(selectedTags: self.selectedCuisines,
                                                       allTags: filterManager.allCuisines))
            })
            .disposed(by: disposeBag)
        
        typeSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                self.filterManager.toggle(type)
                self.configureSections()
            })
            .disposed(by: disposeBag)
        
        Driver.combineLatest(selectedTags.asDriver(), selectedCuisines.asDriver())
            .asDriver()
            .drive(onNext: { [weak self] tags, cuisines in
                guard let self = self else { return }
                filterManager.tagsFilter = tags
                filterManager.cuisinesFilter = cuisines
                self.configureSections()
            })
            .disposed(by: disposeBag)
        
        applyAction
            .observeOn(MainScheduler.instance)
            .map { FiltersStep.dismiss }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        clearAction
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.filterManager.setDefaults()
                self.selectedTags.accept([])
                self.selectedCuisines.accept([])
                self.configureSections()
            })
            .disposed(by: disposeBag)
        
        configureSections()
    }
    
    deinit {
        print("FiltersVM deinit")
    }
    
    // MARK: - Logic
    
    private func configureSections() {
        var items = [FilterSection]()
        items.append(FilterSection(model: .type, items: [
            .type(viewModel: TypeFilterCellViewModel(types: filterManager.typesFilter, typeSelected: typeSelected))
        ]))
        
        var tags = filterManager.tagsFilter
        tags.append(addTitle)
        items.append(FilterSection(model: .tags, items: [
            .tags(viewModel: TagsFilterCellViewModel(tags: tags, addNewAction: addNewTagAction))
        ]))
        
        var cuisines = filterManager.cuisinesFilter
        cuisines.append(addTitle)
        items.append(FilterSection(model: .cuisines, items: [
            .cuisines(viewModel: CuisinesFilterCellViewModel(tags: cuisines, addNewAction: addNewCuisineAction))
        ]))
        
        items.append(FilterSection(model: .averageCheck, items: [
            .averageCheck(viewModel: AverageCheckViewModel(minValue: filterManager.averageCheckMinValue,
                                                           maxValue: filterManager.averageCheckMaxValue,
                                                           values: filterManager.averageCheck,
                                                           checkStep: filterManager.checkStep,
                                                           minimumCheckDistance: filterManager.minimumCheckDistance))
        ]))
        filterItems.accept(items)
    }
}

protocol TypeFilterPresentable {
    var title: String { get }
    var types: [BusinessTypeFilter] { get }
    var typeSelected: PublishSubject<BusinessTypeFilter> { get }
}

protocol TagsFilterPresentable {
    var title: String { get }
    var tags: [String] { get }
    var addNewAction: PublishSubject<Void> { get }
}

protocol AverageCheckPresentable {
    var title: String { get }
    var fromTitle: String { get }
    var toTitle: String { get }
    var minValue: Int { get }
    var maxValue: Int { get }
    var values: BehaviorRelay<AverageCheckValues> { get }
    var checkStep: CGFloat { get }
    var minimumCheckDistance: CGFloat { get }
}

// MARK: - RxDatasource section model
extension FiltersVM {
    
    struct TypeFilterCellViewModel: TypeFilterPresentable {
        let title: String = R.string.localizable.organization_type()
        let types: [BusinessTypeFilter]
        let typeSelected: PublishSubject<BusinessTypeFilter>
    }
    
    struct TagsFilterCellViewModel: TagsFilterPresentable {
        let title: String = R.string.localizable.by_tags()
        let tags: [String]
        let addNewAction: PublishSubject<Void>
    }
    
    struct CuisinesFilterCellViewModel: TagsFilterPresentable {
        let title: String = R.string.localizable.by_cuisine()
        let tags: [String]
        let addNewAction: PublishSubject<Void>
    }
    
    struct AverageCheckViewModel: AverageCheckPresentable {
        let title: String = R.string.localizable.average_check()
        let fromTitle: String = R.string.localizable.from()
        let toTitle: String = R.string.localizable.to()
        let minValue: Int
        let maxValue: Int
        let values: BehaviorRelay<AverageCheckValues>
        let checkStep: CGFloat
        let minimumCheckDistance: CGFloat
    }
    
    typealias FilterSection = SectionModel<FilterSectionType, FilterSectionModel>
    
    /// Filter Section Type
    ///
    /// - filter: Filter
    enum FilterSectionType: Int {
        case type
        case tags
        case cuisines
        case averageCheck
    }
    
    /// Filter Section Model
    ///
    /// - filter: Filter
    enum FilterSectionModel {
        case type(viewModel: TypeFilterPresentable)
        case tags(viewModel: TagsFilterPresentable)
        case cuisines(viewModel: TagsFilterPresentable)
        case averageCheck(viewModel: AverageCheckPresentable)
    }
}
