//
//  WeatherDescription.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct WeatherDescription: Decodable {
    
    let conditionID: Int
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case conditionID = "id"
        case weatherDescription = "description"
    }
}
