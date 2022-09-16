//
//  StoryboardInitializable.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import UIKit

/// This protocol makes it easier to create view controllers from a storyboard
protocol StoryboardInitializable {
    static func instantiate() -> Self
}

extension StoryboardInitializable where Self: UIViewController {
    static func instantiate() -> Self {
        /// this pulls out "Yassir.MoviesViewController" for example
        let fullName = NSStringFromClass(self)

        /// this splits by the dot and uses everything after, giving "MoviesViewController"
        let className = fullName.components(separatedBy: ".")[1]

        /// load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        /// instantiate a view controller with that identifier, and force cast as the type that was requested

        guard let instantiatedController = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
            fatalError("Failed to instantiate view controller with identifier :\(className)")
        }
        return instantiatedController
    }
}
