//
//  ContentView.swift
//  PhantomConnectExample
//
//  Created by Eric McGary on 7/8/22.
//

import SwiftUI

import Solana
import PhantomConnect

struct ContentView: View {
  @StateObject var viewModel = PhantomConnectViewModel()
  @State var walletConnected = false
  @State var walletPublicKey: PublicKey?
  let paduckWallet = "B9hNZruBjAQSdrYYvktnPgGTPsVbY82MyxCZcHraVsZZ"
  @State var phantomEncryptionKey: PublicKey?
  @State var session: String?
  @State var transactionSignature: String?
  @State var isButtonClicked = false
  
  var body: some View {
    NavigationStack {
      content
        .buttonStyle(.borderedProminent)
        .padding()
        .onAppear {
          PhantomConnect.configure(
            appUrl: "https://example.com",
            cluster: "devnet",
            redirectUrl: "example://"
          )
        }
    }
  }
  
  //MARK: 지갑연결
  @ViewBuilder
  var content: some View {
    if walletConnected {
      connectedContent
    } else {
      disconnectedContent
    }
  }
  
  //MARK: 연결해제
  var disconnectedContent: some View {
    Button {
      try? viewModel.connectWallet()
    } label: {
      Text("Connect with Phantom")
    }
    .onWalletConnect(viewModel: viewModel) { publicKey, phantomEncryptionPublicKey, session, error in
      self.walletPublicKey = publicKey
      self.phantomEncryptionKey = phantomEncryptionPublicKey
      self.session = session
      walletConnected.toggle()
    }
  }
  
  var connectedContent: some View {
    VStack(spacing: 24) {
      VStack {
        Text("Wallet Public Key:")
        Text(walletPublicKey?.base58EncodedString ?? "--")
      }
      VStack {
        Text("Transaction Signature:")
        Text(transactionSignature ?? "--")
      }
      Button {
        createTransaction { serializedTransaction in
          try? viewModel.sendAndSignTransaction(
            serializedTransaction: serializedTransaction,
            dappEncryptionKey: viewModel.linkingKeypair?.publicKey,
            phantomEncryptionKey: phantomEncryptionKey,
            session: session,
            dappSecretKey: viewModel.linkingKeypair?.secretKey
          )
        }
      } label: {
        Text("Send Transaction")
      }
      .onWalletTransaction(
        phantomEncryptionPublicKey: phantomEncryptionKey,
        dappEncryptionSecretKey: viewModel.linkingKeypair?.secretKey
      ) { signature, error in
        if let error = error {
          print("failTransaction : \(error.localizedDescription)")
        } else if let signature = signature {
          print("successTransaction: \(signature)")
          transactionSignature = signature
        }
      }
      
      Button {
        isButtonClicked = true
      } label: {
        Text("nextScreen")
      }
      .navigationDestination(isPresented: $isButtonClicked) {
        SendSOLView(viewModel: viewModel)
      }
      .onAppear {
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
    }
  }
  
  func createTransaction(completion: @escaping ((_ serializedTransaction: String) -> Void)) {
    Task {
      do {
        let recentBlockhash = try await NetworkManager.shared.getBlockHash()
        
        _ = Solana(router: NetworkingRouter(endpoint: RPCEndpoint.devnetSolana))
        
        var transaction = Transaction(
          feePayer: walletPublicKey!,
          instructions: [
            SystemProgram.transferInstruction(
              from: walletPublicKey!,
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
