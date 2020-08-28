//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Lucija Balja on 25/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    
    private let errorLabel = UILabel()
    private let errorImage = UIImageView()
    let refreshButton = UIButton(type: .system)
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setErrorLabel(with error: Error) {
        switch error {
        case PersistanceError.loadingError:
            errorLabel.text = ErrorMessage.loadingError
        case PersistanceError.savingError:
            errorLabel.text = ErrorMessage.savingError
        case NetworkError.URLSessionError:
            errorLabel.text = ErrorMessage.urlSessionError
        default:
            errorLabel.text = "Something went wrong!"
        }
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        
        errorImage.applyDefaultStyleView()
        errorImage.image = UIImage(named: "error-icon")
        errorImage.layer.cornerRadius = 0
        
        errorLabel.style(fontSize: 25)
        errorLabel.numberOfLines = 0
        
        refreshButton.applyDefaultStyle(title: "Try again")
        
        addSubview(errorImage)
        addSubview(errorLabel)
        addSubview(refreshButton)
    }
    
    private func setupConstraints() {
        let errorImageDimension: CGFloat = 60
        let errorsTopAnchor: CGFloat = 50
        let labelsMargin: CGFloat = 20
        
        errorImage.topAnchor.constraint(equalTo: self.topAnchor, constant: errorsTopAnchor).isActive = true
        errorImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        errorImage.heightAnchor.constraint(equalToConstant: errorImageDimension).isActive = true
        errorImage.widthAnchor.constraint(equalToConstant: errorImageDimension).isActive = true
        
        errorLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: labelsMargin).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: labelsMargin).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -labelsMargin).isActive = true
        
        refreshButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: errorsTopAnchor).isActive = true
        refreshButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        refreshButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
    }
    
}
