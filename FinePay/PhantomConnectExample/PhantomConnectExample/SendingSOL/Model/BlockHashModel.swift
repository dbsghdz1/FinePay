//
//  BlockHashModel.swift
//  FinePay
//
//  Created by Yunhong on 4/2/25.
//

struct BlockHashModel: Codable {
  let jsonrpc: String
  let result: HashResult
  let id: Int
}

struct HashResult: Codable {
  let context: Context
  let value: Value
}

struct Context: Codable {
  let apiVersion: String
  let slot: Int
}

struct Value: Codable {
  let blockhash: String
  let lastValidBlockHeight: Int
}
