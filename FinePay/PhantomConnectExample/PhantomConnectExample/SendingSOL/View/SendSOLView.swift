//
//  SendSOLView.swift
//  FinePay
//
//  Created by Yunhong on 4/2/25.
//

import SwiftUI

struct SendSOLView {
  @State private var solPrice: Double = 0
  @State private var inputText: String = "0"
}

extension SendSOLView: View {
  var body: some View {
    VStack {
      Spacer()
      HStack {
        TextField("0", text: $inputText)
          .multilineTextAlignment(.trailing)
          .font(.system(size: 64))
          .padding(.trailing, 36)
          .foregroundStyle(inputText == "0" ? Color.textGrayColor : Color.black)
          .keyboardType(.decimalPad)
          .onChange(of: solPrice) { newValue in
            inputText = String(newValue)
          }
        Text("SOL")
          .font(.system(size: 64))
      }
//      .frame(maxWidth: .infinity, alignment: .center)
      .onAppear {
        inputText = "0"
      }
      HStack(spacing: 24) {
        Button {
          solPrice += 1
        } label: {
          Text("1 SOL")
            .padding()
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Color.black)
            .background(
              RoundedRectangle(cornerRadius: 10)
                .frame(width: 76, height: 42)
                .foregroundStyle(Color.solPriceContainer.opacity(0.12))
            )
        }
        Button {
          solPrice += 0.5
        } label: {
          Text("0.5 SOL")
            .padding()
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Color.black)
            .background(
              RoundedRectangle(cornerRadius: 10)
                .frame(width: 76, height: 42)
                .foregroundStyle(Color.solPriceContainer.opacity(0.12))
            )
        }
        Button {
          solPrice += 0.1
        } label: {
          Text("0.1 SOL")
            .padding()
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Color.black)
            .background(
              RoundedRectangle(cornerRadius: 10)
                .frame(width: 76, height: 42)
                .foregroundStyle(Color.solPriceContainer.opacity(0.12))
            )
        }
      }
      Spacer()
      Button {
        print("send")
      } label: {
        Text("Send")
          .font(.system(size: 26, weight: .semibold))
          .foregroundStyle(.white)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .frame(width: 361, height: 55)
              .foregroundStyle(solPrice == 0 ? Color.inActiveSendButton : Color.mainColor)
          )
      }
      .padding(.horizontal)
      .padding(.bottom, 38)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  SendSOLView()
}
