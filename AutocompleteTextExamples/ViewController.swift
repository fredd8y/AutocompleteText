//
//  ViewController.swift
//  AutocompleteTextExamples
//
//  Created by Federico Arvat on 11/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit
import AutocompleteText

class ViewController: UIViewController {
	
	@IBOutlet weak var autocompleteTextField: AutocompleteTextField!
	
	private var autocompleteController: AutocompleteController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		autocompleteController = AutocompleteController(autocompleteTextField: autocompleteTextField)
		guard let _autocompleteController = self.autocompleteController else { return }
		_autocompleteController.delegate = self
		_autocompleteController.values = (0..<100).map({ _ in
			return Utils.randomString(range: 4..<10)
		})
		_autocompleteController.isCaseSensitive = false
		_autocompleteController.maximumLevenshteinDistance = 1
		_autocompleteController.minimumAmountOfCharacter = 2
		_autocompleteController.shadow = Shadow.bottomRight
		_autocompleteController.cornerRadius = 4
		_autocompleteController.cornersToRound = [.allCorners]
	}

}

extension ViewController: AutocompleteControllerDelegate {
	func autocompleteTextField(_ autocompletable: Autocompletable, didTapIndex index: Int) {
		// TODO
	}
	
	func autocompleteTextFieldDismissed(_ autocompletable: Autocompletable) {
		// TODO
	}
}
