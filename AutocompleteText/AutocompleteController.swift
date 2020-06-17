//
//  AutocompleteController.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 12/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

// MARK: - Autocomplete controller delegate

public protocol AutocompleteControllerDelegate: class {
	func autocompleteTextField(_ autocompletable: Autocompletable, didTapIndex index: Int)
	func autocompleteTextFieldDismissed(_ autocompletable: Autocompletable)
}

// MARK: - Autocomplete controller

public class AutocompleteController {
	
//	MARK: - Properties
	
	/// Autocomplete controller delegate
	public weak var delegate: AutocompleteControllerDelegate?
	
	/// The textfield handled by the controller
	public var autocompleteTextField: Autocompletable
	
	/// A boolean value indicating whether the autocomplete is enabled or not
	public var autocompleteEnabled: Bool = true
	
	/// Minimum amount of character required to trigger the autocompletion
	public var minimumAmountOfCharacter: Int = 2
	
	/// Maximum amount of rows that can be displayed under the textfield
	public var maximumAmountOfDisplayableRows: Int = 5
	
	/// Maximum levenshtein distance, this distance is defined as the
	/// minimum amount of single changes (insert, delete, substitution)
	/// required to change one word into the other
	public var maximumLevenshteinDistance: Int = 0
	
	/// List of words that can be shown
	public var values: [String] = []
	
	/// Width of the list container border
	public var borderWidth: CGFloat = 1.0
	
	/// Border color of the list container
	public var borderColor: UIColor = UIColor.gray
	
	/// Background color of the hint rows
	public var backgroundColor: UIColor = UIColor.white
	
//	MARK: - Private properties
	
	/// The autocomplete view handled by this controller
	private var containerView: UIView = UIView()
	
	/// Rows currently displayed
	private var rowViews: [AutocompleteRowView] = []
	
//	MARK: - Public initializers
	
	/// Initializer
	/// - Parameters:
	///   - autocompleteTextField: Textfield handled by the controller
	public init(autocompleteTextField: Autocompletable) {
		self.autocompleteTextField = autocompleteTextField
		
		addObserversTo(autocompleteTextField)
	}
	
}

// MARK: - Private methods (lifecycle)

extension AutocompleteController {
	
	/// Called when the textfield gain focus
	private func autocompleteTextFieldDidBegin() {
		guard
			delegate != nil,
			autocompleteEnabled,
			let textValue = autocompleteTextField.text,
			textValue.count >= minimumAmountOfCharacter
		else { return }
		
		rowViews = getRowViews(fromValues: Array(values.prefix(maximumAmountOfDisplayableRows)))
		setContainerLayout(containerView, borderWidth: borderWidth, borderColor: borderColor)
		containerView.frame = getFrameBasedOnTextField(autocompleteTextField, andRowViews: rowViews)
		containerView.addSubview(createStackWithRowViews(rowViews, thatFit: containerView))
		autocompleteTextField.superview?.addSubview(containerView)
	}
	
	/// Called when the textfield change it's content
	private func autocompleteTextFieldDidChange() {
		guard
			delegate != nil,
			autocompleteEnabled,
			let textValue = autocompleteTextField.text,
			textValue.count >= minimumAmountOfCharacter
		else { return }
	}
	
	/// Called when the textfield lose focus
	private func autocompleteTextFieldDidEnd() {
		guard
			delegate != nil,
			autocompleteEnabled
		else { return }
		
		delegate?.autocompleteTextFieldDismissed(autocompleteTextField)
	}
	
}

// MARK: - Private methods (utilities)

extension AutocompleteController {
	
	/// Return an Array of AutocompleteRowView configured with the given values
	/// - Parameter values: List of String used to configure the views
	private func getRowViews(fromValues values: [String]) -> [AutocompleteRowView] {
		return values.enumerated().map({ index, element in
			let newRow = AutocompleteRowView()
			newRow.delegate = self
			newRow.index = index
			newRow.backgroundColor = backgroundColor
			newRow.text = element
			return newRow
		})
	}
	
