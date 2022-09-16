//
//  UIViewController+MainThread.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 15/09/2022.
//

import UIKit

extension UIViewController {
    func executeInMainThread(_ completion: @escaping () -> Void) {
        guard !Thread.isMainThread else {
            completion()
            return
        }
        DispatchQueue.main.async {
            completion()
        }
    }
}
