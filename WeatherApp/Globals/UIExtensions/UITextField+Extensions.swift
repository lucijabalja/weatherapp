//
//  UITextField+Extensions.swift
//  WeatherApp
//
//  Created by Lucija Balja on 06/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setSearchTextField(size: CGFloat = 20.0, isBold: Bool = true, placeholder: String = "") {
        self.font = isBold ? .boldSystemFont(ofSize: size) : .systemFont(ofSize: size)
        self.textColor = .white
        self.textAlignment = .center
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .lightText
        self.layer.cornerRadius = 10
        self.placeholder = placeholder
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
