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
		
		autocompleteController = AutocompleteController(
			autocompleteTextField: autocompleteTextField,
			values: ["ciao", "come", "stai"],
			borderWidth: 1,
			borderColor: UIColor.black,
			backgroundColor: UIColor.cyan
		)
	}


}

