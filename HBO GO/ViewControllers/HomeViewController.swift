//
//  HomeViewController.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeView {
    
    static let id = "HomeViewController"
    
    @IBOutlet weak var movieHeaderCollectionView: UICollectionView!
    @IBOutlet weak var nowPlayingMovieCollectionView: UICollectionView!
    @IBOutlet weak var upComingMovieTableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    private var refreshControl: UIRefreshControl!
    private var indicator: UIActivityIndicatorView!
    
    private var mPresenter = HomePresenter()
    
    private var mTopRatedMovies = [MovieInfo]()
    private var mNowPlayingMovies = [MovieInfo]()
    private var mUpComingMovies = [MovieInfo]()
    
    private var counter: Int = 0 {
        didSet {
            self.movieHeaderCollectionView.scrollToItem(at: IndexPath(item: counter, section: 0), at: .centeredHorizontally, animated: true)
            self.pageControl.currentPage = counter
        }
    }
    private var isPageLoading: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMovieHeaderCollectionView()
        setUpNowPlayingMovieCollectionView()
        setUpUpComingMovieTableView()
        setUpPageControl()
        mPresenter.mView = self
        mPresenter.fetchApiMovies()
//        bindMovies()
    }
    
    private func setUpMovieHeaderCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.bounds.size.width, height: 170)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        movieHeaderCollectionView.setCollectionViewLayout(layout, animated: true)
        movieHeaderCollectionView.isPagingEnabled = true
        movieHeaderCollectionView.showsHorizontalScrollIndicator = false
        movieHeaderCollectionView.dataSource = self
        movieHeaderCollectionView.delegate = self
        movieHeaderCollectionView.registerWithItem(id: MovieHeaderItem.id)
    }
    
    private func setUpNowPlayingMovieCollectionView() {
        let itemHeight: CGFloat = 210
        let itemWidth: CGFloat = itemHeight * ( 3 / 4 )
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        
        nowPlayingMovieCollectionView.dataSource = self
        nowPlayingMovieCollectionView.delegate = self
        
        nowPlayingMovieCollectionView.setCollectionViewLayout(layout, animated: true)
        nowPlayingMovieCollectionView.showsHorizontalScrollIndicator = false
        nowPlayingMovieCollectionView.registerWithItem(id: MovieItem.id)
        nowPlayingMovieCollectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    private func setUpUpComingMovieTableView() {
        upComingMovieTableView.dataSource = self
        upComingMovieTableView.delegate = self
        upComingMovieTableView.rowHeight = 188
        upComingMovieTableView.showsVerticalScrollIndicator = false
        upComingMovieTableView.registerWithRow(id: MovieRow.id)
        
        indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .primaryColor
        indicator.frame.size = CGSize(width: 30, height: 60)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.primaryColor,
            NSAttributedString.Key.font: UIFont(name: "Kefa", size: 16)!
        ]
        
        upComingMovieTableView.refreshControl = refreshControl
        
        upComingMovieTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Reload Movies", attributes: attributes)
    }
    
    @objc
    func onRefresh() {
        refreshControl.endRefreshing()
    }
    
    private func showBottomIndicator() {
        indicator.startAnimating()
        upComingMovieTableView.tableFooterView = indicator
    }
    
    private func hideBottomIndicator() {
        indicator.stopAnimating()
        upComingMovieTableView.tableFooterView = UIView()
    }
    
    private func setUpPageControl() {
        let limit = 10
        
        pageControl.numberOfPages = limit
        pageControl.currentPage = 0
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            if self.counter == limit - 1 {
                self.counter = 0
            } else {
                self.counter += 1
            }
        }
        
    }
    
    private func presentDetailView(movieId: Int32) {
        let detail = UIStoryboard.Main.instiante(with: MovieDetailViewController.id, value: MovieDetailViewController.self)
        detail.modalPresentationStyle = .fullScreen
        detail.movieId = movieId
        present(detail, animated: true, completion: nil)
    }
    
//    func bindMovies() {
//        let (top, now, up) = mPresenter.fetchPersistenceMovies()
//        if top.count > 0 && now.count > 0 && up.count > 0 {
//            gotMovies(topRated: top, nowPlaying: now, upComing: up)
//        } else {
//            mPresenter.fetchApiMovies()
//        }
//    }
    
    func gotMovies(topRated: [MovieInfo], nowPlaying: [MovieInfo], upComing: [MovieInfo]) {
        mTopRatedMovies.append(contentsOf: topRated.prefix(10))
        mNowPlayingMovies = nowPlaying
        mUpComingMovies = upComing
        
        DispatchQueue.main.async {
            self.movieHeaderCollectionView.reloadData()
            self.nowPlayingMovieCollectionView.reloadData()
            self.upComingMovieTableView.reloadData()
        }
    }
    
    func gotError(error: String) {
        print(error)
    }
    
    func startPagination() {
        DispatchQueue.main.async {
            self.showBottomIndicator()
        }
    }
    
    func stopPagination() {
        isPageLoading = false
        DispatchQueue.main.async {
            self.hideBottomIndicator()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == movieHeaderCollectionView ? mTopRatedMovies.count : mNowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == movieHeaderCollectionView {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: MovieHeaderItem.id, for: indexPath) as! MovieHeaderItem
            item.bindData(movie: mTopRatedMovies[indexPath.item])
            return item
        } else {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItem.id, for: indexPath) as! MovieItem
            item.bindData(movieInfo: mNowPlayingMovies[indexPath.item])
            return item
        }
    }
    
}

extension HomeViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == movieHeaderCollectionView {
            presentDetailView(movieId: Int32(mTopRatedMovies[indexPath.item].id ?? 0))
        } else {
            presentDetailView(movieId: Int32(mNowPlayingMovies[indexPath.item].id ?? 0))
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == movieHeaderCollectionView {
            let layout = self.movieHeaderCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            let offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            let roundedIndex = round(index)
            counter = Int(roundedIndex)
        }
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mUpComingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: MovieRow.id, for: indexPath) as! MovieRow
        row.bindData(movie: mUpComingMovies[indexPath.row])
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDetailView(movieId: Int32(mUpComingMovies[indexPath.row].id ?? 0))
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentSize: CGSize = upComingMovieTableView.contentSize
        let contentOffset: CGPoint = upComingMovieTableView.contentOffset
        let frame: CGRect = upComingMovieTableView.frame
        
        if (frame.size.height + contentOffset.y) > contentSize.height + 32 && !isPageLoading {
            isPageLoading = true
            mPresenter.fetchMoreUpComingMovies()
        }
    }
    
}
