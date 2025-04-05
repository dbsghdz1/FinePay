//
//  HomeView.swift
//  FinePay
//
//  Created by 김민석 on 4/2/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var multipeerSession = MultipeerSession()
    @State private var selectedPeer: Peer? = nil
    @State private var sendingFromPeer: Peer? = nil
    @State private var isConnectingToPeer: Bool = false
    @State private var isSheetPresented = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                PeerView(
                    peers: multipeerSession.foundPeers,
                    inviteAction: { peer in
                        withAnimation {
                            selectedPeer = peer
                            sendingFromPeer = nil
                        }
                    }
                )
                .padding()
                
                BottomWalletView()
                    .padding(.bottom, 40)
            }

            dimmedBackground()
            invitePopup()
            sendingWalletPopup()
        }
        .ignoresSafeArea()
    }
}

extension HomeView {
    @ViewBuilder
    private func dimmedBackground() -> some View {
        if selectedPeer != nil || sendingFromPeer != nil {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture {
                    withAnimation {
                        selectedPeer = nil
                        sendingFromPeer = nil
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
        if let peer = sendingFromPeer {
            SendingWalletAddressPopupView(
                peer: peer,
                onSend: {
                    print("Send wallet address to \(peer.id)")
                    withAnimation {
                        sendingFromPeer = nil
                    }
                },
                reject: {
                    print("Rejected \(peer.id)'s request")
                    withAnimation {
                        sendingFromPeer = nil
                    }
                }
            )
            .transition(.move(edge: .bottom))
            .animation(.easeInOut, value: sendingFromPeer)
        }
    }
}


#Preview {
    HomeView()
}

