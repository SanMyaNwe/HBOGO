//
//  MovieItem.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class MovieItem: UICollectionViewCell {
    
    static let id = "MovieItem"

    @IBOutlet weak var ivMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(movie: Movie) {
        ivMovie.setWebImage(path: movie.posterPath ?? "")
    }
    
    func bindData(movieInfo: MovieInfo) {
        ivMovie.setWebImage(path: movieInfo.posterPath ?? "")
    }

}
