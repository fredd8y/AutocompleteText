//
//  AutocompleteTextField.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 11/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

public protocol AutocompleteTextFieldDelegate: class {
	
}

public class AutocompleteTextField: UITextField, Autocompletable {
		
	public var autocompleteDelegate: AutocompleteTextFieldDelegate?
		
}
