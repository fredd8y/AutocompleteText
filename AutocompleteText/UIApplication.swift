//
//  Utils.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 12/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

extension UIApplication {
    static var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = shared.windows.filter { $0.isKeyWindow }.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = shared.statusBarFrame.height
        }
        return statusBarHeight
    }
}
