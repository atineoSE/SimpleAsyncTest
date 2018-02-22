//
//  SimpleAsyncTestTests.swift
//  SimpleAsyncTestTests
//
//  Created by Tineo Adrian on 22.02.18.
//  Copyright © 2018 Tineo Adrian. All rights reserved.
//

import XCTest
@testable import SimpleAsyncTest

class SimpleAsyncTestTests: XCTestCase {
    var sut: MyClass!
    
    override func setUp() {
        super.setUp()
        sut = MyClass()
    }

    // This test fails because it finishes before receiving the call on the delegate
    func testSomeAsyncMethodIsNotVerifiedIfThereIsNoExpectation() {
        // Arrange
        let myClassDelegateMock = MyClassDelegateMock()
        sut.delegate = myClassDelegateMock
        
        // Act
        sut.someAsyncMethod()
        
        // Assert
        XCTAssertTrue(myClassDelegateMock.wasCalled)
    }
    
    // This tests fails after timing out because the expection is not fulfilled
    func testSomeAsyncMethodIsNotVerifiedIfExpectationIsNotFulfilled() {
        // Arrange
        let myClassDelegateMock = MyClassDelegateMock()
        sut.delegate = myClassDelegateMock
        let expectation = XCTestExpectation(description: "some async method")
        
        // Act
        sut.someAsyncMethod()
        
        // Assert
        wait(for: [expectation], timeout: 2)
        XCTAssertFalse(myClassDelegateMock.wasCalled)
    }
    
    // This test passes because it waits for an expectation to be fulfilled
    // and it is actually fulfilled in the mocked delegate call
    func testSomeAsyncMethod() {
        // Arrange
        let myClassDelegateMock = MyClassDelegateMock()
        sut.delegate = myClassDelegateMock
        let expectation = XCTestExpectation(description: "some async method")
        myClassDelegateMock.expectation = expectation
        
        // Act
        sut.someAsyncMethod()
        
        // Assert
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(myClassDelegateMock.wasCalled)
    }
    
    
}

// MARK: Mocks
class MyClassDelegateMock : MyClassDelegate {
    var wasCalled : Bool = false
    var expectation: XCTestExpectation? = nil
    func call(){
        // stubbed implementation
        wasCalled = true
        expectation?.fulfill()
    }
}



