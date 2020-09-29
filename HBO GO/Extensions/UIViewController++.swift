//
//  UIViewController++.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    
    func startLoading() {
        startAnimating(CGSize(width: 50, height: 50), message: nil, messageFont: nil, type: .lineScale, color: .primaryColor, padding: 8, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: .primaryColor, fadeInAnimation: nil)
    }
    
    func stopLoading() {
        stopAnimating()
    }

}
