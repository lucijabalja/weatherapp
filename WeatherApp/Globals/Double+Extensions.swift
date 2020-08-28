//
//  Double+Extensions.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

extension Double {
    
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
    
}
