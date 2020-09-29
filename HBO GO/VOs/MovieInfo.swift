//
//  MovieInfo.swift
//  HBO GO
//
//  Created by Riki on 8/3/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

struct MovieInfo: Codable {
    var genres: [Genre]?
    var backdropPath: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var id: Int?
    var releaseDate: String?
    var runtime: Int?
    var status: String?
    var tagline: String?
    var voteAverage: Double?
    var voteCount: Int?
    
}

enum MovieType: String {
    case TopRated
    case NowPlaying
    case UpComing
}
