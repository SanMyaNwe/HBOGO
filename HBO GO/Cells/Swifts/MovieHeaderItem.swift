//
//  MovieHeaderItem.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class MovieHeaderItem: UICollectionViewCell {
    
    static let id = "MovieHeaderItem"

    @IBOutlet weak var ivMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(movie: MovieInfo) {
        ivMovie.setWebImage(path: movie.backdropPath ?? "")
    }

}
