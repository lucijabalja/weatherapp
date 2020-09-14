//
//  LocationService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 14/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class LocationService {
    
    private let geoCoder = CLGeocoder()
    let coordinates: BehaviorRelay<Coordinates> = BehaviorRelay(value: Coordinates(latitude: 0.0, longitude: 0.0))
    
    func getLocationCoordinates(location: String) {
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if error == nil {
                guard let placemark = placemarks?[0] else { return }
                
                guard let location = placemark.location else { return }
                
                let latitude = location.coordinate.latitude.rounded(digits: 2)
                let longitude = location.coordinate.longitude.rounded(digits: 2)
                
                self.coordinates.accept(Coordinates(latitude: latitude, longitude: longitude))
            }
        }
    }
    
}
