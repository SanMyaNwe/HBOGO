//
//  UIStoryboard++.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static var Main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func instiante<T>(with id: String, value: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: id) as! T
    }
    
}
