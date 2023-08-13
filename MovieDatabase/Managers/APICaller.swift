//
//  APICaller.swift
//  MovieDatabase
//
//  Created by Mohd Wasif Raza on 13/08/23.
//

import Foundation

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()
    
    func fetchData(completion: @escaping (Result<([Section],[Movie]), Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let decoder = JSONDecoder()
                let movies = try decoder.decode([Movie].self, from: data)
                var yearsData: Set<String> = Set()
                var genresData: Set<String> = Set()
                var directorsData: Set<String> = Set()
                var actorsData: Set<String> = Set()
                var moviesData: Set<Movie> = Set()
                var yearsDetail: [Detail] = []
                var genresDetail: [Detail] = []
                var directorsDetail: [Detail] = []
                var actorsDetail: [Detail] = []
                var moviessDetail: [Detail] = []
                
                for movie in movies {
                    yearsData.insert(movie.year)
                    let genreArray = movie.genre
                        .trimmingCharacters(in: .whitespaces) // Trim leading and trailing white spaces
                        .components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    for genre in genreArray {
                        genresData.insert(genre)
                    }
                    let directorArray = movie.director
                        .trimmingCharacters(in: .whitespaces) // Trim leading and trailing white spaces
                        .components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    for director in directorArray {
                        directorsData.insert(director)
                    }
                    
                    let actorArray = movie.actors.trimmingCharacters(in: .whitespaces) // Trim leading and trailing white spaces
                        .components(separatedBy: ",")
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    for actor in actorArray {
                        actorsData.insert(actor)
                    }
                    
                    moviesData.insert(movie)
                }
                
                yearsDetail = yearsData.sorted().map {
                    Detail(name: $0, movie: nil)
                }
                genresDetail = genresData.sorted().map {
                    Detail(name: $0, movie: nil)
                }
                directorsDetail = directorsData.sorted().map {
                    Detail(name: $0, movie: nil)
                }
                actorsDetail = actorsData.sorted().map {
                    Detail(name: $0, movie: nil)
                }
                moviessDetail = moviesData.map {
                    Detail(name: $0.title, movie: $0)
                }
                var sections: [Section] = [Section]()
                sections.append(Section(name: "Year", items: yearsDetail, collapsed: true))
                sections.append(Section(name: "Genre", items: genresDetail, collapsed: true))
                sections.append(Section(name: "Directors", items: directorsDetail, collapsed: true))
                sections.append(Section(name: "Actors", items: actorsDetail, collapsed: true))
                sections.append(Section(name: "All Movies", items: moviessDetail, collapsed: true))
                completion(.success((sections,movies)))
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
}
