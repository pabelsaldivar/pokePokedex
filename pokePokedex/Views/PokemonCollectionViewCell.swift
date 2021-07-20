//
//  PokemonCollectionViewCell.swift
//  pokePokedex
//
//  Created by Jonathan Pabel Saldivar Mendoza on 30/04/21.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var pokemon: PokemonModel? {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boxView.layer.cornerRadius = 12
        boxView.layer.masksToBounds = false
        boxView.layer.shadowColor = UIColor.black.cgColor
        boxView.layer.shadowOffset = CGSize(width: 0, height: 2)
        boxView.layer.shadowRadius = 3
        boxView.layer.shadowOpacity = 0.30
    }
    
    func configureCell() {
        if let pokemon = pokemon {
            nameLabel.text = pokemon.name.capitalized
            imageView.image = UIImage(named: pokemon.imageName)
            let value = pokemon.url.split(separator: "/").last
            let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(value!).png"
            imageView.downloadedFrom(link: url, contentMode: .scaleAspectFill)
        }
    }
    
}
