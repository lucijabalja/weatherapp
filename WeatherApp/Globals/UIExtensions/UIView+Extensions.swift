//
//  UIView+Extensions.swift
//  WeatherApp
//
//  Created by Lucija Balja on 05/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

extension UIView {
    
    func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.gradientDarkColor.cgColor, UIColor.gradientLightColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
}
