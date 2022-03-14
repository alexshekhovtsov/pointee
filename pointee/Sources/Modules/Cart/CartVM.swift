//
//  CartVM.swift
//  pointee
//
//  Created by Alexander on 26.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation
import RxSwift
import RxFlow
import RxCocoa
import RxDataSources

/**
 Class responsible for creating ViewModel instance for Cart Module.
 */
final class CartVM: VMStepper {
    
    // MARK: - Properties
    
    /// Flow steps
    var steps = PublishRelay<Step>()
    /// Dispose bag
    private let disposeBag = DisposeBag()
    /// Make Step On Current Flow
    private let makeStep = BehaviorRelay<CartStep?>(value: nil)
    /// View Did Appear
    let didAppear = PublishSubject<Void>()
    
    private let cartManager: CartManager
    
    /// Delete product
    let deleteProduct = PublishSubject<ProductSectionModel>()
    /// Make Order Action
    let makeOrderAction = PublishSubject<Void>()
    /// Array of products in Cart
    private var products = [CartItem]()
    /// Product Items
    private let productItems = BehaviorRelay<[ProductSection]>(value: [])
    /// Section Items
    let sectionedItems: Observable<[ProductSection]>
    
    let amount = BehaviorRelay<Float>(value: 0)
    let amountValueTitle: Driver<String>
    
    /// Localizable strings
    let topTitle = R.string.localizable.cart()
    let payWithCardTitle = R.string.localizable.pay_with_card()
    let amountTitle = R.string.localizable.amount()
    
    private weak var root: UINavigationController?
    
    /// Initialize CartVM ViewModel
    /// - Parameters:
    ///   - cartManager: CartManager.
    ///   - root: UINavigationController for LiqPay screen.
    init(cartManager: CartManager = CartManager.shared,
         root: UINavigationController) {
        
        self.cartManager = cartManager
        self.root = root
        sectionedItems = productItems.asObservable()
        amountValueTitle = amount.asDriver().map({ R.string.localizable.uah_currency(String(format: "%.2f", $0)) })
        
        cartManager.amount
            .asDriver()
            .drive(amount)
            .disposed(by: disposeBag)
        
        cartManager.products
            .asDriver()
            .drive(onNext: { [weak self] items in
                guard let self = self else { return }
                self.products = items
                self.configureSections()
            })
            .disposed(by: disposeBag)
        
        deleteProduct
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { model in
                guard case .product(let viewModel) = model else { return }
                cartManager.delete(with: viewModel.barcode)
            })
            .disposed(by: disposeBag)
        
        didAppear
            .observeOn(MainScheduler.instance)
            .withLatestFrom(makeStep)
            .subscribe(onNext: { [weak self] step in
                guard let self = self, let step = step else { return }
                self.steps.accept(step)
                self.makeStep.accept(nil)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("CartVM deinit")
    }
    
    // MARK: - Logic
    
    private func configureSections() {
        var items = [ProductSection]()

        for (product, count) in products {
            items.append(ProductSection(model: .product, items: [
                .product(viewModel: ProductCellViewModel(barcode: product.barcode,
                                                         title: product.title,
                                                         productImage: URL(string: product.imageURL),
                                                         price: R.string.localizable.uah_currency(String(product.price)),
                                                         count: count))
            ]))
        }
        productItems.accept(items)
    }
}

protocol ProductPresentable {
    var barcode: String { get }
    var title: String { get }
    var productImage: URL? { get }
    var price: String { get }
    var count: Int { get }
}

// MARK: - RxDatasource section model
extension CartVM {
    
    struct ProductCellViewModel: ProductPresentable {
        let barcode: String
        let title: String
        let productImage: URL?
        let price: String
        let count: Int
    }
    
    typealias ProductSection = SectionModel<ProductSectionType, ProductSectionModel>
    
    /// Product Section Type
    ///
    /// - product: Product
    enum ProductSectionType: Int {
        case product
    }
    
    /// Product Section Model
    ///
    /// - product: Product
    enum ProductSectionModel {
        case product(viewModel: ProductPresentable)
    }
}
