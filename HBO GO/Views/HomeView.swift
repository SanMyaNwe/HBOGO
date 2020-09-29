//
//  HomeView.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

protocol HomeView {
    
    func gotMovies(topRated: [MovieInfo], nowPlaying: [MovieInfo], upComing: [MovieInfo])
    func gotError(error: String)
    func startLoading()
    func stopLoading()
    func startPagination()
    func stopPagination()
    
}
