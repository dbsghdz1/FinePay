//
//  SendSOLView.swift
//  FinePay
//
//  Created by Yunhong on 4/2/25.
//
//TODO: 키보드내리기, 0.0SOL화면 중앙 배치
import SwiftUI

import PhantomConnect

struct SendSOLView {
  @State private var solPrice: Double = 0
  @State private var inputText: String = "0"
  @State private var sendButtonClicked = false
  let viewModel: PhantomConnectViewModel?
  @Environment(\.dismiss) private var dismiss
}

extension SendSOLView: View {
  var body: some View {
    NavigationStack {
      ZStack(alignment: .top) {
        Color.sendingSolNavHeader
          .frame(height: 52)
          .clipShape(TopRoundedRectangle(cornerRadius: 30))
        VStack(spacing: 0) {
          HStack {
            Button {
              dismiss()
            } label: {
              Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.textBlackColor)
            }
            Spacer()
            Text("Sending SOL")
              .font(.system(size: 17))
              .fontWeight(.semibold)
              .foregroundStyle(Color.textBlackColor)
            Spacer()
          }
          .padding(.horizontal)
          .padding(.top)
          .padding(.bottom, 12)
        }
      }
      VStack {
        Spacer()
        GeometryReader { geometry in
          HStack {
            Spacer()
            TextField("0", text: $inputText)
              .accentColor(.mainColor)
              .multilineTextAlignment(.trailing)
              .font(.system(size: 56))
              .padding(.trailing, 8)
              .lineLimit(1)
              .foregroundStyle(inputText == "0" ? Color.textGrayColor : Color.textBlackColor)
              .keyboardType(.decimalPad)
              .frame(minWidth: 95, maxWidth: geometry.size.width * 0.6, alignment: .trailing)
              .layoutPriority(1)
              .fixedSize(horizontal: true, vertical: true)
              .onChange(of: solPrice) { newValue in
                inputText = String(format: "%.6f", newValue).removeZeros()
              }
              .onChange(of: inputText) { newValue in
                if let value = Double(newValue), value >= 0 {
                  solPrice = value
                } else {
                  inputText = "0"
                  solPrice = 0
                }
              }
            
            Text("SOL")
              .font(.system(size: 56))
              .layoutPriority(1)
              .foregroundStyle(Color.textBlackColor)
            Spacer()
          }
          .frame(maxWidth: .infinity)
          .onAppear {
            inputText = "0"
            solPrice = 0
          }
        }
        .frame(height: 80)
        HStack(spacing: 24) {
          ForEach([1, 0.5, 0.1], id: \.self) { amount in
            Button {
              addSOL(amount)
            } label: {
              Text("\(String(format: "%.6f", amount).removeZeros()) SOL")
                .padding()
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.textBlackColor)
                .background(
                  RoundedRectangle(cornerRadius: 10)
                    .frame(width: 76, height: 42)
                    .foregroundStyle(Color.solPriceContainer.opacity(0.12))
                )
            }
          }
        }
        Spacer()
        Button {
          sendButtonClicked = true
          print("buttonClicked")
        } label: {
          Text("Send")
            .font(.system(size: 26, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 361, height: 55)
            .background(
              RoundedRectangle(cornerRadius: 10)
                .frame(width: 361, height: 55)
                .foregroundStyle(solPrice == 0 ? Color.inActiveSendButton : Color.mainColor)
            )
        }
        .disabled(inputText == "0")
        .padding(.horizontal)
        .padding(.bottom, 38)
        .navigationDestination(isPresented: $sendButtonClicked) {
          SendingView(solCoin: solPrice, viewModel: viewModel!)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.white)
      .onTapGesture {
        self.endTextEditing()
      }
      .navigationBarBackButtonHidden(true)
    }
  }
  
  private func addSOL(_ amount: Double) {
    let newValue = Double(solPrice + amount)
    solPrice = newValue
    inputText = String(format: "%.2f", newValue)
  }
}

#Preview {
  SendSOLView(viewModel: PhantomConnectViewModel())
}
