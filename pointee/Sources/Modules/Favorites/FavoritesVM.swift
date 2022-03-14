//
//  FavoritesVM.swift
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
import CoreLocation

/**
 Class responsible for creating ViewModel instance for Favorites Module.
 */
final class FavoritesVM: VMStepper, ProgressLoaderViewable {
    
    // MARK: - Properties
    
    /// Flow steps
    var steps = PublishRelay<Step>()
    /// Dispose bag
    private let disposeBag = DisposeBag()
    /// App Action
    let appAction = PublishSubject<AppAction>()
    /// View Did Appear
    let didAppear = PublishSubject<Void>()
    /// CoreLocation LocationManager
    private let locationManager = CLLocationManager()
    /// Business Items
    private let businessItems = BehaviorRelay<[BusinessSection]>(value: [])
    /// Section Items
    let sectionedItems: Observable<[BusinessSection]>
    /// Business Model is Selected
    let modelSelected = PublishSubject<BusinessSectionModel>()
    
    private var businessesIDs = Set<String>()
    
    /// Localizable strings
    let topTitle = R.string.localizable.favorites()
    let organizationsTitle = R.string.localizable.organizations()
    let ordersTitle = R.string.localizable.orders()
    
    /// Initialize FavoritesVM ViewModel
    /// - Parameters:
    ///   - userManager: UserManager.
    ///   - userRepository: UserRepository.
    init(userManager: UserManager = UserManager.shared,
         userRepository: UserRepository = UserRepository(apiClient: APIClientMock(filename: "Favorites",
                                                                                  modelType: BusinessesList.self))) {
        sectionedItems = businessItems.asObservable()
        
        didAppear
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let business = userManager.user?.favoritesBusiness, business != self.businessesIDs {
                    self.startLoaderAnimating()
                    userRepository.getFavorites { [weak self] result in
                        guard let self = self else { return }
                        self.stopLoaderAnimation()
                        switch result {
                        case .success(let favoritesBusiness):
                            self.businessesIDs = Set(favoritesBusiness.map({ $0.id }))
                            userManager.user?.favoritesBusiness = self.businessesIDs
                            userManager.save()
                            self.configureSections(businessesList: favoritesBusiness)
                        case .error(let error):
                            self.appAction.onNext(.error(message: error.localizableError))
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("FavoritesVM deinit")
    }
    
    // MARK: - Logic
    
    private func configureSections(businessesList: BusinessesList) {
        var items = [BusinessSection]()
        
        let location = locationManager.location
        
        for business in businessesList {
            let distance = location?.distance(from: CLLocation(latitude: business.latitude,
                                                               longitude: business.longitude))
            
            let businessVM = BusinessFavoritesViewModel(rating: business.rating,
                                                        reviews: business.reviewsCount,
                                                        distance: distance,
                                                        previewURL: URL(string: business.previewURL ?? ""),
                                                        businessStatus: business.currentStatus,
                                                        openCloseDate: business.openCloseDate)
            
            items.append(BusinessSection(model: .business, items: [
                .business(viewModel: BusinessCellViewModel(id: business.id,
                                                           title: business.title,
                                                           logoURL: URL(string: business.logoURL),
                                                           type: .favorites(model: businessVM)))
            ]))
        }
        businessItems.accept(items)
    }
}

protocol BusinessPresentable {
    var id: String { get }
    var title: String { get }
    var logoURL: URL? { get }
    var type: BusinessPresentalbeType { get }
}

enum BusinessPresentalbeType {
    case favorites(model: BusinessFavoritesViewModel)
    case orders(model: BusinessOrdersViewModel)
}

struct BusinessFavoritesViewModel {
    
    var rating: String?
    var reviews: String?
    var distance: String?
    let previewURL: URL?
    let businessStatus: BusinessStatus
    private let openCloseDate: Date?
    
    init(rating: Float?,
         reviews: Int?,
         distance: Double?,
         previewURL: URL?,
         businessStatus: BusinessStatus,
         openCloseDate: Date?) {
        if let rating = rating, let reviews = reviews {
            self.rating = String(rating)
            self.reviews = "(\(reviews.shortCount()))"
        }
        if let distance = distance {
            self.distance = distance.shortDistance()
        }
        self.previewURL = previewURL
        self.businessStatus = businessStatus
        self.openCloseDate = openCloseDate
    }
    
    var timeIcon: UIImage? {
        switch businessStatus {
        case .open:
            return R.image.clockGreen()
        case .closed:
            return R.image.clockRed()
        case .technicalBreak:
            return R.image.technical_break()
        }
    }
    
    var time: String {
        switch businessStatus {
        case .open:
            guard let openCloseDate = openCloseDate else { return businessStatus.toString }
            return R.string.localizable.until(openCloseDate.hourAndMinuteString).capitalized
        case .closed:
            if let openCloseDate = openCloseDate {
                if openCloseDate.isToday {
                    return R.string.localizable.until(openCloseDate.hourAndMinuteString).capitalized
                } else if openCloseDate.isTomorrow {
                    let until = "\(openCloseDate.hourAndMinuteString), \(R.string.localizable.tomorrow())"
                    return R.string.localizable.until(until).capitalized
                } else {
                    let until = "\(openCloseDate.hourAndMinuteString), \(openCloseDate.weekday?.short ?? "")"
                    return R.string.localizable.until(until).capitalized
                }
            } else {
                return businessStatus.toString
            }
        case .technicalBreak:
            return businessStatus.toString
        }
    }
}

struct BusinessOrdersViewModel {
    
    let dateTime: Date
    let amount: String
    let orderStatus: OrderStatus
    
    var dateTimeTitle = ""
    
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
    var orderStatusTitle = ""
}

// MARK: - RxDatasource section model
extension FavoritesVM {
    
    struct BusinessCellViewModel: BusinessPresentable {
        let id: String
        let title: String
        let logoURL: URL?
        let type: BusinessPresentalbeType
    }
    
    typealias BusinessSection = SectionModel<BusinessSectionType, BusinessSectionModel>
    
    /// Business Section Type
    ///
    /// - business: Business
    enum BusinessSectionType: Int {
        case business
    }
    
    /// Business Section Model
    ///
    /// - business: Business
    enum BusinessSectionModel {
        case business(viewModel: BusinessPresentable)
    }
}
