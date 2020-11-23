//
//  ServiceListView.swift
//  autobrain
//
//  Created by hope on 11/14/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

class ServiceListView: UIView {

    @IBOutlet weak var serviceTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nibName = String(describing: ServiceListView.self)
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
        serviceTableView.backgroundColor = Constant.UIColors.background
        serviceTableView.estimatedRowHeight = 60
        serviceTableView.tableFooterView = UIView()
        serviceTableView.separatorInset = UIEdgeInsets.zero
        serviceTableView.layoutMargins = .zero
        serviceTableView.separatorColor = Constant.UIColors.blue
        serviceTableView.register(UINib(nibName: String(describing: ServiceTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ServiceTableViewCell.self))
        serviceTableView.delegate = self
    }
    
}

extension ServiceListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
