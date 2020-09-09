//
//  SpinnerViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 09/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    
    private var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.2)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
