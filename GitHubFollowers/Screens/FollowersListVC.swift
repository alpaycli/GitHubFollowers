//
//  FollowersListVC.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 06.08.23.
//

import UIKit

class FollowersListVC: GFDataLoadingVC {
    
    enum Section {
        case main
    }

    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    
    var username: String!
    var page = 1
    var hasMoreFollowers = true
    
    var isSearching = false
    var isLoadingFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureCollectionView()
        fetchFollowers(username: username, page: page)
        configureSearchBar()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func fetchFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
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
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
        
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonAction() {
        showLoadingView()
        isLoadingFollowers = true
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            self.hideLoadingView()
            
            switch result {
            case .success(let user):
                let follower = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager.shared.updateWith(follower, actionType: .add) { error in
                    guard let error = error else {
                        self.presentGFAlert(title: "Succesfully favorited!🎉", message: "You have favorited \(user.login)!🥳", buttonTitle: "Cancel")
                        return
                    }
                    
                    self.presentGFAlert(title: "Ops..", message: error.description, buttonTitle: "Ok")
                }
                
                
            case .failure(let error):
                self.presentGFAlert(title: "Something went wrong.", message: error.description, buttonTitle: "Ok")
            }
            
            self.isLoadingFollowers = false
        }
    }
    
}

// MARK: Scroll View Pagination
extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let scrollY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if scrollY > contentHeight - screenHeight {
            guard hasMoreFollowers, !isLoadingFollowers else { return }
            page += 1
            fetchFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentFollowers = isSearching ? filteredFollowers : followers
        let follower = currentFollowers[indexPath.item]
        
        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
        
    }
}

// MARK: Searchable
extension FollowersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            isSearching = false
            updateData(followers)
            filteredFollowers.removeAll()
            return
        }
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(searchText.lowercased()) }
        
        updateData(filteredFollowers)
    }
}

// MARK: For reloading, when another action called in other view.
extension FollowersListVC: UserInfoVCDelegate {
    func didTapGetFollowers(for username: String) {
        self.username = username
        self.page = 1
        
        title = username
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        fetchFollowers(username: username, page: page)
    }
}
