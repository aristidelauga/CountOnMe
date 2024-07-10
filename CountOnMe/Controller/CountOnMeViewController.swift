//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class CountOnMeViewController: UIViewController {

	// MARK: - Variables
    @IBOutlet var textView: UITextView!
    @IBOutlet private var numberButtons: [UIButton]!
	let computationModel = ComputationModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.computationModel.delegate = self
	}

	// MARK: - IBActions method

	@IBAction func tappedACButton(_ sender: UIButton) {
		computationModel.cleanText()
	}

	@IBAction func tappedDeleteButton(_ sender: UIButton) {
		computationModel.tappedDeleteButton()
	}
	

    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
		computationModel.tappedNumberButton(numberText: numberText)
    }

	@IBAction func tappedDivisionButton(_ sender: UIButton) {
		computationModel.tappedDivisionButton()
	}

	@IBAction func tappedMultiplicationButton(_ sender: UIButton) {
		computationModel.tappedMultiplicationButton()
	}
	
    @IBAction private func tappedAdditionButton(_ sender: UIButton) {
		computationModel.tappedAdditionButton()

    }
    
    @IBAction private func tappedSubstractionButton(_ sender: UIButton) {
		computationModel.tappedSubstractionButton()
    }

    @IBAction private func tappedEqualButton(_ sender: UIButton) {
		computationModel.tappedEqualButton()
    }
}

extension CountOnMeViewController: ComputationModelDelegate {
	func didUpdateExpression(value: String) {
		self.textView.text = value
	}
	func didDetectError(_ error: AlertError) {
		let alertVC = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		self.present(alertVC, animated: true, completion: nil)
	}
}
