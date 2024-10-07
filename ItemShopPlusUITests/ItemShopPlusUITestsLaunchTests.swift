//
//  ItemShopPlusUITestsLaunchTests.swift
//  ItemShopPlusUITests
//
//  Created by Roman Tverdokhleb on 10/2/24.
//

import XCTest

final class ItemShopPlusUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
