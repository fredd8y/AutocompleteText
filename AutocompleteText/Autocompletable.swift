//
//  Autocompletable.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 11/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

protocol Autocompletable {
	
	/// The view under which the autocompleteView should be shown
	var presentingView: UIView { get }
	
	/// Variable that contains all the strings to be shown
	var dataSource: [String] { get set }
	
	/// Height of a single row contained in the autocompleteView
	var rowHeight: CGFloat { get set }
	
	/// Border width of the container
	var borderWidth: CGFloat { get set }
	
	/// Border color given in UIColor
	var borderUIColor: UIColor { get set }
	
	/// Border color given in CGColor
	var borderCGColor: CGColor? { get set }
	
	/// Rows background color 
	var rowsBackgroundColor: UIColor { get set }
	
}
