//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    
    let tableView = UITableView()
    private let errorLabel = UILabel()
    private let errorImage = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setErrorLabel() {
        tableView.isHidden = true
        errorLabel.isHidden = false
        errorImage.isHidden = false
        errorLabel.text = "Error getting data! Please try again."
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        
        errorImage.styleView()
        errorImage.image = UIImage(named: "error-icon")
        errorImage.isHidden = true
        errorImage.layer.cornerRadius = 0
        
        errorLabel.style(size: 25)
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        
        tableView.backgroundColor = .systemBlue
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableView)
        addSubview(errorImage)
        addSubview(errorLabel)
    }
       
    private func setupConstraints() {
        let errorImageDimension: CGFloat = 60
        let errorsTopAnchor: CGFloat = 50
        let labelsMargin: CGFloat = 20
        
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        errorImage.topAnchor.constraint(equalTo: self.topAnchor, constant: errorsTopAnchor).isActive = true
        errorImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        errorImage.heightAnchor.constraint(equalToConstant: errorImageDimension).isActive = true
        errorImage.widthAnchor.constraint(equalToConstant: errorImageDimension).isActive = true
        
        errorLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: labelsMargin).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: labelsMargin).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -labelsMargin).isActive = true
    }
    
}
