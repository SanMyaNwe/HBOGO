//
//  MovieListResponse.swift
//  HBO GO
//
//  Created by Riki on 7/18/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

struct MovieListResponse: Codable {
    var results: [MovieInfo]?
    var page: Int?
    var totalPages: Int?
}
