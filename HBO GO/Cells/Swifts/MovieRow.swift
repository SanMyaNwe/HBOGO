//
//  MovieRow.swift
//  HBO GO
//
//  Created by Riki on 7/19/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit

class MovieRow: UITableViewCell {
    
    static let id = "MovieRow"

    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var lbMovieName: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var lbPopularity: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bindData(movie: MovieInfo) {
        ivMovie.setWebImage(path: movie.posterPath ?? "")
        lbMovieName.text    = movie.originalTitle ?? "-"
        lbPopularity.text   = "Popularity : " + "\(movie.popularity ?? 0.0)"
        lbRating.text       = "Rating : " + "\(movie.voteAverage ?? 0.0)"
        lbReleaseDate.text  = "Release Date : " + (movie.releaseDate ?? "-")
        
    }
    
    func bindData(movie: Movie) {
        ivMovie.setWebImage(path: movie.posterPath ?? "")
        lbMovieName.text    = movie.originalTitle ?? "-"
        lbPopularity.text   = "Popularity : " + "\(movie.popularity)"
        lbRating.text       = "Rating : " + "\(movie.voteAverage)"
        lbReleaseDate.text  = "Release Date : " + (movie.releaseDate ?? "-")
        
    }
}
