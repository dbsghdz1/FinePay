//
//  SendSOLView.swift
//  FinePay
//
//  Created by Yunhong on 4/2/25.
//

import SwiftUI

struct SendSOLView {
  @State private var solPrice = 0
}

extension SendSOLView: View {
  var body: some View {
    VStack {
      HStack {
        Text("0")
          .font(.system(size: 64))
          .padding(.trailing, 36)
//          .foregroundStyle()
        Text("SOL")
          .font(.system(size: 64))
      }
    }
  }
}

#Preview {
  SendSOLView()
}
