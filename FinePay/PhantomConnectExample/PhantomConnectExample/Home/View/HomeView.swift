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
    @State private var isSheetPresented = false

    var body: some View {
        ZStack(
            alignment: .bottom
        ) {
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
                
                BottomWalletView()
                    .padding(.bottom, 40)
            }
            
            if selectedPeer != nil {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation { selectedPeer = nil }
                    }
            }
            
            if let peer = selectedPeer {
                SendView(peer: peer) {
                    multipeerSession
                        .invite(peer)
                    withAnimation {
                        selectedPeer = nil
                    }
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: selectedPeer)
            }
        }
        .ignoresSafeArea()
    }
}



#Preview {
    HomeView()
}

