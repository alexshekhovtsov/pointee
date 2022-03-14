//
//  CartManager.swift
//  pointee
//
//  Created by Alexander on 26.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import RxSwift
import RxCocoa

typealias CartItem = (product: Product, count: Int)

final class CartManager {
    
    static let shared = CartManager()
    
    private init() {
        products = items.asDriver()
        amount = items.asDriver().map({ $0.map({ Float($0.count) * $0.product.price }).reduce(0, +) })
    }
    
    /// Hidden cart items
    private let items = BehaviorRelay<[CartItem]>(value: [])
    /// Driver of Products
    var products: Driver<[CartItem]>
    
    var amount: Driver<Float>
    
    func put(_ product: Product) {
        var allItems = items.value
        if let existedItemIndex = allItems.firstIndex(where: { $0.product.barcode == product.barcode }) {
            allItems[existedItemIndex].count += 1
        } else {
            allItems.append((product: product, count: 1))
        }
        items.accept(allItems)
    }
    
    func delete(_ product: Product) {
        delete(with: product.barcode)
    }
    
    func delete(with barcode: String) {
        var allItems = items.value
        if let index = allItems.firstIndex(where: { $0.product.barcode == barcode }) {
            if allItems[index].count > 1 {
                allItems[index].count -= 1
            } else {
                allItems.remove(at: index)
            }
        }
        items.accept(allItems)
    }
    
    func clear() {
        items.accept([])
    }
}
