//
//  TokenInfo.swift
//  FinePay
//
//  Created by Yunhong on 4/5/25.
//

import SwiftUI

struct TokenInfo: Codable {
  let jsonrpc: String
  let result: Result
  let id: Int
}

struct Result: Codable {
  let context: ContextModel
  let value: UInt64
}

struct ContextModel: Codable {
  let apiVersion: String
  let slot: UInt64
}
