//
//  UIViewController+Alert.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 15/09/2022.
//

import UIKit

extension UIViewController {
    func showErrorAlert(title: String, message: String, completion: @escaping (() -> ())) {
        executeInMainThread {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: NSLocalizedString("DISMISS", comment: ""), style: .default)
            alertController.addAction(dismissAction)
            self.present(alertController, animated: true, completion: completion)
        }
    }
}
