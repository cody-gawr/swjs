//
//  PeripheralTableViewCell.swift
//  autobrain
//
//  Created by hope on 11/13/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxBluetoothKit

class PeripheralTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblDeviceMacAddress: UILabel!
    
    private let tapGesture = UITapGestureRecognizer()
    
    public var scanned: ScannedPeripheral! {
        didSet {
            self.lblDeviceName.text = scanned.peripheral.name ?? Constant.Strings.unknown
            self.lblDeviceMacAddress.text = scanned.peripheral.identifier.uuidString
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
        lblDeviceName.text = Constant.Strings.unknown
        lblDeviceMacAddress.text = ""
    }
    
    private func setupCell() {
        self.selectionStyle = .none
    }
    
    func setSelectTarget(_ target: Any, action: Selector) {
        let tapGesture = TapGesture(target: target, action: action)
        tapGesture.scanned = scanned
        contentView.addGestureRecognizer(tapGesture)
    }
    
    class TapGesture: UITapGestureRecognizer {
        
        var scanned: ScannedPeripheral?
    }
    
}
