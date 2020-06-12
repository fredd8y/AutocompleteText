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

public class AutocompleteTextField: UITextField {
	
//	MARK: - Public properties
	
	/// Autocomplete delegate
	public weak var autocompleteDelegate: AutocompleteTextFieldDelegate?
	
	/// List of words that the textfield can show
	public var values: [String] = []
	
	/// Height of a single row in the autocomplete list
	public var autocompleteViewRowHeight: CGFloat {
		set {
			autocompleteView.rowHeight = newValue
		}
		get {
			return autocompleteView.rowHeight
		}
	}
	
	/// Width of the autocomplete list container border
	public var autocompleteViewBorderWidth: CGFloat {
		set {
			autocompleteView.borderWidth = newValue
		}
		get {
			return autocompleteView.borderWidth
		}
	}
	
	/// Border color of the autocomplete list container
	public var autocompleteViewBorderColor: UIColor {
		set {
			autocompleteView.borderUIColor = newValue
		}
		get {
			return autocompleteView.borderUIColor
		}
	}
	
	/// Background color of the hint rows
	public var autocompleteRowsBackgroundColor: UIColor {
		set {
			autocompleteView.rowsBackgroundColor = newValue
		}
		get {
			return autocompleteView.rowsBackgroundColor
		}
	}
	
//	MARK: - Public initializers
	
	public init() {
		super.init(frame: CGRect.zero)
		
		commonInit()
	}
		
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		commonInit()
	}
	
//	MARK: - Private properties
	
	/// The autocompleteView for this textfield
	private lazy var autocompleteView: AutocompleteView = AutocompleteView(presentingView: self)
	
}

//MARK: - Private methods

extension AutocompleteTextField {
	
	/// Setup method
	private func commonInit() {
		
		// Here we add all the selectors to handle the events
		addTarget(self, action: #selector(AutocompleteTextField.editingChanged), for: .editingChanged)
		addTarget(self, action: #selector(AutocompleteTextField.editingDidEnd), for: .editingDidEnd)
		addTarget(self, action: #selector(AutocompleteTextField.editingDidBegin), for: .editingDidBegin)
	}
	
	/// Called everytime the textfield change it's value
	@objc private func editingChanged() {
		print("editing ended")
	}
	
	/// Called when the textField lose it's focus
	@objc private func editingDidEnd() {
		autocompleteView.removeFromSuperview()
	}
	
	/// Called when the textField gain it's focus
	@objc private func editingDidBegin() {
		superview?.addSubview(autocompleteView)
		autocompleteView.dataSource = values
	}
}
