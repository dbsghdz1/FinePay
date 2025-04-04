//
//  SendingResultView.swift
//  FinePay
//
//  Created by Yunhong on 4/3/25.
//

import SwiftUI

struct SendingResultView {
  @State private var okayButtonClicked = false
}

extension SendingResultView: View {
  var body: some View {
    VStack {
      Spacer()
      Image(systemName: "checkmark.circle.fill")
        .resizable()
        .frame(width: 96, height: 96)
        .foregroundStyle(Color.mainColor)
      Text("Sent 0.1")
        .font(.system(size: 40, weight: .semibold))
      HStack {
        Text("to")
          .font(.system(size: 40, weight: .semibold))
          .foregroundStyle(Color.textBlackColor)
        Text("Hong")
          .font(.system(size: 40, weight: .semibold))
          .foregroundStyle(Color.mainColor)
      }
      //TODO: 메모?
      Spacer()
      Button {
        okayButtonClicked = true
        print("buttonClicked")
      } label: {
        Text("Okay")
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
//      .navigationDestination(isPresented: $confirmButtonClicked) {
//        SendingView()
//      }
    }
  }
}

#Preview(body: {
  SendingResultView()
})
