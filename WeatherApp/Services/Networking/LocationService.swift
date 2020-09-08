//
//  LocationService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 14/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService {
    
    private let geoCoder = CLGeocoder()
    
    func getLocationCoordinates(location: String, completion: @escaping (Double, Double) -> Void) {
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if error == nil {
                guard let placemark = placemarks?[0] else { return }
                
                guard let location = placemark.location else { return }
            
                let latitude = location.coordinate.latitude.rounded(digits: 2)
                let longitude = location.coordinate.longitude.rounded(digits: 2)
                
                completion(latitude, longitude)
            }
        }
    }

}
