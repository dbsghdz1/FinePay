//
//  SendingView.swift
//  FinePay
//
//  Created by Yunhong on 4/3/25.
//

import SwiftUI

import Solana
import PhantomConnect

struct SendingView {
  @State var confirmButtonClicked = false
  let solCoin: Double
  @StateObject var viewModel: PhantomConnectViewModel
  let phantomEncryptionKey = UserDefaults.standard.string(forKey: "phantomEncryptionKey")
  let walletPublicKey = UserDefaults.standard.string(forKey: "walletPublicKey")
  let paduckWallet = "B9hNZruBjAQSdrYYvktnPgGTPsVbY82MyxCZcHraVsZZ"
  var session = UserDefaults.standard.string(forKey: "session")
  
  var formattedSOLCoin: String {
    if solCoin.truncatingRemainder(dividingBy: 1) == 0 {
      return String(format: "%.6f", solCoin).removeZeros()
    } else {
      return String(format: "%.6f", solCoin).removeZeros()
    }
  }
}

extension SendingView: View {
  var body: some View {
    VStack {
      Spacer()
      Text("Sending")
        .font(.system(size: 40, weight: .semibold))
        .foregroundStyle(Color.textBlackColor)
      Text("\(formattedSOLCoin) SOL")
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
        createTransaction { serializedTransaction in
          do {
            try viewModel.sendAndSignTransaction(
              serializedTransaction: serializedTransaction,
              dappEncryptionKey: viewModel.linkingKeypair?.publicKey,
              phantomEncryptionKey: PublicKey(string: phantomEncryptionKey ?? ""),
              session: session ?? "",
              dappSecretKey: viewModel.linkingKeypair?.secretKey
            )
          } catch {
            print("sendAndSignTransaction Error: \(error.localizedDescription)")
          }
        }
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
      .frame(width: 361, height: 55)
      .padding(.horizontal)
      .padding(.bottom, 38)
      .onWalletTransaction(
        phantomEncryptionPublicKey: PublicKey(string: phantomEncryptionKey ?? ""),
        dappEncryptionSecretKey: viewModel.linkingKeypair?.secretKey
      ) { signature, error in
        if let error = error {
          print("failTransaction : \(error.localizedDescription)")
        } else if let signature = signature {
          print("successTransaction: \(signature)")
        }
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
  
  func createTransaction(completion: @escaping ((_ serializedTransaction: String) -> Void)) {
    Task {
      do {
        let recentBlockhash = try await NetworkManager.shared.getBlockHash()
        
        _ = Solana(router: NetworkingRouter(endpoint: RPCEndpoint.devnetSolana))
        
        var transaction = Transaction(
          feePayer: PublicKey(string: "8zvV1Gig5i1pHbyXbqEQBHTe2Ft8qvzR9CPziZQ5p3ET")!,
          instructions: [
            SystemProgram.transferInstruction(
              from: PublicKey(string: "8zvV1Gig5i1pHbyXbqEQBHTe2Ft8qvzR9CPziZQ5p3ET")!,
              to: PublicKey(string: paduckWallet)!,
              lamports: 1000000000
            )
          ],
          recentBlockhash: recentBlockhash
        )
        
        let serializedTransaction = try transaction.serialize().get()
        DispatchQueue.main.async {
          completion(Base58.encode(serializedTransaction.bytes))
        }
      } catch {
        print("blockHashError: \(error)")
      }
    }
  }
}

#Preview(body: {
  SendingView(solCoin: 0.0, viewModel: PhantomConnectViewModel())
})
