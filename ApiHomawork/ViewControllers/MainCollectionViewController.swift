//
//  MainCollectionViewController.swift
//  ApiHomawork
//
//  Created by MAcbook on 21.12.2022.
//

import UIKit

private let reuseIdentifier = "Cell"


enum ButtonsForCells: String, CaseIterable {
    case hello = "Hello"
    case goodbye = "Bye"
    case postRequestWithDict = "POST RQST with Dict"
    case postRequestWithModel = "POST RQST with Model"
}

class MainCollectionViewController: UICollectionViewController {

    private let buttonsForCells = ButtonsForCells.allCases

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        buttonsForCells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? UserActionCell else {
            return UICollectionViewCell()
        }
    
        cell.buttonsLabel.text = buttonsForCells[indexPath.item].rawValue
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = buttonsForCells[indexPath.item]
        
        switch userAction {
        case .hello:
            //helloButtonPressed()
            performSegue(withIdentifier: "hello", sender: nil)
        case .goodbye:
            //byeButtonPressed()
            performSegue(withIdentifier: "bye", sender: nil)
        case .postRequestWithDict:
            postRequestWithDict()
        case .postRequestWithModel:
            postRequestWithModel()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hello" {
            guard let helloVC = segue.destination as? HelloViewController else { return }
            helloVC.fetchHello()
        }
        else if segue.identifier == "bye" {
            guard let byeVC = segue.destination as? ByeViewController else { return }
            byeVC.fetchBye()
        }
            
    }
    
    
    // MARK: - Private Methods
    private func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Success",
                message: "You can see the results in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "You can see error in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

// MARK: - Methods

extension MainCollectionViewController {
    private func helloButtonPressed() {
        guard let url = URL(string: Link.helloURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
            print(error?.localizedDescription ?? "No error description")
            return
        }
            do {
                let helloButton = try JSONDecoder().decode(Purple.self, from: data)
                print(helloButton)
                self?.successAlert()
            } catch let error {
                print(error)
                self?.failedAlert()
            }
            
    }.resume()
            
    }
    
    private func byeButtonPressed() {
        guard let url = URL(string: Link.byeURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
            print(error?.localizedDescription ?? "No error description")
            return
        }
            do {
                let byeButton = try JSONDecoder().decode(RickAndMorty.self, from: data)
                print(byeButton)
                self?.successAlert()
            } catch let error {
                print(error)
                self?.failedAlert()
            }
            
    }.resume()
    }
    
    private func postRequestWithDict() {
        let course = [
            "name": "Alisha",
            "age": "24",
            "education": "master",
            "family": "single"
        ]
        
        NetworkManager.shared.postRequest(with: course, from: Link.postRequest.rawValue) { [weak self] result in
            switch result {
                
            case .success(let json):
                print(json)
                self?.successAlert()
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
    }
    
    private func postRequestWithModel() {
        
        let course = Purple(
            activity: "Moaning",
            type: "Key",
            key: "444")
        
        NetworkManager.shared.postRequest2(with: course, from: Link.postRequest.rawValue) { [weak self] result in
            switch result{
            case .success(let course):
                print(course)
                self?.successAlert()
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
        
    }
    
}
