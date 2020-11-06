//
//  UIColor+HexValues.swift
//  YPImagePicker
//
//  Created by Marko Mladenovic on 06/11/2020.
//

import Foundation

extension UIColor {
    convenience public init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let redComponent = Int(color >> 16) & mask
        let greenComponent = Int(color >> 8) & mask
        let blueComponent = Int(color) & mask

        let red   = CGFloat(redComponent) / 255.0
        let green = CGFloat(greenComponent) / 255.0
        let blue  = CGFloat(blueComponent) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
