//
//  String.swift
//  AvitoInternship
//
//  Created by Владимир on 12.09.2024.
//

import Foundation
import UIKit

extension String {
    static func createLabelPost(user: String, text: String) -> NSMutableAttributedString {
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20)
        ]
        let boldString = NSAttributedString(string: user + ":   ", attributes: boldAttributes)
        let regularString = NSAttributedString(string: text, attributes: regularAttributes)
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(boldString)
        combinedString.append(regularString)
        return combinedString
    }
}
