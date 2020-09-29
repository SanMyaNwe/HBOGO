//
//  EndPoint.swift
//  Movies
//
//  Created by Riki on 6/18/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

enum EndPoint {
    
    case nowPlaying
    case upComing
    case topRated
    case searchMovie
    case movieDetail(movieId: Int32)
    case similar(movieId: Int32)
    case trailer(movieId: Int32)
    
    
    var path: String {
        switch self {
        case .nowPlaying:
            return Api.BASE_URL + "/movie/now_playing"
        case .upComing:
            return Api.BASE_URL + "/movie/upcoming"
        case .topRated:
            return Api.BASE_URL + "/movie/top_rated"
        case .searchMovie:
            return Api.BASE_URL + "/search/movie"
        case .movieDetail(let movieId):
            return Api.BASE_URL + "/movie/\(movieId)"
        case .similar(let movieId):
            return Api.BASE_URL + "/movie/\(movieId)/similar"
        case .trailer(let movieId):
            return Api.BASE_URL + "/movie/\(movieId)/videos"
        }
    }
    
}
