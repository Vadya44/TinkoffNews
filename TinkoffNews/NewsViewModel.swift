//
//  NewsViewModel.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import Foundation
import CoreData

protocol NewsViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
    func writeNewData(with news : [News])
    func getData() -> [News]
    func refreshData()
}

final class NewsViewModel {
    private weak var delegate: NewsViewModelDelegate?
    
    private var news : [News] = []
    private var currentPage = 0
    private var total = 0
    private var isFetchInProgress = false
    
    let client = NewsClient()
    
    init(delegate: NewsViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return news.count
    }
    
    func news(at index: Int) -> News {
        return news[index]
    }
    
    func fillFromCD() {
        // Не хватило времени зарешать красиво кейс с кордатой, так как про лабораторную узнал за день до дедлайна)))
        // Пы сы : Думал, что только контест надо и затерялся во временной петле до последнего дня
        if let data = delegate?.getData() {
            news = data
        }
        total = news.count
        delegate?.refreshData()
    }
    
    func fetchNews() {
        
        guard !isFetchInProgress else {
            return
        }
            
        isFetchInProgress = true
        
        client.fetchNews(page: currentPage) { result in
            switch result {
            
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            
            case .success(let response):
                DispatchQueue.main.async {
                    
                    self.isFetchInProgress = false
                
                    self.total = response.response.total
                    self.news.append(contentsOf: response.response.news)
                    
                    self.delegate?.writeNewData(with: response.response.news)
                    
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.response.news)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
                self.currentPage += 1

            }
        }
    }
    
    private func calculateIndexPathsToReload(from newNews: [News]) -> [IndexPath] {
        let startIndex = news.count - newNews.count
        let endIndex = startIndex + newNews.count
        return (startIndex ..< endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
