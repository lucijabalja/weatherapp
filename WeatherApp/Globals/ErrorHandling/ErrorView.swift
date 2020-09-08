//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Lucija Balja on 25/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import PureLayout

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
        backgroundColor = .clear
        
        errorImage.applyDefaultStyleView()
        errorImage.image = UIImage(named: "error-icon")
        errorImage.layer.cornerRadius = 0
        
        errorLabel.style(fontSize: 25)
        errorLabel.numberOfLines = 0
        
        refreshButton.applyDefaultStyle(title: "Try again")
        
    }
    
    private func setupConstraints() {
        let errorImageDimension: CGFloat = 60
        let errorsTopMargin: CGFloat = 50
        let labelsMargin: CGFloat = 20
        
        addSubview(errorImage)
        errorImage.autoPinEdge(.top, to: .top, of: self, withOffset: errorsTopMargin)
        errorImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        errorImage.autoSetDimensions(to: CGSize(width: errorImageDimension, height: errorImageDimension))
        
        addSubview(errorLabel)
        errorLabel.autoPinEdge(.top, to: .bottom, of: self.errorImage, withOffset: labelsMargin)
        errorLabel.autoPinEdge(.left, to: .left, of: self, withOffset: labelsMargin)
        errorLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -labelsMargin)
        
        addSubview(refreshButton)
        refreshButton.autoPinEdge(.top, to: .bottom, of: self.errorLabel, withOffset: errorsTopMargin)
        refreshButton.autoPinEdge(.left, to: .left, of: self, withOffset: 30)
        refreshButton.autoPinEdge(.right, to: .right, of: self, withOffset: -30)
    }
    
}
