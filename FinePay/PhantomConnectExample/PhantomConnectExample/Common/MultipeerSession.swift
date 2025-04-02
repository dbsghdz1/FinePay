//
//  MultipeerSession.swift
//  FinePay
//
//  Created by 김민석 on 4/2/25.
//

import MultipeerConnectivity
import os

/// # Mlultipeer Session 객체
/// serviceType :  서비스를 식별
/// foundPeers : 찾은 피어들(유저들)
/// connectedPeers : 현재 연결 중인 유저

class MultipeerSession: NSObject, ObservableObject {

    private let serviceType = "MCTest"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    private let session: MCSession
    private let log = Logger()
    
    @Published var foundPeers: [Peer] = []
    @Published var connectedPeers: MCPeerID?
    private var pendingInvitationHandler: ((Bool, MCSession?) -> Void)?

    // MARK: init
    
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)

        super.init()

        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self

        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }

    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    // MARK: Custom Method
    
    func invite(_ peer: Peer) {
        let mcPeerID = MCPeerID(displayName: peer.id)
        log.info("📩 초대 전송: \(mcPeerID.displayName)")
        serviceBrowser.invitePeer(mcPeerID, to: session, withContext: nil, timeout: 10)
    }
    
    func send() {
        log.info("send to \(self.session.connectedPeers.count) peers")
    }

    func respondToInvite(accept: Bool) {
        if let handler = pendingInvitationHandler {
            handler(accept, session)
            pendingInvitationHandler = nil
        }
        connectedPeers = nil
    }
}

// MARK: - 근처 피어로 세션 초대시

extension MultipeerSession: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.connectedPeers = peerID
            self.pendingInvitationHandler = invitationHandler
        }
    }
}

// MARK: - 브라우저 이벤트 처리 위임자

extension MultipeerSession: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        DispatchQueue.main.async {
            if !self.foundPeers.contains(where: { $0.id == peerID.displayName }) {
                // TODO: - 추후에 wallet 주소 받아서 넣기
                self.foundPeers.append(Peer(id: peerID.displayName, wallet: ""))
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
    }
}

// MARK: - Session 위임자

extension MultipeerSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        DispatchQueue.main.async {
            self.connectedPeers = peerID
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        log.info("didReceive")
    }

    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.error("Receiving resources is not supported")
    }

    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        log.error("Receiving resources is not supported")
    }
}

extension MCPeerID: @retroactive Identifiable {
    public var id: String { displayName }
}
