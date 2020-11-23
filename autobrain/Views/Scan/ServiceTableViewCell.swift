//
//  ServiceTableViewCell.swift
//  autobrain
//
//  Created by hope on 11/13/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit
import RxBluetoothKit

class ServiceTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblServiceUuid: UILabel!
    public var service: Service! {
        didSet {
            lblServiceUuid.text = service.uuid.uuidString
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCell() {
        self.selectionStyle = .none
    }
    
    func setSelectTarget(_ target: Any, action: Selector) {
        let tapGesture = TapGesture(target: target, action: action)
        tapGesture.service = service
        contentView.addGestureRecognizer(tapGesture)
    }
    
    class TapGesture: UITapGestureRecognizer {
        
        var service: Service!
    }
}
