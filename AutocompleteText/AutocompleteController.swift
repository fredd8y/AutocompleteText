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
	public var values: [String] = [] {
		didSet { values.sort() }
	}
	
	/// Flag that indicates if the match has to be case sensitive or not
	public var isCaseSensitive: Bool = true
	
	/// Corner radius of the container view
	public var cornerRadius: CGFloat = 0 {
		didSet {
			containerView.layer.cornerRadius = cornerRadius
			containerView.layer.masksToBounds = true
		}
	}
	
	/// Shadow configuration of the container view
	public var shadow: Shadow = .none
	
	/// Width of the list container border
	public var borderWidth: CGFloat = 1.0
	
	/// Border color of the list container
	public var borderColor: UIColor = UIColor.gray
	
	/// Width of the rows separator
	public var rowSeparatorHeight: CGFloat = 1.0
	
	/// Color of the rows separator
	public var rowSeparatorColor: UIColor = UIColor.gray
	
	/// Background color of the hint rows
	public var backgroundColor: UIColor = UIColor.white
	
//	MARK: - Private properties
	
	/// The autocomplete view handled by this controller
	private var containerView: UIView = UIView()
	
	/// The view that hold the shadow
	private var shadowView: UIView = UIView()
	
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
		
		let filteredValues = filterValues(
			values,
			input: textValue,
			caseSensitive: isCaseSensitive,
			levenshteinDistance: maximumLevenshteinDistance
		)
		
		let rowViews = getRowViews(fromValues: Array(filteredValues.prefix(maximumAmountOfDisplayableRows)))
		
		resizeContainer(
			containerView,
			under: autocompleteTextField,
			withBorderWidth: borderWidth,
			andBorderColor: borderColor,
			toFitRows: rowViews,
			separatorHeight: rowSeparatorHeight,
			separatorColor: rowSeparatorColor,
			shadow: shadow,
			shadowView: shadowView
		)
	}
	
	/// Called when the textfield change it's content
	private func autocompleteTextFieldDidChange() {
		guard
			delegate != nil,
			autocompleteEnabled,
			let textValue = autocompleteTextField.text,
			textValue.count >= minimumAmountOfCharacter
		else { return }
		
		rowViews.forEach({ $0.removeFromSuperview() })
		containerView.subviews.forEach({ $0.removeFromSuperview() })
		containerView.removeFromSuperview()
		
		let filteredValues = filterValues(
			values,
			input: textValue,
			caseSensitive: isCaseSensitive,
			levenshteinDistance: maximumLevenshteinDistance
		)
		
		let rowViews = getRowViews(fromValues: Array(filteredValues.prefix(maximumAmountOfDisplayableRows)))
		
		resizeContainer(
			containerView,
			under: autocompleteTextField,
			withBorderWidth: borderWidth,
			andBorderColor: borderColor,
			toFitRows: rowViews,
			separatorHeight: rowSeparatorHeight,
			separatorColor: rowSeparatorColor,
			shadow: shadow,
			shadowView: shadowView
		)
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
	
	private func setShadowTo(
		_ shadowView: UIView,
		containerView: UIView,
		shadow: Shadow,
		autocompleteTextField: UITextField
	) {
		shadowView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
		let configuration: ShadowConfiguration = shadow.configuration(forView: containerView)
		shadowView.frame = containerView.frame
		shadowView.layer.shadowOpacity = configuration.shadowOpacity
		shadowView.layer.shadowColor = configuration.shadowColor
		shadowView.layer.shadowOffset = configuration.shadowOffset
		shadowView.layer.shadowPath = configuration.shadowPath
		shadowView.layer.shadowRadius = configuration.shadowRadius
		shadowView.layer.shouldRasterize = true
		containerView.removeFromSuperview()
		shadowView.addSubview(containerView)
		autocompleteTextField.superview?.addSubview(shadowView)
	}
	
	/// This function filter the given list based on the given input,
	/// it return a list of element that contains the given text as a prefix.
	/// The levenshtein distance is a parameter that indicates the tolerance
	/// that this filter has.
	/// Examples:
	/// -	levenshtein distance = 0, "word" != "lord"
	/// -	levenshtein distance = 1, "word" = "lord"
	///
	/// - Parameters:
	///   - values: Values to be filtered
	///   - input: Text used for the filter
	///   - caseSensitive: Flag that indicate if the filter has to be case sensitive or insensitive
	///   - levenshteinDistance: Maximum levenshtein distance
	private func filterValues(
		_ values: [String],
		input: String,
		caseSensitive: Bool,
		levenshteinDistance: Int
	) -> [String] {
		return values.filter({ currentItem in
			var _currentItem = currentItem
			var _input = input
			if !caseSensitive {
				_currentItem = _currentItem.lowercased()
				_input = _input.lowercased()
			}
			return String(_currentItem.prefix(_input.count)).levenshtein(_input) <= levenshteinDistance
		})
	}
	
	/// Method that resize the given container according to the given data
	/// - Parameters:
	///   - containerView: The container to be resized
	///   - textField: The textfield under which the container must be placed
	///   - borderWidth: Container border width
	///   - borderColor: Container border color
	///   - rowViews: The row views that must be placed inside the container
	private func resizeContainer(
		_ containerView: UIView,
		under textField: UITextField,
		withBorderWidth borderWidth: CGFloat,
		andBorderColor borderColor: UIColor,
		toFitRows rowViews: [AutocompleteRowView],
		separatorHeight: CGFloat,
		separatorColor: UIColor,
		shadow: Shadow,
		shadowView: UIView
	) {
		setContainerLayout(containerView, borderWidth: borderWidth, borderColor: borderColor)
		containerView.frame = getFrameBasedOnTextField(
			textField,
			andRowViews: rowViews,
			separatorHeight: separatorHeight
		)
		containerView.addSubview(
			createStackWithRowViews(
				rowViews,
				thatFit: containerView,
				separatorHeight: separatorHeight,
				separatorColor: separatorColor
			)
		)
		setShadowTo(shadowView, containerView: containerView, shadow: shadow, autocompleteTextField: autocompleteTextField)
		autocompleteTextField.superview?.addSubview(containerView)
	}
	
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
	private func setContainerLayout(
		_ containerView: UIView,
		borderWidth: CGFloat,
		borderColor: UIColor
	) {
		containerView.layer.borderWidth = borderWidth
		containerView.layer.borderColor = borderColor.cgColor
	}
	
	/// Return a CGRect whose measure is calculated so that it is below the given textfield,
	/// and is high enough to fit all the given row views
	/// - Parameters:
	///   - textField: Textfield under which the CGRect has to be
	///   - rowViews: RowViews that has to be inside the CGRect
	private func getFrameBasedOnTextField(
		_ textField: UITextField,
		andRowViews rowViews: [AutocompleteRowView],
		separatorHeight: CGFloat
	) -> CGRect {
		return CGRect(
			x: textField.frame.origin.x,
			y: textField.frame.origin.y + autocompleteTextField.frame.height,
			width: textField.frame.width,
			height: rowViews.reduce(0) { sum, item in
				return sum + item.intrinsicContentSize.height
			} + ((CGFloat(rowViews.count) * separatorHeight) - 1)
		)
	}
	
	/// Create and return a UIStackView containing all the given rowViews,
	/// and set it's bounds equal to the given containerView
	/// - Parameters:
	///   - rowViews: All the row views that has to be added in the stackView
	///   - containerView: The containerView whose measure has to be used by the stackView
	private func createStackWithRowViews(
		_ rowViews: [AutocompleteRowView],
		thatFit containerView: UIView,
		separatorHeight: CGFloat,
		separatorColor: UIColor
	) -> UIStackView {
		let stackView: UIStackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		rowViews.enumerated().forEach({ index, item in
			if index > 0 {
				let separator: SeparatorView = SeparatorView(
					frame: CGRect(
						x: item.frame.origin.x,
						y: item.frame.origin.y,
						width: containerView.bounds.width,
						height: separatorHeight
					)
				)
				separator.backgroundColor = separatorColor
				stackView.addArrangedSubview(separator)
			}
			stackView.addArrangedSubview(item)
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
	private func addDidChangeObserverTo(
		_ textField: UITextField,
		method: @escaping () -> Void
	) {
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
	private func addBeginEditingObserverTo(
		_ textField: UITextField,
		method: @escaping () -> Void
	) {
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
		}
	}
	
	/// Bind the given method to the given textfield textDidEndEditingNotification event
	/// - Parameters:
	///   - textField: Textfield on which the method must be binded
	///   - method: Method to bind
	private func addEndEditingObserverTo(
		_ textField: UITextField,
		method: @escaping () -> Void
	) {
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
		}
	}
	
}

// MARK: - Autocomplete row view delegate

extension AutocompleteController: AutocompleteRowViewDelegate {
	func autocompleteRowView(
		_ autocompleteRowView: AutocompleteRowView,
		didSelect index: Int
	) {
		
	}
}
