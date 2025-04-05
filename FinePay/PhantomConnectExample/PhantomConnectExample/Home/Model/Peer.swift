//
//  Peer.swift
//  FinePay
//
//  Created by 김민석 on 4/2/25.
//

struct Peer: Equatable, Identifiable {
    let id: String
    let displayName: String
    let wallet: String
    
    init(id: String, displayName: String, wallet: String) {
        self.id = id
        self.displayName = displayName
        self.wallet = wallet
    }
}
