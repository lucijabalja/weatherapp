//
//  UIImageView+Extensions.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func styleView() {
        self.contentMode = .scaleAspectFill
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 35
        self.clipsToBounds = true
        self.tintColor = .white
    }
}
