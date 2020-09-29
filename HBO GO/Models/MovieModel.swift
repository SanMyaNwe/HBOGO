//
//  MovieModel.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

protocol MovieModelProtocol {
    
    func fetchTopRatedMovies(
        success: @escaping(MovieListResponse) -> Void,
        fail: @escaping(ApiServiceError) -> Void
    )
    
    func fetchNowPlayingMovies(
        success: @escaping(MovieListResponse) -> Void,
        fail: @escaping(ApiServiceError) -> Void
    )
    
    func fetchUpComingMovies(
        param: [String: String],
        success: @escaping(MovieListResponse) -> Void,
        fail: @escaping(ApiServiceError) -> Void
    )
    
    func searchMovies(
        params: [String: String],
        success: @escaping(MovieListResponse) -> Void,
        fail: @escaping(ApiServiceError) -> Void
    )
    
    func fetchMovieDetail(
        movieId: Int32,
        success: @escaping(MovieInfo) -> Void,
        fail: @escaping(ApiServiceError) -> Void
    )
    
    func fetchSimilarMovies(
        movieId: Int32,
        success: @escaping(MovieListResponse) -> Void,
        fail: @escaping(ApiServiceError) -> Void
    )
    
    func fetchTrailer(
        movieId: Int32,
        success: @escaping(TrailerResponse) -> Void,
        fail: @escaping(ApiServiceError) -> Void
    )
    
}

class MovieModel: MovieModelProtocol {
    
    static let shared = MovieModel()
    
    private init(){}
    
    func fetchTopRatedMovies(
        success: @escaping (MovieListResponse) -> Void,
        fail: @escaping (ApiServiceError) -> Void
    ) {
        ApiService.shared.fetchData(endpoint: .topRated, value: MovieListResponse.self) { (result) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func fetchNowPlayingMovies(
        success: @escaping (MovieListResponse) -> Void,
        fail: @escaping (ApiServiceError) -> Void
    ) {
        ApiService.shared.fetchData(endpoint: .nowPlaying, value: MovieListResponse.self) { (result) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func fetchUpComingMovies(
        param: [String: String],
        success: @escaping (MovieListResponse) -> Void,
        fail: @escaping (ApiServiceError) -> Void
    ) {
        ApiService.shared.fetchData(endpoint: .upComing, params: param, value: MovieListResponse.self) { (result) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func searchMovies(
        params: [String: String],
        success: @escaping (MovieListResponse) -> Void,
        fail: @escaping (ApiServiceError) -> Void
    ) {
        ApiService.shared.fetchData(endpoint: .searchMovie, params: params, value: MovieListResponse.self) { (result) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func fetchMovieDetail(
        movieId: Int32,
        success: @escaping (MovieInfo) -> Void,
        fail: @escaping (ApiServiceError) -> Void
    ) {
        ApiService.shared.fetchData(endpoint: .movieDetail(movieId: movieId), value: MovieInfo.self) { (result) in
            switch result {
            case .success(let movie):
                success(movie)
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func fetchSimilarMovies(
        movieId: Int32,
        success: @escaping (MovieListResponse) -> Void,
        fail: @escaping (ApiServiceError) -> Void
    ) {
        ApiService.shared.fetchData(endpoint: .similar(movieId: movieId), value: MovieListResponse.self) { (result) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    func fetchTrailer(
        movieId: Int32,
        success: @escaping (TrailerResponse) -> Void,
        fail: @escaping (ApiServiceError) -> Void
    ) {
        ApiService.shared.fetchData(endpoint: .trailer(movieId: movieId), value: TrailerResponse.self) { (result) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                fail(error)
            }
        }
    }
    
}

