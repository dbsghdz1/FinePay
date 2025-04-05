//
//  NetworkManager.swift
//  FinePay
//
//  Created by Yunhong on 4/2/25.
//

import Foundation

final class NetworkManager {
  
  static let shared = NetworkManager()
  private init() {}
  
  func getBlockHash() async throws -> String {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.devnet.solana.com"
    
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-type")
    
    let body = [
      "jsonrpc": "2.0",
      "id": 1,
      "method": "getLatestBlockhash",
      "params": []
    ] as [String: Any]
    
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch {
      print(error)
    }
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let blockHash = try JSONDecoder().decode(BlockHashModel.self, from: data)
    return blockHash.result.value.blockhash
  }
  
  func fetchSOLBalance(address: String) async throws -> String {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.devnet.solana.com"
    var request = URLRequest(url: urlComponents.url!)
    
    request.httpMethod = HttpMethod.POST.rawValue
    
    let body: [String: Any] = [
        "jsonrpc": "2.0",
        "id": 1,
        "method": "getBalance",
        "params": [address]
    ]
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch {
      print(error)
    }
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let tokenInfo = try JSONDecoder().decode(TokenInfo.self, from: data)
    let rawLamports = tokenInfo.result.value
    let sol = Double(rawLamports) / 10_0000_0000
    return sol.formatted()
  }
}
