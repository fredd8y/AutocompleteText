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
		_autocompleteController.values = ["ciao", "come", "stai"]
		_autocompleteController.minimumAmountOfCharacter = 0
		_autocompleteController.borderWidth = 1
		_autocompleteController.borderColor = UIColor.black
		_autocompleteController.backgroundColor = UIColor.red
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
