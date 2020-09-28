//
//  CurrentDetailsEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 28/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class CurrentDetailsEntity: NSManagedObject {

    class func createFrom(currentDetails: CurrentWeatherDetails, context: NSManagedObjectContext) -> CurrentDetailsEntity {
        let currentDetailsEntity = CurrentDetailsEntity(context: context)
        currentDetailsEntity.sunrise = currentDetails.sunrise
        currentDetailsEntity.sunset = currentDetails.sunset
        currentDetailsEntity.feelsLike = currentDetails.feelsLike
        currentDetailsEntity.humidity = currentDetails.humidity
        currentDetailsEntity.pressure = currentDetails.pressure
        currentDetailsEntity.visibility = currentDetails.visibility
        return currentDetailsEntity
    }
    
    func update(with currentDetails: CurrentWeatherDetails) {
        self.sunrise = currentDetails.sunrise
        self.sunset = currentDetails.sunset
        self.feelsLike = currentDetails.feelsLike
        self.humidity = currentDetails.humidity
        self.pressure = currentDetails.pressure
    }
    
}
