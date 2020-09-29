//
//  UITableView++.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerWithRow(id: String) {
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forCellReuseIdentifier: id)
    }
    
    func showTableViewStatus(message: String) {
        let lbStatus = UILabel()
        lbStatus.textColor = .primaryColor
        lbStatus.font = UIFont(name: "Kefa", size: 14)
        lbStatus.text = message
        
        self.backgroundView = lbStatus
    }
    
    func restoreTableView() {
        self.backgroundView = UIView()
    }
    
}
