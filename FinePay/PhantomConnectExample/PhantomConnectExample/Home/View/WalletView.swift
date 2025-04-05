//
//  WalletView.swift
//  FinePay
//
//  Created by 김민석 on 4/3/25.
//

import SwiftUI

import Solana
import PhantomConnect

struct BottomWalletView {
  @StateObject var viewModel = PhantomConnectViewModel()
  @State var walletConnected = false
  @State var walletPublicKey: PublicKey?
  @State var phantomEncryptionKey: PublicKey?
  @State var session: String?
  @State var solCoin = ""
}

extension BottomWalletView: View {
  var body: some View {
    VStack() {
      Capsule()
        .frame(width: 40, height: 5)
        .foregroundColor(.gray.opacity(0.3))
        .padding(.top, 8)
      
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text("My Wallet")
            .fontWeight(.semibold)
            .foregroundColor(.textBlackColor)
            .font(.system(size: 26))
          Text(walletConnected ? "Connected" : "Not Connected")
            .fontWeight(.semibold)
            .foregroundColor(.notConnectedColor)
            .font(.system(size: 18))
        }
        Spacer()
        Button {
          if !walletConnected {
            try? viewModel.connectWallet()
          }
        } label: {
          Image(walletConnected ? "ConnectedWalletIcon" : "NotConnectedWalletIcon")
            .foregroundColor(.textGrayColor)
        }
        .disabled(walletConnected)
        .onWalletConnect(viewModel: viewModel) { publicKey, phantomEncryptionPublicKey, session, error in
          self.walletPublicKey = publicKey
          self.phantomEncryptionKey = phantomEncryptionPublicKey
          self.session = session
          walletConnected.toggle()
          if let publicKeyString = walletPublicKey?.base58EncodedString {
            UserDefaults.standard.set(publicKeyString, forKey: "walletPublicKey")
          }
          
          if let phantomKeyString = phantomEncryptionKey?.base58EncodedString {
            UserDefaults.standard.set(phantomKeyString, forKey: "phantomEncryptionKey")
          }
          
          if let session = session {
            UserDefaults.standard.set(session, forKey: "session")
          }
        }
        .onAppear {
          PhantomConnect.configure(
            appUrl: "https://example.com",
            cluster: "devnet",
            redirectUrl: "example://"
          )
        }
      }
      .padding(.horizontal)
      if walletConnected {
        HStack {
          Image("SolanaIcon")
            .resizable()
            .frame(width: 45, height: 45)
          VStack(alignment: .leading) {
            Text("Solana")
              .font(.system(size: 18, weight: .semibold))
              .foregroundColor(.textGrayColor)
            Text("\(solCoin) SOL")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(.textBlackColor)
//              .padding(.horizontal)
          }
          .onAppear(perform: {
            Task {
              do {
                solCoin = try await NetworkManager.shared.fetchSOLBalance(
                  address: walletPublicKey?.base58EncodedString ?? ""
                )
              } catch {
                
              }
            }
          })
          .padding(.leading, 0)
          Spacer()
        }
        .padding(.vertical, 11)
        .padding(.leading, 8)
        .frame(width: 347, height: 67)
        .background(
            RoundedRectangle(cornerRadius: 14)
              .fill(Color.white)
        )
        .padding(.top, 34)
      }
      Spacer(minLength: 10)
    }
    .frame(height: walletConnected ? 199 : 100)
    .background(Color(hex: "F4F4F4"))
    .overlay(
      RoundedRectangle(cornerRadius: 24)
        .stroke(Color(hex: "DBDBDB"), lineWidth: 0.5)
    )
    .padding(.bottom, 10)
    .padding(.horizontal)
    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
  }
}

#Preview {
  BottomWalletView()
}
