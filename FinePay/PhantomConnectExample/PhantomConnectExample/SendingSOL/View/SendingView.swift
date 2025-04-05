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
  @State private var navigateToNextView = false
  @Environment(\.dismiss) private var dismiss
  @State var confirmButtonClicked = false
  let solCoin: Double
  @StateObject var viewModel: PhantomConnectViewModel
  let phantomEncryptionKey = UserDefaults.standard.string(forKey: "phantomEncryptionKey")
  let walletPublicKey = UserDefaults.standard.string(forKey: "walletPublicKey")
  let giverAddress: String
  let myAddress: String
  var session = UserDefaults.standard.string(forKey: "session")
    let nickName: String
  
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
        Text("\(nickName)")
          .font(.system(size: 40, weight: .bold))
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
          navigateToNextView = true
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
    .navigationBarBackButtonHidden(true)
    .background(
      NavigationLink(
        destination: SendingResultView(solCoin: formattedSOLCoin),
        isActive: $navigateToNextView,
        label: { EmptyView() }
      )
    )
  }
  
  func createTransaction(completion: @escaping ((_ serializedTransaction: String) -> Void)) {
    Task {
      do {
        let recentBlockhash = try await NetworkManager.shared.getBlockHash()
        
        _ = Solana(router: NetworkingRouter(endpoint: RPCEndpoint.devnetSolana))
        
        var transaction = Transaction(
          feePayer: PublicKey(string: myAddress)!,
          instructions: [
            SystemProgram.transferInstruction(
              from: PublicKey(string: myAddress)!,
              to: PublicKey(string: giverAddress)!,
              lamports: UInt64(1000000000.0 * solCoin)
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
    SendingView(solCoin: 0.0, viewModel: PhantomConnectViewModel(), giverAddress: "", myAddress: "", nickName: "")
})
