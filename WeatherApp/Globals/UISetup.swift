//
//  UISetup.swift
//  WeatherApp
//
//  Created by Lucija Balja on 06/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit


class UISetup {
    
    static func setLabel(_ label: UILabel, size: CGFloat = 20.0, textAlignment: NSTextAlignment = .center) {
        label.font = .boldSystemFont(ofSize: size)
        label.textColor = .white
        label.textAlignment = textAlignment
        label.clipsToBounds = true
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    static func setImageView(_ imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.tintColor = .white
    }
}
