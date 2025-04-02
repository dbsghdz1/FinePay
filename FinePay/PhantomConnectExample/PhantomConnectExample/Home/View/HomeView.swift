//
//  HomeView.swift
//  FinePay
//
//  Created by 김민석 on 4/2/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var multipeerSession = MultipeerSession()

    var body: some View {
        VStack {
            PeerView(
                peers: multipeerSession.foundPeers,
                inviteAction: { peer in
                    multipeerSession.invite(peer)
                }
            )
            .frame(height: 400)
        }
        .padding()
        .alert(item: $multipeerSession.connectedPeers) { peer in
            Alert(
                title: Text("초대 수신"),
                message: Text("‘\(peer.displayName)’님이 초대했습니다. 수락하시겠습니까?"),
                primaryButton: .default(Text("수락")) {
                    multipeerSession.respondToInvite(accept: true)
                },
                secondaryButton: .cancel(Text("거절")) {
                    multipeerSession.respondToInvite(accept: false)
                }
            )
        }
    }
}

#Preview {
    HomeView()
}
