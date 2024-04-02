//
//  AllertController.swift
//  RealmApp
//
//  Created by Александр Соболев on 02.04.2024.
//

import UIKit

extension UIAlertController {
    static func createAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
}
