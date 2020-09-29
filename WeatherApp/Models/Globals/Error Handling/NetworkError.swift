//
//  ApiResponseError.swift
//  WeatherApp
//
//  Created by Lucija Balja on 20/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

enum NetworkError: Error, ErrorHandler {
    
    case decodingError, invalidURLError, unwrappingError, URLSessionError, termNotFound, noInternetConnection
        
    var message: (String, String) {
        switch self {
        case .decodingError:
            return (ErrorMessage.decodingError, ErrorMessage.tryAgain)
        case .invalidURLError:
            return (ErrorMessage.invalidURLError, ErrorMessage.tryAgain)
        case .unwrappingError:
            return (ErrorMessage.unwrappingError, ErrorMessage.tryAgain)
        case .URLSessionError:
            return (ErrorMessage.urlSessionError, ErrorMessage.tryAgain)
        case .termNotFound:
            return (ErrorMessage.cityNotFound, ErrorMessage.tryAnother)
        case .noInternetConnection:
            return (ErrorMessage.noInternetConnection, ErrorMessage.turnInternetConnection)
        }
    }
    
}

