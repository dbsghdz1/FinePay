//
//  SendView.swift
//  FinePay
//
//  Created by 김민석 on 4/3/25.
//

import SwiftUI

struct InvitePopupView: View {
    let peer: Peer
    let onSend: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            SentTextView(id: peer.id)

            Button(action: {
                onSend()
            }) {
                Text("Send SOL")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color(hex: "6F00EC"),
                                    Color(hex: "AC63FF")
                                ]
                            ),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .cornerRadius(12)
            }
            .frame(width: 188, height: 55)
        }
        .padding()
        .frame(maxWidth: .infinity,alignment: .center)
        .frame(height: 222)
        .background(Color(hex: "F4F4F4").opacity(0.9))
        .cornerRadius(24, corners: [.topLeft, .topRight])
    }
}


struct SentTextView: View {
    let id: String
    
    var body: some View {
        VStack {
            Text("Want to send")
                .font(.system(size: 26, weight: .semibold))
            
            (
                Text("Solana to ")
                    .font(.system(size: 26, weight: .semibold))
                +
                Text(id) // or peer.displayName
                    .font(.system(size: 26, weight: .bold))
            )
        }
        .multilineTextAlignment(.center)
    }
    
}

#Preview {
    InvitePopupView(peer: Peer(id: "hello", wallet: ""), onSend: {} )
}
