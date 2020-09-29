//
//  MoviePersistenceService.swift
//  HBO GO
//
//  Created by Riki on 8/3/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
import CoreData

class MoviePersistenceService {
    
    static let shared = MoviePersistenceService()
    private init(){}
    
    private var viewContext = PersistenceService.shared.persistenceContainer.viewContext
    
    var listeners: [MoviePersistenceListener] = []
    var timer: Timer?
    
    func save(movies: [MovieInfo], type: MovieType) {
        
        for movie in movies {
            let movieEntity = Movie(context: viewContext)
            
            movieEntity.id = Int32(movie.id!)
            movieEntity.originalTitle = movie.originalTitle
            movieEntity.posterPath = movie.posterPath
            movieEntity.backdropPath = movie.backdropPath
            movieEntity.popularity = movie.popularity ?? 0.0
            movieEntity.voteAverage = movie.voteAverage ?? 0.0
            movieEntity.releaseDate = movie.releaseDate
            movieEntity.bookmark = false
            movieEntity.type = type.rawValue
            
            save()
        }
    }
    
    func fetchMovies(type: MovieType) -> [Movie] {
        
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let bookmarkPredicate = NSPredicate(format: "bookmark = %d", false)
        let typePredicate = NSPredicate(format: "type = %@", type.rawValue)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [bookmarkPredicate, typePredicate])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Persistence fetch error...")
            return []
        }
    }
    
    func fetchBookmarkedMovies() -> [Movie] {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "bookmark = %d", true)
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Persistence fetch error...")
            return []
        }
    }
    
    func updateBookmark(movieId: Int32) {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "id = %i", movieId)
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            if result.count > 0 {
                let movie = result.first
                if movie?.bookmark == true {
                    movie?.bookmark = false
                } else {
                    movie?.bookmark = true
                }
                
                save()
            }
        } catch {
            print("Bookmark update error...")
        }
    }
    
    func formatMovies() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "bookmark = %d", false)
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach { (movie) in
                viewContext.delete(movie)
            }
            
        } catch {
            print("Format error...")
        }
    }
    
    func checkIsBookmarked(movieId: Int32) -> Bool {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "id = %i", movieId)
        fetchRequest.predicate = predicate
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            if result.count > 0 {
                let movie = result.first
                return movie!.bookmark
            } else {
                return false
            }
        } catch {
            print("Check bookmark error...")
            return false
        }
    }
    
    func saveBookmark(movie: MovieInfo) {
        let movieEntity = Movie(context: viewContext)
        movieEntity.id = Int32(movie.id ?? 0)
        movieEntity.originalTitle = movie.originalTitle
        movieEntity.posterPath = movie.posterPath
        movieEntity.releaseDate = movie.releaseDate
        movieEntity.voteAverage = movie.voteAverage ?? 0.0
        movieEntity.popularity = movie.popularity ?? 0.0
        movieEntity.bookmark = true
        
        save()
    }
    
    func removeBookmark(movieId: Int32) {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "id = %i", movieId)
        fetchRequest.predicate = predicate
        do {
            let result = try viewContext.fetch(fetchRequest)
            if result.count > 0 {
                viewContext.delete(result.first!)
                save()
            }

        } catch {
            print("Remove bookmark error...")
        }
        
    }
    
    func save() {
        PersistenceService.shared.saveContext()
        
        //debounce
        timer?.invalidate()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
                self.listeners.forEach{ $0.moviePersistenceDidUpdate() }
            })
        }

    }
    
    func listenOn(_ newListener: MoviePersistenceListener) {
        listeners.append(newListener)
    }
}
