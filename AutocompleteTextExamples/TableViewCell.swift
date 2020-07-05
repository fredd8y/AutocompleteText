//
//  TableViewCell.swift
//  AutocompleteTextExamples
//
//  Created by Federico Arvat on 02/07/2020.
//  Copyright © 2020 Federico Arvat. All rights reserved.
//

import UIKit
import AutocompleteText

class TableViewCell: UITableViewCell {

	@IBOutlet weak var autocompleteTextField: AutocompleteTextField!
	
	private var autocompleteController: AutocompleteController?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		autocompleteController = AutocompleteController(autocompleteTextField: autocompleteTextField)
		guard let _autocompleteController = self.autocompleteController else { return }
		_autocompleteController.delegate = self
		_autocompleteController.values = (0..<100).map({ _ in
			return Utils.randomString(range: 80..<100)
		}).sorted()
		_autocompleteController.font = UIFont.systemFont(ofSize: 25)
		_autocompleteController.isCaseSensitive = false
		_autocompleteController.maximumLevenshteinDistance = 1
		_autocompleteController.minimumAmountOfCharacter = 2
		_autocompleteController.shadow = Shadow.bottomRight
		_autocompleteController.cornerRadius = 8
		_autocompleteController.cornersToRound = [.bottomLeft, .bottomRight]
    }
    
}

extension TableViewCell: AutocompleteControllerDelegate {
	func autocompleteControllerDismissed(_ autocompleteController: AutocompleteController) {
		// TODO
	}
	
	func autocompleteController(_ autocompleteController: AutocompleteController, didTapIndex index: Int, textAtIndex text: String) {
		// TODO
	}
	
	func autocompleteController(_ autocompleteController: AutocompleteController, didFindMatch match: Bool) {
		// TODO
	}
}
