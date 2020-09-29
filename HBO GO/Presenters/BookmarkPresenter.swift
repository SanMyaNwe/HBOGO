//
//  BookmarkPresenter.swift
//  HBO GO
//
//  Created by Riki on 8/6/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation

protocol BookmarkPresenterProtocol {
    var mView: BookmarkView? {get set}
    func fetchBookmarkMovies()
}

class BookmarkPresenter: BookmarkPresenterProtocol {
    var mView: BookmarkView?
    
    func fetchBookmarkMovies() {
        let bookmarkMovies = MoviePersistenceService.shared.fetchBookmarkedMovies()
        self.mView?.gotBookmarkMovies(movies: bookmarkMovies)
    }

}

