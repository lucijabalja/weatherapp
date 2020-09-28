//
//  LocationService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 14/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import CoreLocation
import RxCoreLocation
import RxSwift
import RxCocoa

class LocationService {
    
    private let geoCoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    let coordinates: BehaviorRelay<Coordinates> = BehaviorRelay(value: Coordinates(latitude: 0.0, longitude: 0.0))
    private (set) var location: Observable<Coordinates>

    init() {
        location = locationManager.rx
            .didUpdateLocations
            .filter { !$1.isEmpty }
            .map { (locationManager, locations) in
                guard let coord = locations.last?.coordinate else {
                    return Coordinates(latitude: 0, longitude: 0)
                }
                
                return Coordinates(latitude: coord.latitude, longitude: coord.longitude)
            }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
  
    func getLocationCoordinates(location: String) {
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if error == nil {
                guard
                    let placemark = placemarks?[0],
                    let location = placemark.location
                else { return }
                
                let latitude = location.coordinate.latitude.rounded(digits: 2)
                let longitude = location.coordinate.longitude.rounded(digits: 2)
                
                self.coordinates.accept(Coordinates(latitude: latitude, longitude: longitude))
            }
        }
    }
    
    func getLocationName(with coordinates: Coordinates) -> Observable<Result<String, NetworkError>> {
        return Observable.create { observer in
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            self.geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
                guard
                    let placemark = placemarks?.first,
                    let location = placemark.locality
                else {
                    observer.onNext(.failure(.termNotFound))
                    return
                }
                
                observer.onNext(.success(location))
            }
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    
}
