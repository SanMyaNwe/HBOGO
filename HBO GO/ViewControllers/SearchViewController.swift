//
//  SearchViewController.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, SearchView {

    static let id = "SearchViewController"
    
    private var mPresenter = SearchPresenter()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private var mMovies = [MovieInfo]()
    private var isPageLoading: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMoviesCollectionView()
        mPresenter.mView = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpViews()
    }
    
    private func setUpMoviesCollectionView() {
        let size: CGSize = self.view.bounds.size
        let numberOfItem: CGFloat = 2
        let itemPadding: CGFloat = 8
        let totalPadding: CGFloat = itemPadding * ( numberOfItem + 1 )
        let itemWidth: CGFloat = ( size.width - totalPadding ) / numberOfItem
        let itemHeight: CGFloat = itemWidth * ( 4 / 3 )
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = itemPadding
        layout.minimumInteritemSpacing = itemPadding
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        moviesCollectionView.setCollectionViewLayout(layout, animated: true)
        moviesCollectionView.showsVerticalScrollIndicator = false
        moviesCollectionView.keyboardDismissMode = .onDrag
        
        //TODO: - Implement Pagination UI Indicator
        
        moviesCollectionView.registerWithItem(id: MovieItem.id)
        moviesCollectionView.contentInset = UIEdgeInsets(top: itemPadding, left: itemPadding, bottom: itemPadding, right: itemPadding)
    }
    
    
    private func setUpViews() {
        searchBar.delegate = self
        let searchIcon = UIImage(named: "icon_search")!.withTintColor(.primaryColor)
        searchBar.setImage(searchIcon, for: .search, state: .normal)
        searchBar.searchTextField.textColor = .primaryColor
        searchBar.searchTextField.font = UIFont(name: "Kefa", size: 18)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search movies", attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryColor])
    }
    
    private func presentDetailView(movieId: Int32) {
        let detail = UIStoryboard.Main.instiante(with: MovieDetailViewController.id, value: MovieDetailViewController.self)
        detail.modalPresentationStyle = .fullScreen
        detail.movieId = movieId
        present(detail, animated: true, completion: nil)
    }
    
    func gotMovies(movies: [MovieInfo]) {
        isPageLoading = false
        mMovies = movies
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
    
    func gotError(error: String) {
        print(error)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItem.id, for: indexPath) as! MovieItem
        item.bindData(movieInfo: mMovies[indexPath.item])
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentDetailView(movieId: Int32(mMovies[indexPath.item].id ?? 0))
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentSize: CGSize = moviesCollectionView.contentSize
        let contentOffset: CGPoint = moviesCollectionView.contentOffset
        let frame: CGSize = moviesCollectionView.frame.size
        
        if (frame.height + contentOffset.y) > contentSize.height + 32 && !isPageLoading {
            isPageLoading = true
            mPresenter.fetchMoreSerachMovies()
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if searchBar.text == "" { return }
        mPresenter.searchMovies(with: searchBar.text ?? "")
    }
    
}
