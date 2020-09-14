//
//  UISetup.swift
//  WeatherApp
//
//  Created by Lucija Balja on 06/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

extension UILabel {
    
    func style(fontSize: CGFloat = 20.0, textAlignment: NSTextAlignment = .center) {
        self.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        self.textColor = .mainLabelColor
        self.textAlignment = textAlignment
        self.clipsToBounds = true
        self.adjustsFontSizeToFitWidth = true
    }
    
}
