//
//  UIView+.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2023/02/03.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIView {
    var rootSafeAreaLayoutGuide: UILayoutGuide? {
        var rootView: UIView? = self
        while rootView?.superview != nil {
            rootView = rootView?.superview
        }
        return rootView?.safeAreaLayoutGuide
    }
}
