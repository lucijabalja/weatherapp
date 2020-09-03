//
//  Array+Extensions.swift
//  WeatherApp
//
//  Created by Lucija Balja on 20/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

extension Array {
    
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
    
}
