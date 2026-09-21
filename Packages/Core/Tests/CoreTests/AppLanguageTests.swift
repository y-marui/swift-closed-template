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
}
