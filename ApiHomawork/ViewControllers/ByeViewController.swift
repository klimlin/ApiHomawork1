//
//  ByeViewController.swift
//  ApiHomawork
//
//  Created by MAcbook on 25.12.2022.
//

import UIKit

class ByeViewController: UIViewController {

    private var byeFull: RickAndMorty = RickAndMorty(name: "", gender: "", type: "", status: "")
    
    @IBOutlet var byeLabel: UILabel!
    func byeView() {
        byeLabel.text = "Who?\n\(byeFull.name), \(byeFull.type), \(byeFull.gender), \(byeFull.status)"
    }

}

// MARK: - Network

extension ByeViewController {
    func fetchBye() {
        guard let url = URL(string: Link.byeURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                self?.byeFull = try JSONDecoder().decode(RickAndMorty.self, from: data)
                DispatchQueue.main.async {
                    self?.byeView()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
        
}


