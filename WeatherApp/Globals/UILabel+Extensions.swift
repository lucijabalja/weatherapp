//
//  UISetup.swift
//  WeatherApp
//
//  Created by Lucija Balja on 06/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

extension UILabel {
    
    func style(size: CGFloat = 20.0, textAlignment: NSTextAlignment = .center) {
        self.font = .boldSystemFont(ofSize: size)
        self.textColor = .white
        self.textAlignment = textAlignment
        self.clipsToBounds = true
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
