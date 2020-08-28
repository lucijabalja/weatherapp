//
//  TemperatureParametersEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 19/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class TemperatureParametersEntity: NSManagedObject {
    
    class func createFrom(_ temperatureParameters: TemperatureParameters, context: NSManagedObjectContext) -> TemperatureParametersEntity {
        let temperatureParams = TemperatureParametersEntity(context: context)
        
        temperatureParams.current = temperatureParameters.currentTemperature
        temperatureParams.max = temperatureParameters.maxTemperature
        temperatureParams.min = temperatureParameters.minTemperature
        
        return temperatureParams
    }
    
    func update(with temperatureParams: TemperatureParameters) {
        self.current = temperatureParams.currentTemperature
        self.max = temperatureParams.maxTemperature
        self.min = temperatureParams.minTemperature
    }
    
}
