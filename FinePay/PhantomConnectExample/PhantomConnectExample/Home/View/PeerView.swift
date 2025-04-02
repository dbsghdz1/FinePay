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
    let centerEmoji = "😎"
    let centerLabel = "나"
    let emojis = ["👾", "🤖", "👻", "🧠", "👽", "🐸", "🦄", "🐙"]
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                // stroke 생성
                ForEach(1..<4) { i in
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        .frame(width: radius * CGFloat(i), height: radius * CGFloat(i))
                        .position(center)
                }
                
                // 본인 생성
                PeerCircleView(name: centerLabel, emoji: centerEmoji, onTap: {})
                
                // 유저들 생성
                ForEach(peers.indices, id: \.self) { index in
                    let angle = Double(index) / Double(peers.count) * 2 * Double.pi
                    let x = center.x + radius * cos(angle)
                    let y = center.y + radius * sin(angle)
                    
                    PeerCircleView(
                        name: peers[index].id,
                        emoji: emojis[index % emojis.count],
                        onTap: {
                            inviteAction(peers[index])
                        }
                    )
                    .position(x: x, y: y)
                }
            }
        }
    }
}


