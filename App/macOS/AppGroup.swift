import Foundation

// Widget・Intents 等の Extension と設定を共有するため、UserDefaults は App Group に置く。
enum AppGroup {
    static let identifier = "group.y.marui.Swift-AI-App-Template"

    static var userDefaults: UserDefaults {
        UserDefaults(suiteName: identifier) ?? .standard
    }
}
