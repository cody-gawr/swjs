//
//  CharacteristicListView.swift
//  autobrain
//
//  Created by hope on 11/14/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

class CharacteristicListView: UIView {
    
    @IBOutlet weak var characteristicTableView: UITableView!
    
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
        characteristicTableView.backgroundColor = Constant.UIColors.background
        characteristicTableView.tableFooterView = UIView()
        characteristicTableView.separatorInset = UIEdgeInsets.zero
        characteristicTableView.layoutMargins = .zero
        characteristicTableView.separatorColor = Constant.UIColors.blue
        characteristicTableView.register(UINib(nibName: String(describing: CharacteristicTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CharacteristicTableViewCell.self))
        characteristicTableView.delegate = self
    }
}

extension CharacteristicListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
