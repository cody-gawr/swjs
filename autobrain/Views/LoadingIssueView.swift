//
//  LoadingIssueView.swift
//  Autobrain
//
//  Created by Kyle Smith on 8/30/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

//This class needs to be seperated into controller and view...

import UIKit

class LoadingIssueView: UIViewController {
    
    let alertImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "alert")
        return iv
    }()
    
    let container: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        label.text = "Could Not Load Data"
        label.textAlignment = .center
        return label
    }()
    
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.text = "You are not connected to the internet."
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let tryAgainButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Retry", for: .normal)
        button.addTarget(nil, action: #selector(retry), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.addSubview(container)
        view.addSubview(alertImageView)
        container.addSubview(titleLabel)
        container.addSubview(infoLabel)
        container.addSubview(tryAgainButton)
        
        _ = container.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 250, heightConstant: 125)
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        _ = titleLabel.anchor(container.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 250, heightConstant: 24)
        titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        _ = infoLabel.anchor(titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 225, heightConstant: 36)
        infoLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        _ = tryAgainButton.anchor(infoLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 96, heightConstant: 28)
        tryAgainButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        _ = alertImageView.anchor(nil, left: nil, bottom: container.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        alertImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
    }
    
    @objc func retry() {
        dismiss(animated: true, completion: nil)
        Session.current().viewController?.checkReachabilityAndLoad()
    }
    
}
