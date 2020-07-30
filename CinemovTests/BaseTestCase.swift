//
//  BaseTestCase.swift
//  CinemovTests
//
//  Created by Febri Adrian on 30/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

@testable import Cinemov
import XCTest

class ViewControllerTestCase: XCTestCase {
    var rootWindow: UIWindow? {
        return appDelegate.window
    }

    override func setUp() {
        let rootViewController = MainViewController()
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.makeKeyAndVisible()
        appDelegate.window?.rootViewController = rootViewController
    }

    override func tearDown() {
        appDelegate.window = nil
    }
}

class ViewTestCase: XCTestCase {
    var rootView: UIView {
        return viewController.view
    }

    private var viewController: UIViewController!

    override func setUp() {
        viewController = UIViewController()

        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.makeKeyAndVisible()
        appDelegate.window?.rootViewController = viewController
    }

    override func tearDown() {
        viewController = nil
        appDelegate.window = nil
    }
}

extension XCTestCase {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func wait(timeout: TimeInterval) {
        let expectation = XCTestExpectation(description: "Waiting for \(timeout) seconds")
        XCTWaiter().wait(for: [expectation], timeout: timeout)
    }
}
