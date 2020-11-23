//
//  CharacteristicTableViewCell.swift
//  autobrain
//
//  Created by hope on 11/14/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit
import RxBluetoothKit

class CharacteristicTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUuid: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    public var characteristic: Characteristic! {
        didSet {
            lblUuid.text = characteristic.uuid.uuidString
            if let value  = characteristic.value {
                lblValue.text = String(decoding: value, as: UTF8.self)
            } else {
                lblValue.text = ""
            }
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
    
    override func prepareForReuse() {
        lblUuid.text = ""
        lblValue.text = ""
    }
    
    private func setupCell() {
        self.selectionStyle = .none
    }
}
