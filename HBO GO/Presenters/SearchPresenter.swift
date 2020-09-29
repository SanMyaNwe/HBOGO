//
//  SearchPresenter.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

protocol SearchPresenterProtocol {
    var mView: SearchView? { get set }
    func searchMovies(with query: String)
}

class SearchPresenter: SearchPresenterProtocol {
    var mView: SearchView?
    
    var page = 1
    var totalPages = 0
    var param: [String: String] = [:]
    
    var query: String = ""
    var searchMovies: [MovieInfo] = []
    
    func searchMovies(with query: String) {
        self.page = 1
        self.param = [
            "query": query,
            "page": "\(page)"
        ]
        self.query = query
        self.mView?.startLoading()
        MovieModel.shared.searchMovies(params: param, success: { (response) in
            self.searchMovies = response.results ?? []
            self.totalPages = response.totalPages ?? 0
            self.mView?.gotMovies(movies: response.results ?? [])
            self.mView?.stopLoading()
        }) { (error) in
            self.mView?.gotError(error: error.description)
            self.mView?.stopLoading()
        }
    }
    
    func fetchMoreSerachMovies() {
        if page < totalPages {
            page += 1
        } else {
            return
        }
        self.param = [
            "query": query,
            "page": "\(page)"
        ]
        MovieModel.shared.searchMovies(params: self.param, success: { (response) in
            self.searchMovies.append(contentsOf: response.results ?? [])
            self.mView?.gotMovies(movies: self.searchMovies)
        }) { (error) in
            self.mView?.gotError(error: error.description)
        }
    }
}

