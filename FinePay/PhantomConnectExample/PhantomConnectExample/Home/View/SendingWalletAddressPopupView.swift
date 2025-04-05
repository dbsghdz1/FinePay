//
//  InviteView.swift
//  FinePay
//
//  Created by 김민석 on 4/4/25.
//


import SwiftUI

struct SendingWalletAddressPopupView: View {
    let peer: Peer
    let onSend: () -> Void
    let reject: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            SendingWalletTextView(displayName: peer.displayName)

            SendingWalletButtonView(onSend: onSend, reject: reject)
        }
        .padding()
        .frame(maxWidth: .infinity,alignment: .center)
        .frame(height: 222)
        .background(Color(hex: "F4F4F4").opacity(0.9))
        .cornerRadius(24, corners: [.topLeft, .topRight])
    }
}


struct SendingWalletTextView: View {
    let displayName: String
    
    var body: some View {
        (
            Text(displayName.suffix(4))
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.mainColor)
            +
            Text(" want your wallet address")
                .font(.system(size: 26, weight: .semibold))
        )
        .multilineTextAlignment(.center)
    }
}

struct SendingWalletButtonView: View {
    let onSend: () -> Void
    let reject: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                onSend()
            }) {
                Text("Reject")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonGrayColor)
                    .cornerRadius(10)
            }
            .frame(width: 173, height: 55)
            
            Button(action: {
                onSend()
            }) {
                Text("Share")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.mainColor)
                    .cornerRadius(10)
            }
            .frame(width: 173, height: 55)
        }
    }
}

#Preview {
    SendingWalletAddressPopupView(peer: Peer(id: "hello", displayName: "iPhone16", wallet: ""), onSend: {}, reject: {} )
}
