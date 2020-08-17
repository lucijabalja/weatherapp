//
//  ApiRresponseStatus.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

enum WeatherApiResponse {
    
    case SUCCESSFUL(data: WeatherResponseProtocol)
    case FAILED(error: String)
}
