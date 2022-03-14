//
//  OrdersVM.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation
import RxSwift
import RxFlow
import RxCocoa
import RxDataSources

/**
 Class responsible for creating ViewModel instance for Orders Module.
 */
final class OrdersVM: VMStepper {
    
    // MARK: - Properties
    
    /// Flow steps
    var steps = PublishRelay<Step>()
    /// Dispose bag
    private let disposeBag = DisposeBag()
    /// App Action
    let appAction = PublishSubject<AppAction>()
    /// View Did Appear
    let didAppear = PublishSubject<Void>()
    /// Order Repository
    private var orderRepository: OrderRepository
    /// Order Items
    private let orderItems = BehaviorRelay<[OrderSection]>(value: [])
    /// Section Items
    let sectionedItems: Observable<[OrderSection]>
    /// Business Model is Selected
    let modelSelected = PublishSubject<OrderSection>()
    /// Localizable strings
    let topTitle = R.string.localizable.orders()
    
    /// Initialize OrdersVM ViewModel
    /// - Parameter orderRepository: OrderRepository
    init(orderRepository: OrderRepository = OrderRepository(apiClient: APIClientMock(filename: "Orders",
                                                                                     modelType: Orders.self))) {
        self.orderRepository = orderRepository
        sectionedItems = orderItems.asObservable()
        
        orderRepository.getUserOrders { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let orders):
                self.configureSections(orders: orders)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    deinit {
        print("OrdersVM deinit")
    }
    
    // MARK: - Logic
    
    private func configureSections(orders: Orders) {
        var items = [OrderSection]()
        
        for order in orders {
            items.append(OrderSection(model: .order, items: [
                .order(viewModel: OrderCellViewModel(title: order.title,
                                                     logoURL: URL(string: order.logoURL ?? ""),
                                                     dateTime: order.statusDate,
                                                     amount: R.string.localizable.uah_currency(
                                                        order.amount.priceString()
                                                     ),
                                                     orderStatus: order.status))
            ]))
        }
        orderItems.accept(items)
    }
}

protocol OrderPresentable {
    var title: String { get }
    var logoURL: URL? { get }
    var dateTime: Date { get }
    var amount: String { get }
    var orderStatus: OrderStatus { get }
    var dateTimeTitle: String { get }
    var orderStatusIcon: UIImage? { get }
    var orderStatusTitle: String { get }
}

// MARK: - RxDatasource section model
extension OrdersVM {
    
    struct OrderCellViewModel: OrderPresentable {
        let title: String
        let logoURL: URL?
        let dateTime: Date
        let amount: String
        let orderStatus: OrderStatus
        
        var dateTimeTitle: String {
            return dateTime.hourAndMinuteString
        }
        var orderStatusIcon: UIImage? {
            switch orderStatus {
            case .successful:
                return R.image.checkCircle()
            case .canceled:
                return R.image.xCircle()
            case .problem:
                return R.image.alertCircle()
            default:
                return nil
            }
        }
        var orderStatusTitle: String {
            return orderStatus.toString
        }
    }
    
    typealias OrderSection = SectionModel<OrderSectionType, OrderSectionModel>
    
    /// Order Section Type
    ///
    /// - order: Order
    enum OrderSectionType: Int {
        case order
    }
    
    /// Order Section Model
    ///
    /// - order: Order
    enum OrderSectionModel {
        case order(viewModel: OrderPresentable)
    }
}
