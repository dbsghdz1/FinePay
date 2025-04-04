//
//  Double.swift
//  FinePay
//
//  Created by Yunhong on 4/3/25.
//

import Foundation

extension Double {
  func rounded(toPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
  
  func getStringValue(withFloatingPoints points: Int = 0) -> String {
    let valDouble = modf(self)
    let fractionalVal = (valDouble.1)
    if fractionalVal > 0 {
      return String(format: "%.*f", points, self)
    }
    return String(format: "%.0f", self)
  }
}

extension String {
  func removeZeros() -> String {
    self.replacingOccurrences(of: #"(\.\d*?[1-9])0+$"#, with: "$1", options: .regularExpression)
      .replacingOccurrences(of: #"\.0+$"#, with: "", options: .regularExpression)
  }
}
