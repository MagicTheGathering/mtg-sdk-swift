# MTGSDKSwift

Swift SDK for the [Magic: The Gathering API](https://magicthegathering.io/).

## Stack

- **Language:** Swift 4.1
- **Platform:** iOS 10.2+ (Xcode project)
- **Package Managers:** CocoaPods, Carthage
- **Testing:** XCTest
- **CI:** Fastlane

## Build & Test

```bash
# Build
xcodebuild -project MTGSDKSwift.xcodeproj -scheme MTGSDKSwift -destination "platform=iOS Simulator,name=iPhone 16" build

# Run tests
xcodebuild -project MTGSDKSwift.xcodeproj -scheme MTGSDKSwift -destination "platform=iOS Simulator,name=iPhone 16" test
```

## Project Structure

- `MTGSDKSwift/` — Library source code
  - `Card.swift` — Card model
  - `CardSet.swift` — CardSet model
  - `SearchParameter.swift` — Query parameter types
  - `MTGAPIManager.swift` — API networking layer
  - `MagicalCardManager.swift` — High-level card operations
  - `Parser.swift` — JSON parsing
  - `NetworkError.swift` — Error types
- `MTGSDKSwiftTests/` — Unit tests
- `fastlane/` — Fastlane CI configuration

## Conventions

- Follow existing Swift API Design Guidelines naming conventions
- Use completion handler pattern for async API calls
- Unit tests go in `MTGSDKSwiftTests/`
- Use gitmoji prefixes for commit messages (e.g., `✨ feat`, `🐛 fix`, `♻️ refactor`)
