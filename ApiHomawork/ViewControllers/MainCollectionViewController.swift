//
//  MainCollectionViewController.swift
//  ApiHomawork
//
//  Created by MAcbook on 21.12.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

enum Link: String {
    case helloURL = "https://www.boredapi.com/api/activity"
    case byeURL = "https://rickandmortyapi.com/api/character/108"
}

enum ButtonsForCells: String, CaseIterable {
    case hello = "Hello"
    case goodbye = "Bye"
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
            helloButtonPressed()
        case .goodbye:
            byeButtonPressed()
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
    
}
