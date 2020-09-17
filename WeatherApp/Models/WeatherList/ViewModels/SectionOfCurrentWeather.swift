//
//  SectionOfCurrentWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 15/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import RxDataSources

struct SectionOfCurrentWeather {
    var items: [Item]
}

extension SectionOfCurrentWeather: AnimatableSectionModelType {
    var identity: String {
        return ""
    }
    
    typealias Identity = String
    
    typealias Item = CurrentWeather
    
    init(original: SectionOfCurrentWeather, items: [Item]) {
        self = original
        self.items = items
    }
}
