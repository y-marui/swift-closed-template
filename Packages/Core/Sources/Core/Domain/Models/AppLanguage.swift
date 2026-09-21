import Foundation

public enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case system
    case ja, en
    case zhHans = "zh-Hans"
    case hi, es, fr, pt

    public static let storageKey = "appLanguage"

    public var id: String { rawValue }

    /// 各言語の自国語表記。`system` だけはローカライズ対象のため nil を返す。
    public var nativeName: String? {
        switch self {
        case .system: nil
        case .ja: "日本語"
        case .en: "English"
        case .zhHans: "简体中文"
        case .hi: "हिन्दी"
        case .es: "Español"
        case .fr: "Français"
        case .pt: "Português"
        }
    }

    public var resolvedLocale: Locale {
        resolvedLocale(preferredLanguages: Locale.preferredLanguages)
    }

    /// 保存値を復元する。未知の値は `system` として扱う。
    public init(storedValue: String) {
        self = AppLanguage(rawValue: storedValue) ?? .system
    }

    public func resolvedLocale(preferredLanguages: [String]) -> Locale {
        guard self == .system else { return Locale(identifier: rawValue) }
        for identifier in preferredLanguages {
            if let match = Self.supportedLanguage(matching: identifier) {
                return Locale(identifier: match.rawValue)
            }
        }
        return Locale(identifier: AppLanguage.en.rawValue)
    }

    // 繁体字（zh-Hant、および script のない zh-TW / zh-HK / zh-MO）は対応外
    private static func supportedLanguage(matching identifier: String) -> AppLanguage? {
        let language = Locale.Language(identifier: identifier)
        guard let code = language.languageCode?.identifier else { return nil }
        if code == "zh" {
            return isSimplifiedChinese(language) ? .zhHans : nil
        }
        return allCases.first { $0 != .system && $0 != .zhHans && $0.rawValue == code }
    }

    private static func isSimplifiedChinese(_ language: Locale.Language) -> Bool {
        if let script = language.script?.identifier {
            return script == "Hans"
        }
        let traditionalRegions: Set<String> = ["TW", "HK", "MO"]
        return !traditionalRegions.contains(language.region?.identifier ?? "")
    }
}
