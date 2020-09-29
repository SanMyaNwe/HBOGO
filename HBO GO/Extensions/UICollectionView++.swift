//
//  UICollectionView++.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerWithItem(id: String) {
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: id)
    }
    
    func showCollectionViewStatus(_ status: String) {
        let lbStatus = UILabel()
        lbStatus.textColor = .primaryColor
        lbStatus.font = UIFont(name: "Kefa", size: 18)
        lbStatus.text = status
        lbStatus.translatesAutoresizingMaskIntoConstraints = false
        
        let bgView = UIView()
        bgView.backgroundColor = .clear
        bgView.frame = self.bounds
        
        bgView.addSubview(lbStatus)
        
        NSLayoutConstraint.activate([
            lbStatus.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            lbStatus.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        ])
        
        self.backgroundView = bgView
    }
    
    func restoreCollectionView() {
        self.backgroundView = UIView()
    }
    
}
