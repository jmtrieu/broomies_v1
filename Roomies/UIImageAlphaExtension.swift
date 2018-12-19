//
//  UIImageAlphaExtension.swift
//  Broomies
//
//  Created by Andrew Yan on 11/20/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