	/// Configure the appearance of the container view, based on the given values
	/// - Parameters:
	///   - containerView: UIView that has to be configured
	///   - borderWidth: containerView border width
	///   - borderColor: containerView border color
	private func setContainerLayout(_ containerView: UIView, borderWidth: CGFloat, borderColor: UIColor) {
		containerView.layer.borderWidth = borderWidth
		containerView.layer.borderColor = borderColor.cgColor
	}
	
	/// Return a CGRect whose measure is calculated so that it is below the given textfield,
	/// and is high enough to fit all the given row views
	/// - Parameters:
	///   - textField: Textfield under which the CGRect has to be
	///   - rowViews: RowViews that has to be inside the CGRect
	private func getFrameBasedOnTextField(_ textField: UITextField, andRowViews rowViews: [AutocompleteRowView]) -> CGRect {
		return CGRect(
			x: textField.frame.origin.x,
			y: textField.frame.origin.y + autocompleteTextField.frame.height,
			width: textField.frame.width,
			height: rowViews.reduce(0) { sum, item in
				return sum + item.intrinsicContentSize.height
			}
		)
	}
	
	/// Create and return a UIStackView containing all the given rowViews,
	/// and set it's bounds equal to the given containerView
	/// - Parameters:
	///   - rowViews: All the row views that has to be added in the stackView
	///   - containerView: The containerView whose measure has to be used by the stackView
	private func createStackWithRowViews(_ rowViews: [AutocompleteRowView], thatFit containerView: UIView) -> UIStackView {
		let stackView: UIStackView = UIStackView()
		stackView.axis = .vertical
		rowViews.forEach({
			stackView.addArrangedSubview($0)
		})
		stackView.frame = containerView.bounds
		return stackView
	}
	
	
}

// MARK: - Private methods (observers)

extension AutocompleteController {
	
	/// Setup all the listeners to handle all the events emitted by the textField
	private func addObserversTo(_ textField: UITextField) {
		addBeginEditingObserverTo(textField, method: { self.autocompleteTextFieldDidBegin() })
		addDidChangeObserverTo(textField, method: { self.autocompleteTextFieldDidChange() })
		addEndEditingObserverTo(textField, method: { self.autocompleteTextFieldDidEnd() })
	}
	
	/// Bind the given method to the given textfield textDidChangeNotification event
	/// - Parameters:
	///   - textField: Textfield on which the method must be binded
	///   - method: Method to bind
	private func addDidChangeObserverTo(_ textField: UITextField, method: @escaping () -> Void) {
		NotificationCenter.default.addObserver(
			forName: UITextField.textDidChangeNotification,
			object: textField,
			queue: nil
		) { [weak self] notification in
			guard
				let self = self,
				let textField = notification.object as? UITextField,
				textField == self.autocompleteTextField
			else { return }
			
			method()
		}
	}
	
	/// Bind the given method to the given textfield textDidBeginEditingNotification event
	/// - Parameters:
	///   - textField: Textfield on which the method must be binded
	///   - method: Method to bind
	private func addBeginEditingObserverTo(_ textField: UITextField, method: @escaping () -> Void) {
		NotificationCenter.default.addObserver(
			forName: UITextField.textDidBeginEditingNotification,
			object: textField,
			queue: nil
		) { [weak self] notification in
			guard
				let self = self,
				let textField = notification.object as? UITextField,
				textField == self.autocompleteTextField
			else { return }
			
			method()
			self.autocompleteTextFieldDidBegin()
		}
	}
	
	/// Bind the given method to the given textfield textDidEndEditingNotification event
	/// - Parameters:
	///   - textField: Textfield on which the method must be binded
	///   - method: Method to bind
	private func addEndEditingObserverTo(_ textField: UITextField, method: @escaping () -> Void) {
		NotificationCenter.default.addObserver(
			forName: UITextField.textDidEndEditingNotification,
			object: textField,
			queue: nil
		) { [weak self] notification in
			guard
				let self = self,
				let textField = notification.object as? UITextField,
				textField == self.autocompleteTextField
			else { return }
			
			method()
			self.autocompleteTextFieldDidEnd()
		}
	}
	
}

// MARK: - Autocomplete row view delegate

extension AutocompleteController: AutocompleteRowViewDelegate {
	func autocompleteRowView(_ autocompleteRowView: AutocompleteRowView, didSelect index: Int) {
		
	}
}
