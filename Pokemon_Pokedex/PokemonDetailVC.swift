//
//  PokemonDetailVC.swift
//  Pokemon_Pokedex
//
//  Created by The Voice on 1/3/16.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    //@IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //@IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var imageLabel: UIImageView!
    
    //@IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    //@IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    
    //@IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    //@IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    
    //@IBOutlet weak var currentEvoLabel: UIImageView!
    @IBOutlet weak var currentEvoLabel: UIImageView!
    
    //@IBOutlet weak var nextEvoLabel: UIImageView!
    @IBOutlet weak var nextEvoLabel: UIImageView!
    
    //@IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var evolutionLabel: UILabel!
    
    
    //@IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    //@IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name.capitalizedString
        
        //Were turning the pokedex ID and turning it into a string.
        let img = UIImage(named: "\(pokemon.pokedexId)")
        
        imageLabel.image = img
        
        currentEvoLabel.image = img
        
        //code that will be called in a later time. 
        //this will call the downloading code we created from 
        //pokemon.swift. Once we download all of the content of the 
        //pokemon, then display the content of the selected pokemon.
        pokemon.downloadPokemonDetails { () -> () in
            
            //this will be called when the download is complete.
            //we need to fufill the closure.
            self.updateUI()
            
        }
    }
    
    //within this function, 
    //will be the ui string variables
    //that will update the latest pokemon info
    func updateUI() {
        //
        descriptionLabel.text = pokemon.description
        typeLabel.text = pokemon.type
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        pokedexLabel.text = "\(pokemon.pokedexId)"
        weightLabel.text = pokemon.weight
        baseAttackLabel.text = pokemon.attack
        
        //if we don't have a pokemon that evolves,
        //display only the current evo pokemon that has
        //been selected from the collection view.
//        if pokemon.nextEvolutionId == "" {
//            evolutionLabel.text = "No Evolution"
//            nextEvoLabel.hidden = true
//        }
        
 //       else{
            nextEvoLabel.hidden = false
            //grab the string id
            //next nextEvolutionId has turned into a stringiD
            nextEvoLabel.image = UIImage(named: pokemon.nextEvolutionId)
            //Now we have to take into considerations for pokemons that evolve
            //but does not require a level up (i.e using a thunder stone on pickachu)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
        
            if pokemon.nextEvolutionLvl != ""{
                str += " -LVL \(pokemon.nextEvolutionLvl)"
            }
//        }
    }
    
    @IBAction func `return`(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }



    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
}