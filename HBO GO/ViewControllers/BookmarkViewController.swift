//
//  BookmarkViewController.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, BookmarkView {
    
    static let id = "BookmarkViewController"
    
    @IBOutlet weak var movieTableView: UITableView!
    
    private var mBookmarkMovies = [Movie]()
    
    private var mPresenter = BookmarkPresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        setUpMovieTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mPresenter.fetchBookmarkMovies()
    }
    
    private func setUpMovieTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.backgroundColor = .secondaryColor
        movieTableView.rowHeight = 188
        movieTableView.tableFooterView = UIView()
        movieTableView.showsVerticalScrollIndicator = false
        movieTableView.registerWithRow(id: MovieRow.id)
    }
    
    func gotBookmarkMovies(movies: [Movie]) {
        mBookmarkMovies = movies
        movieTableView.reloadData()
    }
    
}

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mBookmarkMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieRow.id, for: indexPath) as! MovieRow
        cell.bindData(movie: mBookmarkMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: MovieDetailViewController.id) as! MovieDetailViewController
        vc.modalPresentationStyle = .fullScreen
        vc.movieId = mBookmarkMovies[indexPath.row].id
        self.present(vc, animated: true, completion: nil)
    }
}
