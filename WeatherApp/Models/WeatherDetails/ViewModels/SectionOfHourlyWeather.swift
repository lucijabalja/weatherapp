//
//  SectionOfHourlyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 15/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import RxDataSources

struct SectionOfHourlyWeather {
    var items: [Item]
}

extension SectionOfHourlyWeather: SectionModelType {
    typealias Item = HourlyWeather
    
    init(original: SectionOfHourlyWeather, items: [Item]) {
        self = original
        self.items = items
    }
}
