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
    
    func getLocationCoordinates(location: String, completion: @escaping (String, String) -> Void) {
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if error == nil {
                guard let placemark = placemarks?[0] else { return }
                
                guard let location = placemark.location else { return }
            
                completion("\(location.coordinate.latitude)", "\(location.coordinate.longitude)")
            }
        }
    }
    
}
