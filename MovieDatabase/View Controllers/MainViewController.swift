//
//  ViewController.swift
//  MovieDatabase
//
//  Created by Mohd Wasif Raza on 11/08/23.
//

import UIKit

class MainViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollapsibleTableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(AllMoviesTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        table.register(CollapsibleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return table
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section,Detail>!
    private var movies: [Movie] = []
    private var movieSection: Section?
    private var sections: [Section] = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.isHidden = true
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        self.title = "Movie Database"
        getData()
        setUpSearchBar()
        configureDataSource()
    }
    
    @objc func backButtonTapped() {
        movieSection = nil
        navigationItem.leftBarButtonItem?.isHidden = true
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(sections)
        sections.forEach { section in
            if !section.collapsed {
                snapshot.appendItems(section.items, toSection: section)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    private func setUpSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.placeholder = "Search settings..."
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            searchBar.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func configureDataSource(){
        dataSource = UITableViewDiffableDataSource<Section, Detail>(tableView: tableView, cellProvider: { (tableView, indexPath, user) -> UITableViewCell? in
            if let movie = user.movie {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)  as? AllMoviesTableViewCell ??
                AllMoviesTableViewCell(style: .default, reuseIdentifier: "MovieCell")
                cell.configure(with: movie)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as? CollapsibleTableViewCell ??
                CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")
                cell.nameLabel.text = user.name
                return cell
            }
        })
        var snapshot = NSDiffableDataSourceSnapshot<Section, Detail>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    
    private func getData(){
        APICaller.shared.fetchData { [weak self] result in
            switch result {
            case .success(let (fetchedSections, fetchedMovies)):
                self?.sections = fetchedSections
                self?.movies = fetchedMovies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        if (searchBar.searchTextField.text != "") {
            header.titleLabel.text = "Search Results"
            header.arrowLabel.isHidden = true
        }
        else if (movieSection != nil) {
            header.titleLabel.text = movieSection?.name
            header.arrowLabel.isHidden = true
        }
        else {
            header.titleLabel.text = sections[section].name
            header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
            header.arrowLabel.isHidden = false
        }
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        header.section = section
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? AllMoviesTableViewCell {
            let navController = UINavigationController(rootViewController: MovieDetailViewController(movieName: cell.nameLabel.text ?? "No Name"))
            navController.modalPresentationStyle = .pageSheet // set the presentation style as full screen
            present(navController, animated: true)
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CollapsibleTableViewCell else {
            return
        }
        navigationItem.leftBarButtonItem?.isHidden = false
        let section = indexPath.section
        if (searchBar.searchTextField.text != "" || sections[section].name.contains("All Movies") || (movieSection != nil)) {
            // Show detail view for Movie
            return;
        }
        let name = "All Movies for \(sections[section].name) \(String(describing: (cell.nameLabel.text ?? "")))"
        var moviesData: [Movie] = []
        if sections[section].name == "Year" {
            moviesData = movies.filter( {$0.year.contains(cell.nameLabel.text ?? "")})
        }
        else if sections[section].name == "Genre" {
            moviesData = movies.filter( {$0.genre.contains(cell.nameLabel.text ?? "")})
        }
        else if sections[section].name == "Directors" {
            moviesData = movies.filter( {$0.director.contains(cell.nameLabel.text ?? "")})
        }
        else if sections[section].name == "Actors" {
            moviesData = movies.filter( {$0.actors.contains(cell.nameLabel.text ?? "")})
        }
        let moviesDetails: [Detail] = moviesData.map {
            Detail(name: $0.title, movie: $0)
        }
        
        movieSection = Section(name: name, items: moviesDetails, collapsed: false)
        if let section = movieSection {
            var snapShot1 = NSDiffableDataSourceSnapshot<Section, Detail>()
            snapShot1.appendSections([section])
            snapShot1.appendItems(moviesDetails, toSection: section)
            dataSource.apply(snapShot1, animatingDifferences: false)
        }
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        var snapshot = dataSource.snapshot()
        
        let sectionIndex = cell.section
        if sections[sectionIndex].collapsed {
            snapshot.appendItems(sections[sectionIndex].items, toSection: sections[sectionIndex])
        }
        else {
            snapshot.deleteItems(sections[sectionIndex].items)
        }
        cell.setCollapsed(!sections[sectionIndex].collapsed)
        sections[sectionIndex].collapsed.toggle()
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
}

//MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var snapshot = dataSource.snapshot()
        // Filtering the data with given query
        if(!searchText.isEmpty){
            let filteredItems = movies.filter( {$0.year.contains(searchText) || $0.genre.contains(searchText) || $0.director.contains(searchText) || $0.actors.contains(searchText) || $0.title.contains(searchText)})
            let moviesDetails: [Detail] = filteredItems.map {
                Detail(name: $0.title, movie: $0)
            }
            
            let section = Section(name: "Search Results", items: moviesDetails, collapsed: false)
            snapshot.deleteAllItems()
            snapshot.appendSections([section])
            snapshot.appendItems(moviesDetails, toSection: section)
            dataSource.apply(snapshot, animatingDifferences: false)
        }else{
            snapshot.deleteAllItems()
            snapshot.appendSections(sections)
            sections.forEach { section in
                if !section.collapsed {
                    snapshot.appendItems(section.items, toSection: section)
                }
            }
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}


