//
//  ExtensionTests.swift
//  PaWPal
//
//  Created by Tiffany Fong on 11/19/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import XCTest
@testable import PaWPal

/**
 *  This file tests non-UI extensions created in PaWPal.
 */

class ExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
     *  String+IsValidEmail.swift
     *
     *  Tests if a string matches an email regex
     */
    func testIsValidEmail() {
        // major domain names
        XCTAssertTrue("test@gmail.com".isValidEmail())
        XCTAssertTrue("test@yahoo.com".isValidEmail())
        
        // 5C emails
        XCTAssertTrue("test@g.hmc.edu".isValidEmail())
        XCTAssertTrue("test@hmc.edu".isValidEmail())
        XCTAssertTrue("test@scrippscollege.edu".isValidEmail())
        XCTAssertTrue("test@pomona.edu".isValidEmail())
        XCTAssertTrue("test@students.pitzer.edu".isValidEmail())
        XCTAssertTrue("test@cmc.edu".isValidEmail())
    }
    
    /**
     *  UIColor+initWithHex.swift
     *
     *  Tests initializing colors concisely
     */
    func testUIColor() {
        // official UIColors
        let red = UIColor.redColor()
        let cyan = UIColor.cyanColor()
        let brown = UIColor.brownColor()
        
        // init with r,g,b as ints, fully opqaue
        XCTAssertEqual(UIColor(red: 255, green: 0, blue: 0), red)
        XCTAssertEqual(UIColor(red: 0, green: 255, blue: 255), cyan)
        XCTAssertEqual(UIColor(red: 153, green: 102, blue: 51), brown)
        
        // init with hexadecimal rgb format
        XCTAssertEqual(UIColor(netHex: 0xFF0000), red)
        XCTAssertEqual(UIColor(netHex: 0x00FFFF), cyan)
        XCTAssertEqual(UIColor(netHex: 0x996633), brown)
        
        // PaWPal color scheme
        XCTAssertEqual(UIColor.tangerineColor(), UIColor(netHex: 0xFE9225))
    }
}
