//
//  DashboardViewController.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 21/07/21.

import UIKit
import Alamofire
import FirebaseAuth
import CoreData
import NVActivityIndicatorView

final class DashboardViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: DashboardPresenterInterface!
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
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
    
    func updateView(_ locally: Bool = true) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.infoLabel.text = locally ? "Listo!, ahora estamos mostrando los datos consultados de la base de datos local de la app" : " Si deseas ver la misma lista haciendo la consulta de la base de datos local, sal y vuelve a ingresar a esta pantalla"
        }
    }
}

// MARK: - Extensions -

extension DashboardViewController: DashboardViewInterface {
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
    
    func dashboard(didFinishToFetch pokemons: [PokemonModel], locally: Bool) {
        dataSource = pokemons
        updateView(locally)
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension DashboardViewController: PokemonViewDelegate {
    func pokemonController(didChangefavourite pokemon: PokemonModel) {
        presenter.fetchPokemons()
    }
}
