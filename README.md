#Korean below

# 📡 FinePay – Peer-to-Peer Wallet Address Sharing & Solana Transfer

An iOS app built with Swift that allows seamless exchange of wallet addresses and instant Solana transfers between iPhones using MultipeerConnectivity.

> Developed for a hackathon to explore the future of mobile-native wallet UX.

---

## ✨ Features

- 📲 **Automatic wallet address sharing**  
  Uses MultipeerConnectivity to discover nearby devices and exchange wallet addresses — no QR codes or copy/paste.

- ⚡ **One-tap Solana (SOL) transfer**  
  Transfer SOL instantly via Phantom wallet after receiving the address.

- 🧠 **Phantom Wallet API integration**  
  Safe and user-approved transactions through Phantom’s signing process.

- 🔗 **Built for the Solana ecosystem**  
  Fast, low-cost, and mobile-native.

---

## 📱 Tech Stack

| Layer              | Technology             |
|--------------------|------------------------|
| Language           | Swift                  |
| UI Framework       | SwiftUI                |
| Connectivity       | MultipeerConnectivity  |
| Wallet Integration | Phantom Mobile Wallet  |
| Blockchain         | Solana (Devnet)        |
| Platform           | iOS                    |

---

## 🚀 Getting Started

### Requirements

- Xcode 15+
- iOS 17.0+
- Phantom Wallet (Devnet IMPORTANT!)
- iPhone for peer testing
- apple developer account (if you want to try on real iphone)

### Run The App

git clone https://github.com/dbsghdz1/FinePay.git

go to FinePay/PhantomConnectExample


run FinePay.xcodeproj

wait a few minutes for indexing, this is This process may vary depending on the computer.


Run the project. you might need (two iphone) or (simulate and iphone). if this is your first time, you need c-type charging line.
(you need developer account on real iphone)


When you launch the app, Phantom will open automatically. Please connect your wallet.

(On first launch, the app may take longer than expected to start. Please wait patiently.)

(your phantom must be on Testnet Mode, check that network is Solana Devnet.)


Next, nearby devices will appear around your location. Tap the person you want to send SOL to.


Set the amount of SOL you want to send.


Sending...


Done!

---

## 🔮 Future Plans

- 🌉 **Wormhole Integration**  
  Support bridging assets from Ethereum, Polygon, BNB to Solana and sending them with the same mobile UX.

- 🪙 **Multi-token support**  
  Support SPL tokens, wrapped assets, and more advanced metadata handling.

---

## 💬 Why This Project?

Most wallet transfers rely on copy-pasting or QR codes.  
We asked: _“What if sending crypto was as easy as AirDrop?”_  
FinePay delivers that experience using Apple’s native P2P tech and Solana’s speed.

---

## 🛡️ Security Notes

- All transactions require explicit confirmation via Phantom.
- The app does **not** store or access private keys.
- Peer discovery is limited to local Wi-Fi/Bluetooth range.

---

## 👨‍💻 Authors

- Changhee Lee(Zani) – https://github.com/cchangss
- Gyeongju Kim(Jacob) – https://github.com/Gimgang00
- Minseok Kim(Kinder) – https://github.com/alstjr7437
- Yongwon SEO(Paduck) – https://github.com/paohree
- Yunhong Kim(Hong) – https://github.com/dbsghdz1

---

#Korean version

---

# 📡 FinePay – 기기간 지갑 주소 공유 & Solana 송금 앱

iPhone 간의 근거리 연결을 통해 Phantom 지갑 주소를 자동 공유하고, Solana(SOL)를 즉시 송금하는 Swift 기반 모바일 앱입니다.

> 해커톤을 위해 개발된 이 프로젝트는 “모바일 지갑 간의 사용자 경험”을 재정의합니다.

---

## ✨ 주요 기능

- 📲 **MultipeerConnectivity 기반 주소 교환**  
  주변 iPhone 기기와 자동으로 연결되어 Solana 지갑 주소를 주고받습니다.

