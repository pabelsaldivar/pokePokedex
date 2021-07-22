//
//  FavouritesViewController.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit
import NVActivityIndicatorView

final class FavouritesViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: FavouritesPresenterInterface!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var activityIndicator: NVActivityIndicatorView!
    var dataSource: [PokemonModel] = []
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.fetchPokemons()
    }
    
    func configureView() {
        activityIndicator = NVActivityIndicatorView(frame: (self.view.frame), type: .ballRotateChase, color: .white, padding: 80.0)
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(activityIndicator)
    }
    
    func updateView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
	
}

// MARK: - Extensions -

extension FavouritesViewController: FavouritesViewInterface {
    func show(_ error: Error) {
        let title = "Ooh oh! "
        let message = error.localizedDescription
        let settingsActionTitle = "Entendido"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: settingsActionTitle, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(goToSettings)
        self.present(alert, animated: true)
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func favourites(didFinishToFetch pokemons: [PokemonModel]) {
        dataSource = pokemons
        updateView()
    }
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionViewCell", for: indexPath) as! PokemonCollectionViewCell
        cell.pokemon = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.collectionView.frame.width / 2) - 32)
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = dataSource[indexPath.row]
        presenter.navigate(to: .detail(pokemon: pokemon))
    }
}

extension FavouritesViewController: PokemonViewDelegate {
    func pokemonController(didChangefavourite pokemon: PokemonModel) {
        presenter.fetchPokemons()
    }
}
