//
//  MapVC.swift
//  pointee
//
//  Created by Alexander on 21.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import GoogleMaps
import LBTATools
import Kingfisher

/**
 Class responsible for displaying map with points.
 */
final class MapVC: UIViewController, StoryboardBased, ViewModelBased {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var listViewButton: UIBarButtonItem!
    
    @IBOutlet weak var filtersButton: UIBarButtonItem!
    
    // MARK: - UI Properties
    
    private let latitudeKharkiv: CLLocationDegrees = 50.005479
    private let longitudeKharkiv: CLLocationDegrees = 50.005479
    private let minimumZoom: Float = 16
    private let targetZoom: Float = 15.5
    
    lazy var camera: GMSCameraPosition = {
        return GMSCameraPosition.camera(withLatitude: latitudeKharkiv, longitude: longitudeKharkiv, zoom: targetZoom)
    }()
    
    let mapContainer = UIView()
    
    lazy var mapView: GMSMapView = {
        let view = GMSMapView.map(withFrame: mapContainer.frame, camera: camera)
        view.isMyLocationEnabled = true
        return view
    }()
    
    let detailsButton = UIButton()
    
    lazy var detaisContainer: UIView = {
        let view = UIView(backgroundColor: .white)
        view.layer.cornerRadius = UIConstants.cornerRadius + 1
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var imageContainer: UIView = {
        let view = UIView(backgroundColor: .white)
        view.withSize(CGSize(width: UIConstants.imageContainerSize, height: UIConstants.imageContainerSize))
        view.layer.cornerRadius = UIConstants.imageContainerSize / 2
        return view
    }()
    
    lazy var image: UIImageView = {
        let view = UIImageView(image: R.image.photo_placeholder())
        view.layer.cornerRadius = UIConstants.imageContainerSize / 2 - 1
        return view
    }()
    
    lazy var reviewsLabel: UILabel = {
        let label = UILabel()
        label.style(.title(textColor: UIConstants.SpaceBlue,
                           textAlignment: .left,
                           font: .appFontBold(atSize: UIConstants.fontSize),
                           numberOfLines: 1))
        return label
    }()
    
    lazy var reviewsView: UIView = {
        let view = UIView()
        let stack = UIView().hstack(UIImageView(image: R.image.star_reviews()).withSize(UIConstants.iconSize),
                                    self.reviewsLabel,
                                    spacing: UIConstants.marginMinimum)
        view.addSubview(stack)
        stack.anchor(top: view.topAnchor, leading: nil, bottom: view.bottomAnchor, trailing: nil)
        stack.centerXTo(view.centerXAnchor)
        return view
    }()
    
    lazy var destinationLabel: UILabel = {
        let label = UILabel()
        label.style(.title(textColor: UIConstants.SpaceBlue,
                           textAlignment: .left,
                           font: .appFontBold(atSize: UIConstants.fontSize),
                           numberOfLines: 1))
        return label
    }()
    
    lazy var destinationView: UIView = {
        let view = UIView()
        let stack = UIView().hstack(UIImageView(image: R.image.navigation()).withSize(UIConstants.iconSize),
                                    self.destinationLabel,
                                    spacing: UIConstants.marginMinimum)
        view.addSubview(stack)
        stack.anchor(top: view.topAnchor, leading: nil, bottom: view.bottomAnchor, trailing: nil)
        stack.centerXTo(view.centerXAnchor)
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.style(.title(textColor: UIConstants.Green,
                           textAlignment: .left,
                           font: .appFontBold(atSize: UIConstants.fontSize),
                           numberOfLines: 1))
        return label
    }()
    
    lazy var timeView: UIView = {
        let view = UIView()
        let image = UIImageView(image: R.image.clockGreen()).withSize(UIConstants.iconSize)
        image.tintColor = UIConstants.Green
        let stack = UIView().hstack(image,
                                    timeLabel,
                                    spacing: UIConstants.marginMinimum)
        view.addSubview(stack)
        stack.anchor(top: view.topAnchor, leading: nil, bottom: view.bottomAnchor, trailing: nil)
        stack.centerXTo(view.centerXAnchor)
        return view
    }()
    
    private var activeMarker: GMSMarker? {
        didSet {
            oldValue?.icon = R.image.map_pin_unactive()?.image(alpha: 0)
            activeMarker?.icon = R.image.map_pin_active()?.image(alpha: 0)
            
            let coefficient: CGFloat = activeMarker == nil ? 1 : -1
            
            UIView.animate(withDuration: UIConstants.animationTime, delay: 0.0, options: [.curveEaseOut], animations: {
                let yTransform = coefficient * (self.detaisContainer.frame.height + self.imageContainer.frame.height / 2)
                let transform = CGAffineTransform(translationX: 0, y: yTransform)
                self.detaisContainer.transform = transform
            }, completion: nil)
        }
    }
    
    let businessTitleLabel = UILabel()
    
    private let imagePadding: CGFloat = 2
    
    // MARK: - Properties
    
    var viewModel: MapVM!
    
    private let disposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    
    private var markers = [GMSMarker]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.didAppear.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.activeMarker = nil
    }
    
