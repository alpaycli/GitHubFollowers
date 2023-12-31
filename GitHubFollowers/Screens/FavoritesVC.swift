//
//  FavoritesVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 05.08.23.
//

import UIKit

class FavoritesVC: GFDataLoadingVC {
    
    let tableView = UITableView()
    
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
    }
    
    private func fetchFavorites() {
        PersistenceManager.shared.loadFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
                
            case .failure(let error):
                self.presentGFAlert(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func updateUI(with favorites: [Follower]) {
        if favorites.isEmpty {
            self.showEmptyStateView(with: "You have not favorited any user.", in: self.view)
            return
        }
        
        self.favorites = favorites
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = UserInfoVC()
        destVC.username = favorite.login
        destVC.delegate = self
        
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        PersistenceManager.shared.updateWith(favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            
            self.presentGFAlert(title: "Ops...", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}

extension FavoritesVC: UserInfoVCDelegate {
    func didTapGetFollowers(for username: String) {
        let destVC = FollowersListVC(username: username)
        navigationController?.pushViewController(destVC, animated: true)
    }
}
