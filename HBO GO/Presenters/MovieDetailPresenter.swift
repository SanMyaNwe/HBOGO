//
//  MovieDetailPresenter.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

protocol MovieDetailPresenterProtocol {
    var mView: MovieDetailView? { get set }
    func fetchDetail(for movieId: Int32)
    func fetchTrailer(for movieId: Int32)
    func saveBookmark(movie: MovieInfo)
    func removeBookmark(movieId: Int32)
    func checkIsBookmarked(movieId: Int32) -> Bool
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    var mView: MovieDetailView?
    
    func fetchDetail(for movieId: Int32) {
        self.mView?.startLoading()
        MovieModel.shared.fetchMovieDetail(movieId: movieId, success: { (movie) in
            MovieModel.shared.fetchSimilarMovies(movieId: movieId, success: { (response) in
                self.mView?.gotSimilarMovies(movies: response.results ?? [])
                self.mView?.gotData(movie: movie)
                self.mView?.stopLoading()
            }) { (error) in
                self.mView?.gotError(error: error.description)
                self.mView?.stopLoading()
            }
        }) { (error) in
            self.mView?.gotError(error: error.description)
            self.mView?.stopLoading()
        }
    }
    
    func fetchTrailer(for movieId: Int32) {
        MovieModel.shared.fetchTrailer(movieId: movieId, success: { (response) in
            let trailers = response.results
            if let trailers = trailers, trailers.count>0 {
                switch trailers.count{
                case 1:
                    self.mView?.gotTrailer(key: trailers[0].key ?? "")
                    break
                case 2:
                    self.mView?.gotTrailer(key: trailers[1].key ?? "")
                    break
                case 3:
                    self.mView?.gotTrailer(key: trailers[2].key ?? "")
                    break
                default:
                    self.mView?.gotTrailer(key: trailers[3].key ?? "")
                    break
                }
            }
        }) { (error) in
            self.mView?.gotError(error: error.description)
        }
    }
    
    func updateBookmark(movieId: Int32) {
        MoviePersistenceService.shared.updateBookmark(movieId: movieId)
    }
    
    func saveBookmark(movie: MovieInfo) {
        MoviePersistenceService.shared.saveBookmark(movie: movie)
    }
    
    func removeBookmark(movieId: Int32) {
        MoviePersistenceService.shared.removeBookmark(movieId: movieId)
    }
    
    func checkIsBookmarked(movieId: Int32) -> Bool {
        return MoviePersistenceService.shared.checkIsBookmarked(movieId: movieId)
    }
}
