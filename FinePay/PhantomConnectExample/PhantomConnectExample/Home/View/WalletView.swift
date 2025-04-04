//
//  WalletView.swift
//  FinePay
//
//  Created by 김민석 on 4/3/25.
//

import SwiftUI

struct BottomWalletView: View {
    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.top, 8)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Wallet")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Connected")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "wallet.pass")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 21)
        }
        .background(Color(hex: "F4F4F4"))
        .cornerRadius(26)
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(Color(hex: "DBDBDB"), lineWidth: 0.5)
        )
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
    }
}

#Preview {
    BottomWalletView()
}
