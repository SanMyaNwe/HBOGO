//
//  MovieDetailView.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

protocol MovieDetailView {
    
    func gotData(movie: MovieInfo)
    func gotSimilarMovies(movies: [MovieInfo])
    func gotTrailer(key: String)
    func gotError(error: String)
    func startLoading()
    func stopLoading()
    
}
