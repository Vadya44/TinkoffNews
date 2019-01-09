//
//  ViewController.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AlertDisplayer {
    
    var isFromCD = true
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var viewModel : NewsViewModel!
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        
        indicatorView.color = UIColor.green
        indicatorView.startAnimating()
        
        tableView.isHidden = true
        tableView.separatorColor = UIColor.green
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        viewModel = NewsViewModel(delegate: self)
        
        viewModel.fillFromCD()
        
    }


}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchNews()
        }
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        self.isFromCD = false
        viewModel = nil
        viewModel = NewsViewModel(delegate: self)
        viewModel.fetchNews()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell
        
        if (isLoadingCell(for: indexPath)) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.news(at: indexPath.row))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newsVC = storyBoard.instantiateViewController(withIdentifier: "newsVC") as! NewsViewController
        newsVC.news = viewModel.news(at: indexPath.row)
        self.present(newsVC, animated: true, completion: nil)
    }
}


extension ViewController : NewsViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
        
    }
}


extension ViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
