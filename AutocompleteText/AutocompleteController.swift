//
//  AutocompleteController.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 12/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

public class AutocompleteController {
	
//	MARK: - Private properties
	
	/// The textfield handled by the controller
	var autocompleteTextField: Autocompletable
	
	/// The autocomplete view handled by this controller
	var containerView: UIView = UIView()
	
	/// Rows currently displayed
	var rowViews: [AutocompleteRowView] = []
	
	/// List of words that the textfield can show
	var values: [String]
	
	/// Width of the textfield autocomplete list container border
	var borderWidth: CGFloat
	
	/// Border color of the autocomplete list container
	var borderColor: UIColor
	
	/// Background color of the hint rows
	var backgroundColor: UIColor
	
//	MARK: - Methods
	
	/// Called when the textfield gain focus
	func autocompleteTextFieldDidBegin() {
		rowViews = values.enumerated().map({ index, element in
			let newRow = AutocompleteRowView()
			newRow.index = index
			newRow.backgroundColor = backgroundColor
			newRow.text = element
			return newRow
		})
		containerView.layer.borderWidth = borderWidth
		containerView.layer.borderColor = borderColor.cgColor
		containerView.frame = CGRect(
			x: autocompleteTextField.frame.origin.x,
			y: autocompleteTextField.frame.origin.y + autocompleteTextField.frame.height,
			width: autocompleteTextField.frame.width,
			height: rowViews.reduce(0) { sum, item in
				return sum + item.intrinsicContentSize.height
			}
		)
		let stackView: UIStackView = UIStackView()
		stackView.axis = .vertical
		rowViews.forEach({
			stackView.addArrangedSubview($0)
		})
		stackView.frame = containerView.bounds
		containerView.addSubview(stackView)
		autocompleteTextField.superview?.addSubview(containerView)
	}
	
	/// Called when the textfield lose focus
	func autocompleteTextFieldDidEnd() {
		
	}
	
	/// Called when the textfield change it's content
	func autocompleteTextFieldDidChange() {
		
	}
	
	/// Setup all the listeners to handle all the events emitted by the textField
	func setupListeners() {
		
		NotificationCenter.default.addObserver(
			forName: UITextField.textDidChangeNotification,
			object: autocompleteTextField,
			queue: nil
		) { [weak self] notification in
			guard
				let self = self,
				let textField = notification.object as? UITextField,
				textField == self.autocompleteTextField
			else { return }
			
			self.autocompleteTextFieldDidChange()
		}
		
		NotificationCenter.default.addObserver(
			forName: UITextField.textDidBeginEditingNotification,
			object: autocompleteTextField,
			queue: nil
		) { [weak self] notification in
			guard
				let self = self,
				let textField = notification.object as? UITextField,
				textField == self.autocompleteTextField
			else { return }
			
			self.autocompleteTextFieldDidBegin()
		}
		
		NotificationCenter.default.addObserver(
			forName: UITextField.textDidEndEditingNotification,
			object: autocompleteTextField,
			queue: nil
		) { [weak self] notification in
			guard
				let self = self,
				let textField = notification.object as? UITextField,
				textField == self.autocompleteTextField
			else { return }
			
			self.autocompleteTextFieldDidEnd()
		}
	}
	
//	MARK: - Initializers
	
	/// Initializer
	/// - Parameters:
	///   - autocompleteTextField: Textfield handled by the controller
	///   - values: DataSource of all possible values
	///   - borderWidth: Border width of the whole autocomplete view
	///   - borderColor: Border color of the whole autocomplete view
	///   - backgroundColor: Background color of a single rows
	public init(
		autocompleteTextField: Autocompletable,
		values: [String],
		borderWidth: CGFloat,
		borderColor: UIColor,
		backgroundColor: UIColor
	) {
		self.autocompleteTextField = autocompleteTextField
		self.values = values
		self.borderWidth = borderWidth
		self.borderColor = borderColor
		self.backgroundColor = backgroundColor
		
		setupListeners()
	}
	
}

