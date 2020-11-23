//
//  PeripheralLIstView.swift
//  autobrain
//
//  Created by hope on 11/13/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

class PeripheralListView: UIView {

    @IBOutlet weak var scanBtn: UIButton!
//    var peripheralTableView = UITableView()

    @IBOutlet weak var peripheralTableView: UITableView!
    
    @IBOutlet weak var responseTextView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
                return
        }
        nibView.frame = self.bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(nibView)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        scanBtn.layer.cornerRadius = 5.0
        peripheralTableView.backgroundColor = Constant.UIColors.background
        peripheralTableView.estimatedRowHeight = 60
        peripheralTableView.tableFooterView = UIView()
        peripheralTableView.separatorInset = UIEdgeInsets.zero
        peripheralTableView.layoutMargins = .zero
        peripheralTableView.separatorColor = Constant.UIColors.blue
        peripheralTableView.register(UINib(nibName: String(describing: PeripheralTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PeripheralTableViewCell.self))
        peripheralTableView.delegate = self
    }
}

extension PeripheralListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
