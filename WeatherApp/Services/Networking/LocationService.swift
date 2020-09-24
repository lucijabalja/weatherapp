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
    let coordinates: BehaviorRelay<Coordinates> = BehaviorRelay(value: Coordinates(latitude: 0.0, longitude: 0.0))
    let currentCoordinates: Observable<Coordinates>
    
    init() {
        currentCoordinates = locationManager
            .rx
            .didUpdateLocations
            .filter { !$1.isEmpty }
            .map { locationManager, locations in
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
                    let location = placemark.location else {
                    return
                }
                
                let latitude = location.coordinate.latitude.rounded(digits: 2)
                let longitude = location.coordinate.longitude.rounded(digits: 2)
                
                self.coordinates.accept(Coordinates(latitude: latitude, longitude: longitude))
            }
        }
    }
    
    func getLocationName(coordinates:  Coordinates) -> String {
        var locationName = ""
        let semaphore = DispatchSemaphore(value: 0)
        
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { (placemark, error) in
            guard let location = placemark?[0].locality else { return }
            locationName = location
            semaphore.signal()
        }
        
        semaphore.wait()
        return locationName
    }
    
}
