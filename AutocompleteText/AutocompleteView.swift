//
//  AutocompleteView.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 11/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

class AutocompleteView: UIView, Autocompletable {
	
	//	MARK: - Public properties
	
	var presentingView: UIView
		
	var rowHeight: CGFloat = 30
	
	var dataSource: [String] = [] {
		didSet {
			reloadData()
		}
	}
	
	var borderWidth: CGFloat = 0.0 {
		didSet {
			containerView.layer.borderWidth = borderWidth
		}
	}
	
	var borderUIColor: UIColor = UIColor.gray {
		didSet {
			containerView.layer.borderColor = borderUIColor.cgColor
		}
	}
	
	var borderCGColor: CGColor? {
		didSet {
			containerView.layer.borderColor = borderCGColor
		}
	}
	
	var rowsBackgroundColor: UIColor = UIColor.white
	
//	MARK: - Private properties
	
	/// Container that surround all the AutocompleteRowView
	private let containerView: UIView = UIView()
	
	/// Row view list, to mantain a reference to all the view currently shown
	private var rowViews: [AutocompleteRowView] = []
	
	init(presentingView: UIView) {
		self.presentingView = presentingView
		super.init(frame: CGRect.zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

//MARK: - Private methods

extension AutocompleteView {
	
	/// Perform a reload of the rows currently shown
	private func reloadData() {
		rowViews.forEach({ $0.removeFromSuperview() })
		rowViews.removeAll()
		containerView.frame = createContainerViewFrame(
			withDataSource: dataSource,
			singleRowHeightOf: rowHeight,
			placedUnder: presentingView
		)
		addRows(dataSource, toContainer: containerView, rowHeight: rowHeight)
		addSubview(containerView)
	}
	
}

//MARK: - Private utility methods
extension AutocompleteView {
	
	/// Create a new frame based on the given values
	/// - Parameters:
	///   - dataSource: List of element to be shown into the autocompleteView
	///   - height: Height of a single row
	///   - view: View under which this frame should be shown
	private func createContainerViewFrame(
		withDataSource dataSource: [String],
		singleRowHeightOf height: CGFloat,
		placedUnder view: UIView
	) -> CGRect {
		return CGRect(
			x: view.frame.origin.x,
			y: view.frame.origin.y + view.frame.height,
			width: view.frame.width,
			height: height * CGFloat(dataSource.count)
		)
	}
	
	/// Adds one rows for every element in the given dataSource
	/// - Parameters:
	///   - dataSource: List of element to be shown into the autocompleteView
	///   - containerView: View in which the views has to be added
	private func addRows(_ dataSource: [String], toContainer containerView: UIView, rowHeight: CGFloat) {
		let stackView: UIStackView = UIStackView()
		stackView.axis = .vertical
		dataSource.enumerated().forEach({ index, item in
			let newRow: AutocompleteRowView = AutocompleteRowView(frame: CGRect.zero)
//			let newRow: AutocompleteRowView = AutocompleteRowView(
//				frame: CGRect(
//					x: containerView.bounds.origin.x,
//					y: containerView.bounds.origin.y + (rowHeight * CGFloat(index)),
//					width: containerView.bounds.width,
//					height: rowHeight
//				)
//			)
			
			newRow.index = index
			newRow.text = item
			
			newRow.backgroundColor = rowsBackgroundColor
			
			stackView.addArrangedSubview(newRow)
		})
		
		containerView.addSubview(stackView)
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
			stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
		])
		
	}
	
}
