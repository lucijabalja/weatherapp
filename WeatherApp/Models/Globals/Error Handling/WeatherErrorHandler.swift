//
//  WeatherErrorHandler.swift
//  WeatherApp
//
//  Created by Lucija Balja on 27/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

protocol WeatherErrorHandler {
    
    func resolveMessage() -> (String, String)
    
}
