//
//  SendingResultView.swift
//  FinePay
//
//  Created by Yunhong on 4/3/25.
//

import SwiftUI

struct SendingResultView {
  @State var okayButtonClicked = false
  @Environment(\.dismiss) private var dismiss
  let solCoin: String
  let nickName: String
}

extension SendingResultView: View {
  var body: some View {
      if !okayButtonClicked {
          VStack {
              Spacer()
              Image(systemName: "checkmark.circle.fill")
                  .resizable()
                  .frame(width: 96, height: 96)
                  .foregroundStyle(Color.mainColor)
              Text("Sent \(solCoin)")
                  .font(.system(size: 40, weight: .semibold))
              HStack {
                  Text("to")
                      .font(.system(size: 40, weight: .semibold))
                      .foregroundStyle(Color.textBlackColor)
                  Text(nickName)
                      .font(.system(size: 40, weight: .bold))
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
                      .frame(maxWidth: .infinity)
              }
              .padding(.horizontal)
              .padding(.bottom, 38)
          }
          .navigationBarBackButtonHidden(true)
      } else {
          HomeView()
      }
  }
}

#Preview(body: {
  SendingResultView(solCoin: "@3", nickName: "")
})
