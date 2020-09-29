//
//  HomePresenter.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol {
    var mView: HomeView? { get set }
    func fetchApiMovies()
}

class HomePresenter: HomePresenterProtocol {
    
    var mView: HomeView?
    var movieService = MoviePersistenceService.shared
    
    var page = 1
    var totalPages = 0
    var param: [String: String] = [:]
    
    private var topRatedMovies = [MovieInfo]()
    private var nowPlayingMovies = [MovieInfo]()
    private var upComingMovies = [MovieInfo]()
    
//    init() { MoviePersistenceService.shared.listenOn(self) }
    
    func fetchApiMovies() {
        param = ["page": "\(page)"]
        self.mView?.startLoading()
        MovieModel.shared.fetchTopRatedMovies(success: { (topRatedResponse) in
            MovieModel.shared.fetchNowPlayingMovies(success: { (nowPlayingResponse) in
                MovieModel.shared.fetchUpComingMovies(param: self.param,success: { (upComingResponse) in
                    
                    self.topRatedMovies = topRatedResponse.results ?? []
//                    self.movieService.save(movies: topRatedMovies, type: .TopRated)
                    
                    self.nowPlayingMovies = nowPlayingResponse.results ?? []
//                    self.movieService.save(movies: nowPlayingMovies, type: .NowPlaying)
                    
                    self.upComingMovies = upComingResponse.results ?? []
//                    self.movieService.save(movies: upComingMovies, type: .UpComing)
                    
                    
                    
                    self.totalPages = upComingResponse.totalPages ?? 0
                    self.mView?.gotMovies(topRated: self.topRatedMovies, nowPlaying: self.nowPlayingMovies, upComing: self.upComingMovies)
            
                    self.mView?.stopLoading()
                }) { (error) in
                    self.mView?.gotError(error: error.description)
                    self.mView?.stopLoading()
                }
            }) { (error) in
                self.mView?.gotError(error: error.description)
                self.mView?.stopLoading()
            }
        }) { (error) in
            self.mView?.gotError(error: error.description)
            self.mView?.stopLoading()
        }
        
    }
    
    func fetchMoreUpComingMovies() {
        if page < totalPages {
            page += 1
        } else {
            return
        }
        param = ["page": "\(page)"]
        self.mView?.startPagination()
        MovieModel.shared.fetchUpComingMovies(param: param, success: { (response) in
//            let upComingMovies = response.results ?? []
//            self.movieService.save(movies: upComingMovies, type: .UpComing)
            
            self.upComingMovies.append(contentsOf: response.results ?? [])
            self.mView?.gotMovies(topRated: self.topRatedMovies, nowPlaying: self.nowPlayingMovies, upComing: self.upComingMovies)
            
            self.mView?.stopPagination()
        }) { (error) in
            self.mView?.gotError(error: error.description)
            self.mView?.stopPagination()
        }
    }
    
    func fetchPersistenceMovies() -> ([Movie], [Movie], [Movie]) {
        let topRatedMovies = movieService.fetchMovies(type: .TopRated)
        let nowPlayingMovies = movieService.fetchMovies(type: .NowPlaying)
        let upComingMovies = movieService.fetchMovies(type: .UpComing)
        return (topRatedMovies, nowPlayingMovies, upComingMovies)
    }
    
}

//extension HomePresenter: MoviePersistenceListener {
//    func moviePersistenceDidUpdate() {
//        let topRatedMovies = movieService.fetchMovies(type: .TopRated)
//        let nowPlayingMovies = movieService.fetchMovies(type: .NowPlaying)
//        let upComingMovies = movieService.fetchMovies(type: .UpComing)
//
//        self.mView?.gotMovies(topRated: topRatedMovies, nowPlaying: nowPlayingMovies, upComing: upComingMovies)
//    }
//}
