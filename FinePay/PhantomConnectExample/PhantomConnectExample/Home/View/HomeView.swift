//
//  HomeView.swift
//  FinePay
//
//  Created by 김민석 on 4/2/25.
//

import SwiftUI

import PhantomConnect

struct HomeView: View {
    @StateObject var multipeerSession = MultipeerSession()
    @State private var selectedPeer: Peer? = nil
    //TODO: Viewmodel 수정
    private let viewModel = PhantomConnectViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                PeerView(
                    peers: multipeerSession.foundPeers,
                    inviteAction: { peer in
                        withAnimation {
                            selectedPeer = peer
                        }
                    }
                )
                .padding()
                
                BottomWalletView(viewModel: viewModel, sessionID: String(multipeerSession.myPeerId.id.suffix(4)))
                    .padding(.bottom, 40)
                    .onAppear {
                      PhantomConnect.configure(
                        appUrl: "https://example.com",
                        cluster: "devnet",
                        redirectUrl: "example://"
                      )
                        try? viewModel.connectWallet()
                    }

            }

            dimmedBackground()
            invitePopup()
            sendingWalletPopup()
            presentSendingSOL()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
//        .onAppear {
//          PhantomConnect.configure(
//            appUrl: "https://example.com",
//            cluster: "devnet",
//            redirectUrl: "example://"
//          )
//            try? viewModel.connectWallet()
//        }
    }
}

extension HomeView {
    @ViewBuilder
    private func dimmedBackground() -> some View {
        if selectedPeer != nil || multipeerSession.sendingFromPeer != nil {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture {
                    withAnimation {
                        selectedPeer = nil
                        multipeerSession.sendingFromPeer = nil
                    }
                }
        }
    }

    @ViewBuilder
    private func invitePopup() -> some View {
        if let peer = selectedPeer {
            InvitePopupView(peer: peer) {
                multipeerSession.invite(peer)
                withAnimation {
                    selectedPeer = nil
                }
            }
            .transition(.move(edge: .bottom))
            .animation(.easeInOut, value: selectedPeer)
        }
    }

    @ViewBuilder
    private func sendingWalletPopup() -> some View {
        if let peer = multipeerSession.sendingFromPeer {
            SendingWalletAddressPopupView(
                peer: peer,
                onSend: {
                    print("✅ Send wallet address to \(peer.id)")
                    let myAddress = UserDefaults.standard.string(forKey: "walletPublicKey") ?? ""
                    multipeerSession.respondToInvite(accept: true, address: myAddress)
                    withAnimation {
                        multipeerSession.sendingFromPeer = nil
                    }
                },
                reject: {
                    print("❌ Rejected \(peer.id)'s request")
                    multipeerSession.respondToInvite(accept: false, address: "")
                    withAnimation {
                        multipeerSession.sendingFromPeer = nil
                    }
                }
            )
            .transition(.move(edge: .bottom))
            .animation(.easeInOut, value: multipeerSession.sendingFromPeer)
        }
    }
    
    @ViewBuilder
    private func presentSendingSOL() -> some View {
        if let address = multipeerSession.giverAddress {
            SendSOLView(
                viewModel: viewModel,
                giverAddress: address,
                myAddress: UserDefaults.standard.string(forKey: "walletPublicKey") ?? "",
                nickName: String(
                    multipeerSession.connectPeer?.id.suffix(4) ?? ""
                )
            )
        }
    }
}
