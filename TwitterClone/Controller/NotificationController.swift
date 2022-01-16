//
//  NotificationController.swift
//  TwitterClone
//
//  Created by benji on 16/12/2021.
//

import UIKit


private let reuseID = "NotificationCell"

class NotificationController: UITableViewController {
    
    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: Selectors
    
    @objc func handleRefresh() {
        fetchNotifications()
    }
    
    // MARK: - API
    
    func fetchNotifications() {
        refreshControl?.endRefreshing()
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed(notifications: notifications)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserIsFollowed(notifications: [Notification]) {
        for(index, notification) in notifications.enumerated() {
            notifications.forEach { notification in
                if case .follow = notification.type {
                    let user = notification.user
                    
                    UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                        self.notifications[index].user.isFollowed = isFollowed
                    }
                    
                }
            }
            
            
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseID)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else {return}
        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}

extension NotificationController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
    
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, ref in
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}