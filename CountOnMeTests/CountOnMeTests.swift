//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class MockComputationModelDelegate: ComputationModelDelegate {
	var didDetectErrorCalled = false
	var error: AlertError?

	func didUpdateExpression(value: String) {
		// Implement if needed for other tests
	}

	func didDetectError(_ error: CountOnMe.AlertError) {
		didDetectErrorCalled = true
		self.error = error
	}
}

class CountOnMeTests: XCTestCase {

	private var sut: ComputationModel!
	private var mockDelegate: MockComputationModelDelegate!


	override func setUp() {
		super.setUp()
		sut = ComputationModel()
		mockDelegate = MockComputationModelDelegate()
		sut.delegate = mockDelegate

	}

	override func tearDown() {
		sut = nil
		mockDelegate = nil
		super.tearDown()
	}

	func testCleanText() {
		sut.expression = "5+4*5/10"
		let emptyExpression = ""

		sut.cleanText()
		XCTAssertEqual(sut.expression, emptyExpression)
	}

	func testCleanTextWhenExpressionHasResult() {
		sut.expression = "5 + 4 = 9"
		sut.tappedNumberButton(numberText: "5")

		XCTAssertFalse(sut.expressionHaveResult)
		XCTAssertEqual(sut.expression, "5")
	}

	func testTappedDeleteButton() {
		sut.expression = "5+4*5/10"
		let partiallyDeletedExpression = "5+4*5/1"

		sut.tappedDeleteButton()
		XCTAssertEqual(sut.expression, partiallyDeletedExpression)
	}

	func testTappedNumberButton() {
		sut.tappedNumberButton(numberText: "7")

		XCTAssertEqual(sut.expression, "7")
	}

	func testTappedDivisionButton() {
		sut.expression = "5+4"
		sut.tappedDivisionButton()
		XCTAssertEqual(sut.expression, "5+4 / ")
	}

	func testFailTappedDivisionButton() {
		sut.expression = "5+4/"
		sut.tappedDivisionButton()
		XCTAssertFalse(sut.canAddOperator)
		XCTAssertNotEqual(sut.expression, "5+4/ /")
	}

	func testTappedMultiplicationButton() {
		sut.expression = "5+4"
		sut.tappedMultiplicationButton()
		XCTAssertEqual(sut.expression, "5+4 * ")
	}

	func testFailTappedMultiplicationButton() {
		sut.expression = "5+4*"
		sut.tappedMultiplicationButton()
		XCTAssertFalse(sut.canAddOperator)
		XCTAssertNotEqual(sut.expression, "5+4* *")
	}

	func testTappedAdditionButton() {
		sut.expression = "5+4"
		sut.tappedAdditionButton()
		XCTAssertEqual(sut.expression, "5+4 + ")
	}

	func testFailTappedAdditionButton() {
		sut.expression = "5+4+"
		sut.tappedAdditionButton()
		XCTAssertFalse(sut.canAddOperator)
		XCTAssertNotEqual(sut.expression, "5+4+ +")
	}

	func testTappedSubstractionButton() {
		sut.expression = "5+4"
		sut.tappedSubstractionButton()
		XCTAssertEqual(sut.expression, "5+4 - ")
	}

	func testFailTappedSubstractionButton() {
		sut.expression = "5+4-"
		sut.tappedSubstractionButton()
		XCTAssertFalse(sut.canAddOperator)
		XCTAssertNotEqual(sut.expression, "5+4- -")
	}

	func testDidDetectErrorDivisionOperatorAlreadyPresent() {
		sut.expression = "5 + 4 /"

		sut.tappedDivisionButton()

		XCTAssertTrue(mockDelegate.didDetectErrorCalled)
		XCTAssertEqual(mockDelegate.error, .operatorAlreadyPresent)
	}

	func testDidDetectErrorMultiplicationOperatorAlreadyPresent() {
		sut.expression = "5 + 4 *"

		sut.tappedMultiplicationButton()

		XCTAssertTrue(mockDelegate.didDetectErrorCalled)
		XCTAssertEqual(mockDelegate.error, .operatorAlreadyPresent)
	}

	func testDidDetectErrorAdditionOperatorAlreadyPresent() {
		sut.expression = "5 + 4 +"

		sut.tappedAdditionButton()

		XCTAssertTrue(mockDelegate.didDetectErrorCalled)
		XCTAssertEqual(mockDelegate.error, .operatorAlreadyPresent)
	}

	func testDidDetectErrorSubstractionOperatorAlreadyPresent() {
		sut.expression = "5 + 4 -"

		sut.tappedSubstractionButton()

		XCTAssertTrue(mockDelegate.didDetectErrorCalled)
		XCTAssertEqual(mockDelegate.error, .operatorAlreadyPresent)
	}

	func testTappedEqualButton() {
		sut.expression = "5 + 4 * 5 / 10 - 2"
		sut.tappedEqualButton()
		XCTAssertEqual(sut.expression, "5 + 4 * 5 / 10 - 2 = 5")
	}

	func testTappedEqualButtonWithIncorrectExpression() {
		sut.expression = "5 + 4 * 5 / 10 - 2 +"

		sut.tappedEqualButton()

		XCTAssertTrue(mockDelegate.didDetectErrorCalled)
		XCTAssertEqual(mockDelegate.error, .enterCorrectExpression)
	}

	func testTappedEqualButtonWithNotEnoughElements() {
		sut.expression = "5*"

		sut.tappedEqualButton()

		XCTAssertTrue(mockDelegate.didDetectErrorCalled)
		XCTAssertEqual(mockDelegate.error, .startNewComputation)
	}

	func testTappedEqualButtonWithExpressionResult() {
		sut.expression = "5 + 4 = 20"

		sut.tappedEqualButton()

		XCTAssertTrue(mockDelegate.didDetectErrorCalled)
		XCTAssertEqual(mockDelegate.error, .startNewComputation)
	}

	

	func testTappedEqualButtonWithDivisionByZero() {
		sut.expression = "5 + 4 * 5 / 0 - 2"
		sut.tappedEqualButton()
		XCTAssertEqual(sut.expression, "")
	}

}
