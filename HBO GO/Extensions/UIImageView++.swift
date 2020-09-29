//
//  UIImageView++.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setWebImage(path: String) {
        let completeUrl = Api.IMAGE_URL + path
        guard let url = URL(string: completeUrl) else { return }
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .delayPlaceholder, progress: nil, completed: nil)
    }
}


