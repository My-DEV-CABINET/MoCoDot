//
//  TranslateEnglishToMorseTests.swift
//  MoCoDotTests
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import XCTest

@testable import MoCoDot

final class TranslateEnglishToMorseTests: XCTestCase {
    private var englishTranslateService: EnglishToMorseTranslateProtocol!

    // 각각의 테스트 메서드가 실행되기 전에 setup 이 먼저 실행되어 값을 재설정 시켜줌
    override func setUp() {
        super.setUp()

        /// 초기화
        englishTranslateService = EnglishToMorseTranslateService()
    }

    func test1() {
        var result = englishTranslateService.translateMorse(at: "H")

        XCTAssertEqual(result, ".... ", "둘의 출력 결과가 다릅니다")
    }

    override class func tearDown() {
        super.tearDown()
    }
}
