//
//  UIButton+Extensions.swift
//  WeatherApp
//
//  Created by Lucija Balja on 25/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

extension UIButton {
    
    func applyDefaultStyle(fontSize: CGFloat = 25.0, title: String) {
        self.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        self.setTitle(title, for: .normal)
        self.backgroundColor = .white
        self.alpha = 0.9
        self.tintColor = .systemBlue
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
