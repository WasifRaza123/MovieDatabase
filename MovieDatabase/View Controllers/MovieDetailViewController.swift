//
//  MovieDetailViewController.swift
//  MovieDatabase
//
//  Created by Mohd Wasif Raza on 13/08/23.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieName:String
    
    let movieImageView = UIImageView()
    let nameLabel = UILabel()
    let plotLabel = UILabel()
    let directorLabel = UILabel()
    let actorLabel = UILabel()
    let yearLabel = UILabel()
    let genreLabel = UILabel()
    let ratingLabel = UILabel()
    let languageLabel = UILabel()
    
    let verticalSpacing: CGFloat = 10.0
    let horizontalSpacing: CGFloat = 16.0
    
    init(movieName: String) {
        self.movieName = movieName
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getData()
        setUpViews()
        applyConstraints()
    }
    
    private func setUpViews() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.numberOfLines = 0
        plotLabel.numberOfLines = 10
        actorLabel.numberOfLines = 0
        directorLabel.numberOfLines = 0
        languageLabel.numberOfLines = 0
        
        
        // Add views to your view controller's view
        view.addSubview(movieImageView)
        view.addSubview(nameLabel)
        view.addSubview(plotLabel)
        view.addSubview(directorLabel)
        view.addSubview(actorLabel)
        view.addSubview(yearLabel)
        view.addSubview(genreLabel)
        view.addSubview(ratingLabel)
        view.addSubview(languageLabel)
        
    }
    
    private func applyConstraints() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        directorLabel.translatesAutoresizingMaskIntoConstraints = false
        actorLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalSpacing),
            movieImageView.heightAnchor.constraint(equalToConstant: 200),
            movieImageView.widthAnchor.constraint(equalToConstant: 150),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            
            nameLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: verticalSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            
            plotLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: verticalSpacing),
            plotLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            plotLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            
            directorLabel.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: verticalSpacing),
            directorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            directorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            
            actorLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: verticalSpacing),
            actorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            actorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            
            yearLabel.topAnchor.constraint(equalTo: actorLabel.bottomAnchor, constant: verticalSpacing),
            yearLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            yearLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            
            genreLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: verticalSpacing),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            
            ratingLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: verticalSpacing),
            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            
            languageLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: verticalSpacing),
            languageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            languageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
        ])
    }
    
    private func getData(){
        APICaller.shared.fetchData { [weak self] result in
            switch result {
            case .success(let (_, fetchedMovies)):
                if let foundMovie = fetchedMovies.first(where: { $0.title == self?.movieName }) {
                    self?.configureImage(with: foundMovie.poster)
                    self?.nameLabel.text = "Title: \(foundMovie.title)"
                    self?.plotLabel.text = "Plot: \(foundMovie.plot)"
                    self?.directorLabel.text = "Director: \(foundMovie.director)"
                    self?.actorLabel.text = "Actor: \(foundMovie.actors)"
                    self?.yearLabel.text = "Year: \(foundMovie.year)"
                    self?.ratingLabel.text = "IMDB Rating: \(foundMovie.imdbRating)"
                    self?.languageLabel.text = "Language: \(foundMovie.language)"
                    
                } else {
                    print("Movie not found")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configureImage(with stringURL: String) {
        let url = URL(string: stringURL)
        
        // Load image data from the URL
        URLSession.shared.dataTask(with: url!) { data, _, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    // Set the image on the main thread
                    self.movieImageView.image = image
                }
            }
        }.resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
