//
//  UIButton+Extensions.swift
//  WeatherApp
//
//  Created by Lucija Balja on 25/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

extension UIButton {
    
    func applyDefaultStyle(fontSize: CGFloat = 25.0, isBold: Bool = true, title: String) {
        self.titleLabel?.font = isBold ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
        self.setTitle(title, for: .normal)
        self.backgroundColor = .white
        self.alpha = 0.9
        self.tintColor = .systemBlue
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
