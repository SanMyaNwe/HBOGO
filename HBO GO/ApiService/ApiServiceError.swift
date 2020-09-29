//
//  ApiServiceError.swift
//  Movies
//
//  Created by Riki on 6/18/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

enum ApiServiceError: Error {
    
    case noConnection
    case clientError
    case serverDown
    case decodingFail
    case unknown
    
    var description: String {
        switch self {
        case .noConnection:
            return "NoConnection..."
        case .clientError:
            return "ClientError..."
        case .serverDown:
            return "ServerDown..."
        case .decodingFail:
            return "DecodingFail..."
        default:
            return "Unknown..."
        }
    }
    
}