- ⚡ **즉시 Solana 송금**  
  주소를 받으면 Phantom 지갑 연동으로 즉시 SOL 전송이 가능합니다.

- 🧠 **Phantom Wallet API 연동**  
  트랜잭션 서명 및 전송 과정을 Phantom 지갑과 안전하게 연동합니다.

- 🔗 **Solana 생태계에 최적화된 경험**  
  빠르고 저렴한 Solana 네트워크에 맞춰 설계된 모바일 지갑 간 UX입니다.

---

## 📱 사용 기술

| 계층          | 기술 스택                  |
|---------------|-----------------------------|
| 언어           | Swift                        |
| UI 프레임워크   | SwiftUI                     |
| 기기 간 연결   | MultipeerConnectivity       |
| 지갑 연동     | Phantom Mobile Wallet       |
| 블록체인      | Solana (Devnet)             |
| 플랫폼        | iOS                         |

---

## 🚀 실행 방법

### 요구 사항

- Xcode 15 이상
- iOS 17.0 이상
- Phantom 지갑 (Devnet 설정 중요합니다!)
- 실기기 1대 (P2P 테스트용)
- 

### 실행

고쳐야 함

git clone https://github.com/dbsghdz1/FinePay.git

FinePay/PhantomConnectExample 로 이동

FinePay.xcodeproj 실행


인덱싱을 위해 잠시 기다려주세요. 이 과정은 컴퓨터 성능에 따라 차이가 날 수 있습니다.

프로젝트를 실행해주세요. 송금 실험을 위해 (두개의 아이폰) 또는 (시뮬레이터와 아이폰)이 필요합니다. 만약 이 과정이 처음이라면, c 타입 충전선으로 연결할 필요가 있습니다. 

(실제 아이폰으로 동작시키려는 경우, 애플 개발자 계정이 필요할 수 있습니다.)


앱을 실행하면 자동으로 팬텀이 실행됩니다. 연결해 주세요.

(첫 실행시 앱 실행에 시간이 생각보다 오래 걸립니다. 기다려주세요.)

(팬텀이 Testnet 모드여야 합니다. Solana Devnet 네트워크인지 확인해주세요.)


이후 나를 중심으로 해 주변 기기가 표시됩니다. 송금하려는 사람을 눌러주세요.


몇 SOL을 보내려는지 설정해주세요.


송금합니다.


끝!

---

## 🔮 확장 계획

- 🌉 **Wormhole 연동**  
  Ethereum, Polygon, BNB 체인의 토큰을 Solana로 가져와 같은 방식으로 송금할 수 있도록 지원 예정.

- 🪙 **멀티 토큰 전송**  
  SOL 외에도 SPL 토큰 및 Wrapped 자산 전송 기능 추가 예정.

---

## ❓ 왜 만들었나요?

지금까지 대부분의 지갑 송금은 주소 복붙, 메시지 공유, QR 스캔에 의존하고 있었습니다.  
우리는 물었습니다: **“AirDrop처럼 자연스럽게 지갑을 공유하고 보낼 순 없을까?”**  
Finepay는 바로 그 경험을 Swift와 Solana로 실현했습니다.

---

## 🛡️ 보안 및 주의사항

- 트랜잭션은 Phantom 앱을 통해 명시적 승인 후 처리됩니다.
- 앱은 지갑의 개인 키를 저장하거나 접근하지 않습니다.
- 연결은 로컬 P2P (Wi-Fi, Bluetooth) 환경 내에서만 이루어집니다.

---

## 👨‍💻 개발자

- 김경주(Jacob) – https://github.com/Gimgang00
- 김민석(Kinder) – https://github.com/alstjr7437
- 김윤홍(Hong) –  https://github.com/dbsghdz1
- 서용원(Paduck) – https://github.com/paohree
- 이창희(Zani) – https://github.com/cchangss


