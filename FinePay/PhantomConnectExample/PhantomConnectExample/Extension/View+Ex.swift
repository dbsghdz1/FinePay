//
//  View+Ex.swift
//  FinePay
//
//  Created by Yunhong on 4/3/25.
//

import SwiftUI

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
