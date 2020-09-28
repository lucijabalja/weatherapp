//
//  ApiResponseError.swift
//  WeatherApp
//
//  Created by Lucija Balja on 20/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

enum NetworkError: Error, WeatherErrorHandler {
    
    case decodingError, unwrappingError, URLSessionError, invalidURLError, termNotFound
    
    func resolveMessage() -> (String, String){
        switch self {
        case .URLSessionError:
            return (ErrorMessage.noInternetConnection, ErrorMessage.turnInternetConnection)
        case .termNotFound:
            return (ErrorMessage.noLocationFound, ErrorMessage.tryAgain)
        @unknown default:
            return (ErrorMessage.loadingError, ErrorMessage.tryAgain)
        }
    }
}

