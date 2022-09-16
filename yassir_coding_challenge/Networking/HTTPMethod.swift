//
//  HTTPMethod.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation


enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum HTTPScheme: String {
    case http
    case https
}
