//
//  Peer.swift
//  FinePay
//
//  Created by 김민석 on 4/2/25.
//

import MultipeerConnectivity

struct Peer: Equatable, Identifiable {
    let id: String
    let displayName: String
    let wallet: String
    let peerID: MCPeerID?
    
    init(id: String, displayName: String, wallet: String, peerID: MCPeerID? = nil) {
        self.id = id
        self.displayName = displayName
        self.wallet = wallet
        self.peerID = peerID
    }
}
