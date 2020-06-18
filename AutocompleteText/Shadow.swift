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
//	case bottomLeft
//	case full
//	case custom(ShadowConfiguration)
}

// MARK: - Methods

extension Shadow {
	
	func configuration(forView view: UIView) -> ShadowConfiguration {
		switch self {
		case .none:
			return ShadowConfiguration.none
		case .bottomRight:
			return bottomRightShadow(view)
//		case .bottomLeft:
//			break
//		case .full:
//			break
//		case .custom(let shadowConfiguration):
//			break
		}
	}
	
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
	
}
