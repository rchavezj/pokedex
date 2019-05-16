//
//  PokeCell.swift
//  Pokemon_Pokedex
//
//  Created by The Voice on 12/30/15.
//  Copyright © 2015 Appfish. All rights reserved.
//
//  creating custom cells
//
//  custom classes for your views

//note --> its always important to make a seperate 
//class file for every view feature in your controller.

import UIKit

class PokeCell: UICollectionViewCell {
    //these outlets are connected to the ui inside of 
    //the first view controller. 
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //To store a pokemon object, we need to have
    //an actual class for each cell in the data.
    //It also prevents copying data for the description 
    //on each pokemon.
    var pokemon: Pokemon!
    
    //So 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    //way to assign a cell
    func configureCell (pokemon: Pokemon){
        self.pokemon = pokemon
        
        //name label for each pokemon
        //since inside the csv file every pokemons name
        //is not capitalized, for pretty format we cap them
        nameLbl.text = self.pokemon.name.capitalizedString
        
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
        
    }
    
}
