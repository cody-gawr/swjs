//
//  SpashScreenView.swift
//  Autobrain
//
//  Created by Kyle Smith on 11/1/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

class SplashScreenView: BaseView {
    
    let splashImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "myautobrain-logo")
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        addSubview(splashImage)
        
        splashImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        splashImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
    }
}
