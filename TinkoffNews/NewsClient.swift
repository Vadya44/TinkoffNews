//
//  NewClient.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import Foundation


class NewsClient {
    private lazy var baseURL: URL = {
        return URL(string: "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticles?")!
    }()
    
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchModerators(page: Int, completion: @escaping (Result<PagedModeratorResponse, DataResponseError>) -> Void) {
        
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent("pageSize=20&pageOffset=\(page)"))
        
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(DataResponseError.network))
                    return
            }
            
            
            guard let decodedResponse = try? JSONDecoder().decode(PagedModeratorResponse.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            
            
            completion(Result.success(decodedResponse))
        }).resume()
    }
}

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
