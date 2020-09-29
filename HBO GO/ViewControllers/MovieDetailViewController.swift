//
//  MovieDetailViewController.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, MovieDetailView {

    static let id = "MovieDetailViewController"
    
    @IBOutlet weak var similarMovieCollectionView: UICollectionView!
    @IBOutlet weak var ivBackdrop: UIImageView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    
    @IBOutlet weak var lbRunTime: UILabel!
    @IBOutlet weak var lbGenres: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var lbOverview: UITextView!
    
    private let mPresenter = MovieDetailPresenter()
    
    private var mMovie: MovieInfo?
    private var mSimilarMovies: [MovieInfo] = []
    var movieId: Int32?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpSimilarMovieCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mPresenter.mView = self
        mPresenter.fetchDetail(for: movieId!)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickBookmark(_ sender: Any) {
//        mPresenter.updateBookmark(movieId: movieId!)
        if btnBookmark.isSelected {
            mPresenter.removeBookmark(movieId: movieId!)
        } else {
            mPresenter.saveBookmark(movie: mMovie!)
        }
        btnBookmark.isSelected.toggle()
    }
    
    @IBAction func onClickPlay(_ sender: Any) {
        mPresenter.fetchTrailer(for: movieId ?? 0)
    }
    
    private func setUpViews() {
        btnPlay.layer.cornerRadius = 20
        btnPlay.layer.borderWidth = 2
        btnPlay.layer.borderColor = UIColor.primaryColor.cgColor
        
        btnBookmark.setImage(UIImage(named: "icon_bookmark")?.withTintColor(.primaryColor), for: .normal)
        btnBookmark.setImage(UIImage(named: "icon_bookmark_fill")?.withTintColor(.primaryColor), for: .selected)
    }
    
    private func setUpSimilarMovieCollectionView() {
        
        let itemHeight: CGFloat = 164
        let itemWidth: CGFloat = itemHeight * ( 3 / 4 )
        let itemPadding: CGFloat = 8
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = itemPadding
        
        similarMovieCollectionView.dataSource = self
        
        similarMovieCollectionView.setCollectionViewLayout(layout, animated: true)
        similarMovieCollectionView.registerWithItem(id: MovieItem.id)
        similarMovieCollectionView.showsHorizontalScrollIndicator = false
        similarMovieCollectionView.contentInset = UIEdgeInsets(top: 0, left: itemPadding, bottom: 0, right: itemPadding)
        
    }
    
    private func bindData(movie: MovieInfo) {
        mMovie = movie
        
        let runTime = "\((movie.runtime ?? 0) / 60)hr" + "\((movie.runtime ?? 0) % 60)min"
        let genres = movie.genres!.map{$0.name!}.joined(separator: ",")
        
        lbTitle.text = movie.originalTitle ?? "-"
        ivPoster.setWebImage(path: movie.posterPath ?? "")
        ivBackdrop.setWebImage(path: movie.backdropPath ?? "")
        
        lbRunTime.text = runTime
        lbGenres.text = genres
        lbReleaseDate.text = movie.releaseDate ?? "-"
        lbRating.text = "\(movie.voteAverage ?? 0.0)"
        lbOverview.text = "\t" + (movie.overview ?? "-")
        
        btnBookmark.isSelected = mPresenter.checkIsBookmarked(movieId: movieId!)
    }
    
    func gotData(movie: MovieInfo) {
        DispatchQueue.main.async { self.bindData(movie: movie) }
    }
    
    func gotSimilarMovies(movies: [MovieInfo]) {
        DispatchQueue.main.async {
            self.mSimilarMovies = movies
            self.similarMovieCollectionView.reloadData()
        }
    }
    
    func gotTrailer(key: String) {
        DispatchQueue.main.async {
            let player = TrailerDialog(for: self.mMovie!.originalTitle ?? "-", id: key)
            player.play()
        }
    }
    
    func gotError(error: String) {
        print(error)
    }
       
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mSimilarMovies.count == 0 {
            similarMovieCollectionView.showCollectionViewStatus("No Similar Movies")
        } else {
            similarMovieCollectionView.restoreCollectionView()
        }
        return mSimilarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItem.id, for: indexPath) as! MovieItem
        item.bindData(movieInfo: mSimilarMovies[indexPath.item])
        return item
    }
    
    
}
