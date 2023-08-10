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
    var username: String!
    var page = 1
    var hasMoreFollowers = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configureCollectionView()
        fetchFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func fetchFollowers(username: String, page: Int) {
        let baseUrl = "https://api.github.com/users/"
        let manager = NetworkManager()
        
        // followers?per_page=100&page=1
        
        let endpoint = baseUrl + "\(username)/" + "followers?per_page=100&page=\(page)"
        let url = URLRequest(url: URL(string: endpoint)!)
        
        print(url)
        
        manager.fetch([Follower].self, url: url) { [weak self] result in
            switch result {
            case .failure:
                self?.presentGFAlert(title: "Something went wrong", message: "No account found related to that username, try again later", buttonTitle: "Ok")
            case .success(let followers):
                if followers.count < 100 { self?.hasMoreFollowers = false }
                
                self?.followers.append(contentsOf: followers)
                self?.updateData()
            }
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    private func setupViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

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
