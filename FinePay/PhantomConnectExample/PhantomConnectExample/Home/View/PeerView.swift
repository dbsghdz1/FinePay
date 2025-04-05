//
//  PeerView.swift
//  FinePay
//
//  Created by 김민석 on 4/2/25.
//

import SwiftUI

struct PeerView: View {
    let peers: [Peer]
    let inviteAction: (Peer) -> Void
    let centerEmoji = "😊"
    let centerLabel = "나"
    let emojis = ["👾", "🤖", "👻", "🧠", "👽", "🐸", "🦄", "🐙"]
    
    @State private var peerPositions: [String: CGPoint] = [:]
    
    var body: some View {
        GeometryReader { geometry in
            renderPeerView(in: geometry)
        }
    }
    
    @ViewBuilder
    private func renderPeerView(in geometry: GeometryProxy) -> some View{
        let radius = min(geometry.size.width, geometry.size.height) / 3
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        
        ZStack {
            // stroke 생성
            ForEach(1..<5) { i in
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    .frame(width: radius * CGFloat(i), height: radius * CGFloat(i))
                    .position(center)
            }
            
            // 본인 생성
            PeerCircleView(name: centerLabel, emoji: centerEmoji, onTap: {})
            
            // 유저들 생성
            ForEach(peers.indices, id: \.self) { index in
                let peer = peers[index]

                if let position = peerPositions[peer.displayName] {
                    PeerCircleView(
                        name: peer.displayName,
                        emoji: emojis[index % emojis.count],
                        onTap: {
                            inviteAction(peer)
                        }
                    )
                    .position(position)
                }
            }
        }
        .onChange(of: peers) { newPeers in
            let currentIDs = Set(newPeers.map { $0.id })
            peerPositions = peerPositions.filter { currentIDs.contains($0.key) }
            
            for peer in newPeers where peerPositions[peer.id] == nil {
                let angle = Double.random(in: 0...(2 * .pi))
                let distance = Double.random(in: 40...(radius - 40))
                let x = center.x + CGFloat(cos(angle) * distance)
                let y = center.y + CGFloat(sin(angle) * distance)
                peerPositions[peer.id] = CGPoint(x: x, y: y)
            }
        }
    }
}


