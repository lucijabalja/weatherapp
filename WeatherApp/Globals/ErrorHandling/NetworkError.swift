//
//  ApiResponseError.swift
//  WeatherApp
//
//  Created by Lucija Balja on 20/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    
    case decodingError
    case unwrappingError
    case URLSessionError
    case invalidURLError
    
}

