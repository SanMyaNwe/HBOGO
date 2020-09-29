//
//  SearchView.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
protocol SearchView {
    
    func gotMovies(movies: [MovieInfo])
    func gotError(error: String)
    func startLoading()
    func stopLoading()
    
}
