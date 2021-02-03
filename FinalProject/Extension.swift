//
//  Extension.swift
//  FinalProject
//
//  Created by Iuri Jikidze on 2/3/21.
//

import UIKit

extension UITabBar {
    
    static func setTransparentTabbar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage     = UIImage()
        UITabBar.appearance().clipsToBounds   = true
    }
}
