//
//  AllMoviesTableViewCell.swift
//  MovieDatabase
//
//  Created by Mohd Wasif Raza on 12/08/23.
//

import UIKit

class AllMoviesTableViewCell: UITableViewCell {
    
    let movieImageView = UIImageView()
    let nameLabel = UILabel()
    var languageLabel = UILabel()
    let yearLabel = UILabel()
    
    private let otherNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraintsForMovieCell() {
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.widthAnchor.constraint(equalToConstant: 80),
            movieImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),

            languageLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            languageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            languageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            languageLabel.heightAnchor.constraint(equalToConstant: 20),

            yearLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            yearLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 10),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            yearLabel.heightAnchor.constraint(equalToConstant: 20),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: yearLabel.bottomAnchor, constant: 10)
        ])
    }
    
    private func setupConstraintsForOtherCell() {
        NSLayoutConstraint.activate([
            otherNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            otherNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            otherNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            otherNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0)
        ])
    }
    
    private func setupViews() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(languageLabel)
        contentView.addSubview(yearLabel)
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        setupConstraintsForMovieCell()
    }
    
    func configure(with movie: Movie) {
        let url = URL(string: movie.poster)
        
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
        nameLabel.text = movie.title
        languageLabel.text = movie.language
        yearLabel.text = movie.year
    }
}
