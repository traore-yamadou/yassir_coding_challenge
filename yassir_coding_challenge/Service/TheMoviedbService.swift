//
//  TheMoviedbService.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation

var apiKey: String {
  get {
    guard let filePath = Bundle.main.path(forResource: "TheMoviedb-info", ofType: "plist") else {
      fatalError("Couldn't find file 'TheMoviedb-info.plist'.")
    }

    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'TheMoviedb-info.plist'.")
    }
    return value
  }
}
