//
//  BaseView.swift
//  Autobrain
//
//  Created by Kyle Smith on 9/20/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    let width: CGFloat = UIScreen.main.nativeBounds.height <= 1136 ? 256 : 270
    let edgeConstant:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width * 0.405 : UIScreen.main.bounds.width * 0.15
    let ipadWidth:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 375 : 0
    let adderConstant = UIScreen.main.bounds.width * 0.01
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
