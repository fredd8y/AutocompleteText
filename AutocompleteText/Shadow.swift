//
//  Shadow.swift
//  AutocompleteText
//
//  Created by Federico Arvat on 18/06/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit

// MARK: - Shadow

public enum Shadow {
	case none
	case bottomRight
	case bottomLeft
	case full
	case custom(ShadowConfiguration)
}

// MARK: - Methods

extension Shadow {
	
	/// This method return the configuration associated to the given Shadow case
	/// - Parameter view: The view on which the shadow has to be calculated
	func configuration(forView view: UIView) -> ShadowConfiguration {
		switch self {
		case .none:
			return ShadowConfiguration.none
		case .bottomRight:
			return bottomRightShadow(view)
		case .bottomLeft:
			return bottomLeftShadow(view)
		case .full:
			return fullShadow(view)
		case .custom(let shadowConfiguration):
			return shadowConfiguration
		}
	}
	
}

// MARK: - Methods (default configurations)

extension Shadow {
	
	/// This method return a shadow that goes from the bottom left corner
	/// of the view, to the bottom right corner and finally to the top right corner.
	/// Default shadowRadius: 5
	/// Default shadowColor: UIColor.gray
	/// Default shadowOpacity: 0.7
	/// Default shadowOffset: CGSize.zero
	/// - Parameter view: The view on which the shadow has to be calculated
	func bottomRightShadow(_ view: UIView) -> ShadowConfiguration {
		let path: UIBezierPath = UIBezierPath()
		path.move(
			to: CGPoint(
				x: view.bounds.origin.x,
				y: view.bounds.origin.y + view.bounds.height
			)
		)
		path.addLine(
			to: CGPoint(
				x: view.bounds.origin.x + view.bounds.width,
				y: view.bounds.origin.y + view.bounds.height
			)
		)
		path.addLine(
			to: CGPoint(
				x: view.bounds.origin.x + view.bounds.width,
				y: view.bounds.origin.y
			)
		)
		// This move is made to end the previous path without
		// closing it
		path.move(to: CGPoint.zero)
		
		return ShadowConfiguration(
			shadowColor: UIColor.gray.cgColor,
			shadowOffset: CGSize.zero,
			shadowPath: path.cgPath,
			shadowRadius: 5,
			shadowOpacity: 0.7
		)
	}
	
	/// This method return a shadow that goes from the top left corner
	/// of the view, to the bottom left corner and finally to the bottom right corner.
	/// Default shadowRadius: 5
	/// Default shadowColor: UIColor.gray
	/// Default shadowOpacity: 0.7
	/// Default shadowOffset: CGSize.zero
	/// - Parameter view: The view on which the shadow has to be calculated
	func bottomLeftShadow(_ view: UIView) -> ShadowConfiguration {
		let path: UIBezierPath = UIBezierPath()
		path.move(
			to: CGPoint(
				x: view.bounds.origin.x,
				y: view.bounds.origin.y
			)
		)
		path.addLine(
			to: CGPoint(
				x: view.bounds.origin.x,
				y: view.bounds.origin.y + view.bounds.height
			)
		)
		path.addLine(
			to: CGPoint(
				x: view.bounds.origin.x + view.bounds.width,
				y: view.bounds.origin.y + view.bounds.height
			)
		)
		// This move is made to end the previous path without
		// closing it
		path.move(to: CGPoint.zero)
		
		return ShadowConfiguration(
			shadowColor: UIColor.gray.cgColor,
			shadowOffset: CGSize.zero,
			shadowPath: path.cgPath,
			shadowRadius: 5,
			shadowOpacity: 0.7
		)
	}
	
	/// This method return a shadow that goes all around the view,
	/// except for the top
	/// Default shadowRadius: 5
	/// Default shadowColor: UIColor.gray
	/// Default shadowOpacity: 0.7
	/// Default shadowOffset: CGSize.zero
	/// - Parameter view: The view on which the shadow has to be calculated
	func fullShadow(_ view: UIView) -> ShadowConfiguration {
		let path: UIBezierPath = UIBezierPath()
		path.move(
			to: CGPoint(
				x: view.bounds.origin.x,
				y: view.bounds.origin.y
			)
		)
		path.addLine(
			to: CGPoint(
				x: view.bounds.origin.x,
				y: view.bounds.origin.y + view.bounds.height
			)
		)
		path.addLine(
			to: CGPoint(
				x: view.bounds.origin.x + view.bounds.width,
				y: view.bounds.origin.y + view.bounds.height
			)
		)
		path.addLine(
			to: CGPoint(
				x: view.bounds.origin.x + view.bounds.width,
				y: view.bounds.origin.y
			)
		)
		path.addLine(
			to: CGPoint(
				x: view.bounds.origin.x + (view.bounds.width / 2),
				y: view.bounds.origin.y + (view.bounds.height / 2)
			)
		)
		path.addLine(
			to: CGPoint(
				x: view.bounds.origin.x,
				y: view.bounds.origin.y
			)
		)
		
		return ShadowConfiguration(
			shadowColor: UIColor.gray.cgColor,
			shadowOffset: CGSize.zero,
			shadowPath: path.cgPath,
			shadowRadius: 5,
			shadowOpacity: 0.7
		)
	}
	
}
