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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		autocompleteTextField.autocompleteRowsBackgroundColor = UIColor.cyan
		autocompleteTextField.autocompleteViewBorderWidth = 1
		autocompleteTextField.autocompleteViewBorderColor = UIColor.black
		autocompleteTextField.values = ["ciao", "come", "stai"]
	}


}

