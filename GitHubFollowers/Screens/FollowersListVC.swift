//
//  FollowersListVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 06.08.23.
//

import UIKit

class FollowersListVC: UIViewController {
    
    enum Section {
        case main
    }

    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    
    var username: String!
    var page = 1
    var hasMoreFollowers = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureCollectionView()
        configureSearchBar()
        fetchFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func fetchFollowers(username: String, page: Int) {
        showLoadingView()
        FollowersFetcher.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.hideLoadingView()
            
            switch result {
            case .failure:
                self.presentGFAlert(title: "Something went wrong", message: "No account found related to that username, try again later", buttonTitle: "Ok")
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                
                if followers.isEmpty {
                    let message = "This user hasn not got any followers 😢. You can give him a follow 😸."
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                
                self.updateData(self.followers)
            }
        }
    }
    
    private func configureSearchBar() {
        let searchBar = UISearchController()
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchBar
        
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func updateData(_ data: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

// MARK: Scroll View Pagination
extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let scrollY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if scrollY > contentHeight - screenHeight {
            guard hasMoreFollowers else { return }
            page += 1
            fetchFollowers(username: username, page: page)
        }
    }
}

// MARK: Searchable
extension FollowersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        filteredFollowers = followers.filter { $0.login.lowercased().contains(searchText.lowercased()) }
        
        updateData(filteredFollowers)
    }
    
    
}
