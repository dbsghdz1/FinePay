import SwiftUI

// MARK: - 토큰 정보 모델
struct TokenInfo: Identifiable {
    let id = UUID()
    let mint: String
    let amount: Double
}

// MARK: - 트랜잭션 정보 모델
struct TransactionInfo: Identifiable {
    let id = UUID()
    let signature: String
    let slot: Int
    let blockTime: Int?
}

// MARK: - 메인 뷰
struct ContentView: View {
    @State private var walletAddress: String = "B9hNZruBjAQSdrYYvktnPgGTPsVbY82MyxCZcHraVsZZ" // 예: "3xyz...abc"
    @State private var solBalance: Double?
    @State private var tokens: [TokenInfo] = []
    @State private var transactions: [TransactionInfo] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("지갑 주소를 입력하세요")
                        .font(.headline)

                    TextField("예: 3xyz...abc", text: $walletAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)

                    // 버튼 2개 가로 배치
                    HStack(spacing: 12) {
                        Button("토큰 조회") {
                            tokens = []
                            solBalance = nil
                            transactions = []
                            fetchTokens(for: walletAddress)
                            fetchSOLBalance(for: walletAddress)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("내역 조회") {
                            transactions = []
                            fetchTransactionHistory(for: walletAddress)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    Divider()

                    // SOL 잔액
                    if let sol = solBalance {
                        Text("SOL 잔액: \(sol) SOL")
                            .font(.title3)
                            .bold()
                    }

                    // SPL 토큰
                    if !tokens.isEmpty {
                        Text("SPL 토큰 목록")
                            .font(.headline)

                        ForEach(tokens) { token in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("수량: \(token.amount)")
                                Text("Mint: \(token.mint)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 6)
                        }
                    } else {
                        Text("토큰 정보가 없습니다.")
                            .foregroundColor(.gray)
                    }

                    // 트랜잭션 내역
                    if !transactions.isEmpty {
                        Divider()
                        Text("🧾 최근 트랜잭션")
                            .font(.headline)

                        ForEach(transactions) { tx in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("📦 Signature: \(tx.signature.prefix(20))...")
                                    .font(.subheadline)
                                Text("🕒 Slot: \(tx.slot)")
                                    .font(.caption)
                                if let time = tx.blockTime {
                                    Text("⏱️ Time: \(Date(timeIntervalSince1970: TimeInterval(time)))")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.bottom, 6)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Solana Devnet 지갑 뷰어")
        }
    }

    // MARK: - SOL 잔액 조회
    func fetchSOLBalance(for address: String) {
        guard let url = URL(string: "https://api.devnet.solana.com") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let rpcRequest: [String: Any] = [
            "jsonrpc": "2.0",
            "id": 1,
            "method": "getBalance",
            "params": [address]
        ]

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: rpcRequest)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let result = json["result"] as? [String: Any],
                  let lamports = result["value"] as? Double else {
                print("SOL 잔액 파싱 실패: \(error?.localizedDescription ?? "unknown")")
                return
            }

            let sol = lamports / 1_000_000_000
            DispatchQueue.main.async {
                self.solBalance = sol
            }
        }.resume()
    }

    // MARK: - SPL 토큰 계정 조회
    func fetchTokens(for address: String) {
        guard let url = URL(string: "https://api.devnet.solana.com") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let rpcRequest: [String: Any] = [
            "jsonrpc": "2.0",
            "id": 1,
            "method": "getTokenAccountsByOwner",
            "params": [
                address,
                ["programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"],
                ["encoding": "jsonParsed"]
            ]
        ]

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: rpcRequest)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let result = json["result"] as? [String: Any],
                  let value = result["value"] as? [[String: Any]] else {
                print("토큰 파싱 실패: \(error?.localizedDescription ?? "unknown")")
                return
            }

            var fetchedTokens: [TokenInfo] = []

            for tokenAccount in value {
                guard let account = tokenAccount["account"] as? [String: Any],
                      let data = account["data"] as? [String: Any],
                      let parsed = data["parsed"] as? [String: Any],
                      let info = parsed["info"] as? [String: Any],
                      let mint = info["mint"] as? String,
                      let amount = (info["tokenAmount"] as? [String: Any])?["uiAmount"] as? Double else {
                    continue
                }

                let token = TokenInfo(mint: mint, amount: amount)
                fetchedTokens.append(token)
            }

            DispatchQueue.main.async {
                self.tokens = fetchedTokens
            }
        }.resume()
    }

    // MARK: - 트랜잭션 내역 조회
    func fetchTransactionHistory(for address: String) {
        guard let url = URL(string: "https://api.devnet.solana.com") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let rpcRequest: [String: Any] = [
            "jsonrpc": "2.0",
            "id": 1,
            "method": "getSignaturesForAddress",
            "params": [
                address,
                ["limit": 10]
            ]
        ]

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: rpcRequest)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let result = json["result"] as? [[String: Any]] else {
                print("트랜잭션 조회 실패: \(error?.localizedDescription ?? "unknown")")
                return
            }

            let parsed = result.compactMap { tx -> TransactionInfo? in
                guard let signature = tx["signature"] as? String,
                      let slot = tx["slot"] as? Int else {
                    return nil
                }
                let blockTime = tx["blockTime"] as? Int
                return TransactionInfo(signature: signature, slot: slot, blockTime: blockTime)
            }

            DispatchQueue.main.async {
                self.transactions = parsed
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
