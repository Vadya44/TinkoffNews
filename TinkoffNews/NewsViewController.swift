//
//  NewsViewController.swift
//  TinkoffNews
//
//  Created by Вадим Гатауллин on 09/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, AlertDisplayer {
    @IBOutlet weak var titleItem: UINavigationItem!
    @IBOutlet weak var newsTextView: UITextView!
    
    var news : News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleItem.title = news?.title
        
        let urlRequest = URLRequest(url: URL(string : "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticle?urlSlug=\(news!.slug)")!)
        let session = URLSession.shared
    
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    let title = "Warning"
                    let action = UIAlertAction(title: "OK", style: .default)
                    self.displayAlert(with: title , message: "It's a connection problems.", actions: [action])
                    return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(NewsText.self, from: data) else {
                let title = "Warning"
                let action = UIAlertAction(title: "OK", style: .default)
                self.displayAlert(with: title , message: "It's a decode problems.", actions: [action])
                return
            }
            DispatchQueue.main.async {
                self.displayText(text: decodedResponse.response.text)
            }

        }).resume()
    }
    
    func displayText(text : String) {
        self.newsTextView.text = text
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
