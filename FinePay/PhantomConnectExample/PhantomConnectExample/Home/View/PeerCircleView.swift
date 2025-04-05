//
//  PeerCircleView.swift
//  FinePay
//
//  Created by 김민석 on 4/2/25.
//

import SwiftUI

struct PeerCircleView: View {
    let name: String
    let emoji: String
    let onTap: () -> Void

    var body: some View {
        VStack {
            Text(emoji).font(.largeTitle)
            Text(name.suffix(4)).font(.caption)
        }
        .onTapGesture {
            onTap()
        }
    }
}
