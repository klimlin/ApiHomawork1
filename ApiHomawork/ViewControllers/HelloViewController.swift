//
//  HelloViewController.swift
//  ApiHomawork
//
//  Created by MAcbook on 25.12.2022.
//

import UIKit

class HelloViewController: UIViewController {

    private var helloFull: Purple = Purple(activity: "", type: "", key: "")
    
    @IBOutlet var helloLabel: UILabel!
    
     func helloView() {
        helloLabel.text = "What to do?\n\(helloFull.activity)"
    }

}

// MARK: - Network

extension HelloViewController {
    func fetchHello() {
        guard let url = URL(string: Link.helloURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                self?.helloFull = try JSONDecoder().decode(Purple.self, from: data)
                DispatchQueue.main.async {
                    self?.helloView()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
        
}

