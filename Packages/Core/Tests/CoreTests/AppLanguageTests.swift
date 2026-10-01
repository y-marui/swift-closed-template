import XCTest
@testable import Core

final class AppLanguageTests: XCTestCase {

    func test_resolvedLocale_explicitLanguage_ignoresPreferredLanguages() {
        // Given
        let sut = AppLanguage.fr

        // When
        let locale = sut.resolvedLocale(preferredLanguages: ["ja-JP"])

        // Then
        XCTAssertEqual(locale.identifier, "fr")
    }

    func test_resolvedLocale_system_usesFirstSupportedPreferredLanguage() {
        // Given
        let preferred = ["de-DE", "es-MX", "ja-JP"]

        // When
        let locale = AppLanguage.system.resolvedLocale(preferredLanguages: preferred)

        // Then
        XCTAssertEqual(locale.identifier, "es")
    }

    func test_resolvedLocale_system_mapsRegionalVariantsToSupportedLanguages() {
        // Given / When
        let simplified = AppLanguage.system.resolvedLocale(preferredLanguages: ["zh-Hans-CN"])
        let mainland = AppLanguage.system.resolvedLocale(preferredLanguages: ["zh-CN"])
        let brazil = AppLanguage.system.resolvedLocale(preferredLanguages: ["pt-BR"])

        // Then
        XCTAssertEqual(simplified.identifier, "zh-Hans")
        XCTAssertEqual(mainland.identifier, "zh-Hans")
        XCTAssertEqual(brazil.identifier, "pt")
    }

    func test_resolvedLocale_system_unsupportedLanguage_fallsBackToEnglish() {
        // Given / When
        let locale = AppLanguage.system.resolvedLocale(preferredLanguages: ["de-DE", "ko-KR"])

        // Then
        XCTAssertEqual(locale.identifier, "en")
    }

    func test_resolvedLocale_system_traditionalChinese_fallsBackToEnglish() {
        // Given / When
        let hant = AppLanguage.system.resolvedLocale(preferredLanguages: ["zh-Hant"])
        let taiwan = AppLanguage.system.resolvedLocale(preferredLanguages: ["zh-TW"])

        // Then
        XCTAssertEqual(hant.identifier, "en")
        XCTAssertEqual(taiwan.identifier, "en")
    }

    func test_init_storedValue_unknownValue_becomesSystem() {
        // Given / When
        let sut = AppLanguage(storedValue: "zh")

        // Then
        XCTAssertEqual(sut, .system)
    }

    func test_init_storedValue_knownValue_restoresLanguage() {
        // Given / When
        let sut = AppLanguage(storedValue: "zh-Hans")

        // Then
        XCTAssertEqual(sut, .zhHans)
    }

    // MARK: - localizedString

    private func makeFixtureBundle() throws -> (Bundle, URL) {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("AppLanguageTests-\(UUID().uuidString).bundle")
        for (name, value) in [("ja", "こんにちは"), ("pt", "Olá")] {
            let dir = url.appendingPathComponent("\(name).lproj")
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            try "\"greeting\" = \"\(value)\";\n".write(
                to: dir.appendingPathComponent("Localizable.strings"), atomically: true, encoding: .utf8)
        }
        return (try XCTUnwrap(Bundle(url: url)), url)
    }

    func test_localizedString_explicitLanguage_returnsThatLanguage() throws {
        // Given
        let (bundle, url) = try makeFixtureBundle()
        defer { try? FileManager.default.removeItem(at: url) }

        // When / Then
        XCTAssertEqual(AppLanguage.ja.localizedString("greeting", bundle: bundle), "こんにちは")
        XCTAssertEqual(AppLanguage.pt.localizedString("greeting", bundle: bundle), "Olá")
    }

    func test_localizedString_system_usesFirstSupportedPreferredLanguage() throws {
        // Given
        let (bundle, url) = try makeFixtureBundle()
        defer { try? FileManager.default.removeItem(at: url) }

        // When
        let result = AppLanguage.system.localizedString(
            "greeting", bundle: bundle, preferredLanguages: ["xx", "pt-BR"])

        // Then
        XCTAssertEqual(result, "Olá")
    }

    func test_localizedString_missingLproj_fallsBackToKey() throws {
        // Given: `fr` の lproj がない
        let (bundle, url) = try makeFixtureBundle()
        defer { try? FileManager.default.removeItem(at: url) }

        // When
        let result = AppLanguage.fr.localizedString("missing", bundle: bundle)

        // Then
        XCTAssertEqual(result, "missing")
    }
}
