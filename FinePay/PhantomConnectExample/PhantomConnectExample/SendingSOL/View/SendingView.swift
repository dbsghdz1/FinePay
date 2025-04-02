//
//  SendingView.swift
//  FinePay
//
//  Created by Yunhong on 4/3/25.
//

import SwiftUI

struct SendingView {
  @State private var confirmButtonClicked = false
}

extension SendingView: View {
  var body: some View {
    VStack {
      Spacer()
      Text("Sending")
        .font(.system(size: 40, weight: .semibold))
        .foregroundStyle(Color.textBlackColor)
      Text("0.1 SOL")
        .font(.system(size: 40, weight: .semibold))
        .foregroundStyle(Color.textBlackColor)
      HStack {
        Text("to")
          .font(.system(size: 40, weight: .semibold))
          .foregroundStyle(Color.textBlackColor)
        Text("Hong")
          .font(.system(size: 40, weight: .semibold))
          .foregroundStyle(Color.mainColor)
      }
      Spacer()
      Button {
        confirmButtonClicked = true
        print("buttonClicked")
      } label: {
        Text("Confirm")
          .font(.system(size: 26, weight: .semibold))
          .foregroundStyle(.white)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .frame(width: 361, height: 55)
              .foregroundStyle(Color.mainColor)
          )
      }
      .padding(.horizontal)
      .padding(.bottom, 38)
      .navigationDestination(isPresented: $confirmButtonClicked) {
        SendingView()
      }
    }
  }
}

#Preview(body: {
  SendingView()
})
