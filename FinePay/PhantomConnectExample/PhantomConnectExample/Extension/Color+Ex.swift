//
//  Color+Ex.swift
//  FinePay
//
//  Created by Yunhong on 4/2/25.
//

import SwiftUI

extension Color {
  static let inActiveSendButton = Color(hex: "#D0C3DF")
  static let mainColor = Color(hex: "#973AFF")
  static let textGrayColor = Color(hex: "#8B8B8B")
  static let solPriceContainer = Color(hex: "#767680")
  static let sendingSolNavHeader = Color(hex: "#F4F4F4")
  static let textBlackColor = Color(hex: "#2C2C2C")
  static let notConnectedColor = Color(hex: "#6C6C6C")
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