    func setupUI() {
        view.addSubview(mapContainer)
        mapContainer.fillSuperview()
        
        mapContainer.addSubview(mapView)
        mapView.fillSuperview()
        mapView.delegate = self
        
        addDetailsContainer()
        
        initializeTheLocationManager()
    }
    
    func setupLocalize() {
        navigationItem.title = viewModel.topTitle
    }
    
    func bindUI() {
        viewModel.businessesList
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                self.markers.removeAll()
                list.forEach { location in
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                    marker.title = location.title
                    marker.shouldGroupAccessibilityChildren = true
                    marker.icon = R.image.map_pin_unactive()?.image(alpha: 0)
                    marker.map = self.mapView
                    self.markers.append(marker)
                }
            })
            .disposed(by: disposeBag)
        
        detailsButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.detailsAction)
            .disposed(by: disposeBag)
        
        listViewButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.listViewAction)
            .disposed(by: disposeBag)
        
        filtersButton.rx.tap
            .asDriver()
            .throttle(UIConstants.throttle)
            .drive(viewModel.filtersAction)
            .disposed(by: disposeBag)
        
        viewModel
            .appAction
            .observeOn(MainScheduler.instance)
            .bind(to: rx.appAction)
            .disposed(by: disposeBag)
    }
    
    private func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func addDetailsContainer() {
        mapContainer.addSubview(detaisContainer)
        detaisContainer.anchor(top: mapContainer.bottomAnchor,
                               leading: mapContainer.leadingAnchor,
                               bottom: nil,
                               trailing: mapContainer.trailingAnchor,
                               padding: UIEdgeInsets(top: UIConstants.marginL,
                                                     left: 0,
                                                     bottom: 0,
                                                     right: 0))
        detaisContainer.addSubview(imageContainer)
        imageContainer.anchor(top: detaisContainer.topAnchor,
                              leading: detaisContainer.leadingAnchor,
                              bottom: nil,
                              trailing: nil,
                              padding: UIEdgeInsets(top: -UIConstants.marginL,
                                                    left: UIConstants.marginM,
                                                    bottom: 0,
                                                    right: 0))
        imageContainer.addSubview(image)
        image.fillSuperview(padding: UIEdgeInsets(top: imagePadding,
                                                  left: imagePadding,
                                                  bottom: imagePadding,
                                                  right: imagePadding))
        imageContainer.addSubview(businessTitleLabel)
        businessTitleLabel.style(.title(textColor: UIConstants.SpaceBlue,
                                        textAlignment: .left,
                                        font: .appFontBold(atSize: UIConstants.fontSizeMiddle),
                                        numberOfLines: 0))
        businessTitleLabel.anchor(top: nil,
                                  leading: imageContainer.trailingAnchor,
                                  bottom: imageContainer.bottomAnchor,
                                  trailing: detaisContainer.trailingAnchor,
                                  padding: UIEdgeInsets(top: 0,
                                                        left: UIConstants.marginMinimum,
                                                        bottom: 0,
                                                        right: UIConstants.marginS))
        let details = UIView().hstack(reviewsView,
                                      destinationView,
                                      timeView,
                                      spacing: 0,
                                      alignment: .center,
                                      distribution: .fillEqually)
        detaisContainer.addSubview(details)
        details.anchor(top: businessTitleLabel.bottomAnchor,
                       leading: detaisContainer.leadingAnchor,
                       bottom: detaisContainer.bottomAnchor,
                       trailing: detaisContainer.trailingAnchor,
                       padding: UIEdgeInsets(top: UIConstants.marginS,
                                             left: 0,
                                             bottom: UIConstants.marginS,
                                             right: 0))
        
        detaisContainer.addSubview(detailsButton)
        detailsButton.fillSuperview()
        detaisContainer.addShadow(corners: [.topRight, .topLeft])
    }

    deinit {
        print("MapVC deinit")
    }
}

extension MapVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            guard let lastLocation = locations.last else { return }
            mapView.camera = GMSCameraPosition.camera(withTarget: lastLocation.coordinate, zoom: targetZoom)
            mapView.settings.myLocationButton = true
            locationManager.stopUpdatingLocation()
        }
    }
}

extension MapVC: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        activeMarker = marker
        
        if let location = locationManager.location {
            let distance = location.distance(from: CLLocation(latitude: marker.position.latitude,
                                                              longitude: marker.position.longitude))
            destinationLabel.text = R.string.localizable.km(String(format: "%.01f", distance / 1000))
        }
        businessTitleLabel.text = marker.title
        
        mapView.animate(to: GMSCameraPosition.camera(withTarget: marker.position,
                                                     zoom: max(minimumZoom, mapView.camera.zoom)))
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print(position.zoom)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        activeMarker = nil
        print(coordinate)
    }
}

extension UIImage {

    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
