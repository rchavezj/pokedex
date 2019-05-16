//
//  ViewController.swift
//  Pokemon_Pokedex
//
//  Created by The Voice on 12/30/15.
//  Copyright © 2015 Appfish. All rights reserved.
//

import UIKit

//import Alamofire

import AVFoundation

//all of these methods are used as protocols inside here. 
//each protocal is a delegate for every feature the user interacts the mobile device.
//The methods of the protocol mark significant events handled or anticipated by the delegating object.

//Inside of our main storyboard,
//we need to work with collection views
//UICollectionViewDataSource --> Responsible for providing the data 
//                               and views required by a collection view.
//
//UICollectionViewDelegate -->   Defines methods that allow you to manage
//                               the selection and highlighting of items 
//                               in a collection view and to perform actions 
//                               on those items.
//

//UICollectionViewDelegateFlowLayout --> Defines methods that let you coordinate
//                                       with a UICollectionViewFlowLayout object 
//                                       to implement a grid-based layout
//
//UISearchBarDelegate -->        This is a protocol that gives us access (blueprints)
//                               for the search bar function calls into the view controller.
class ViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
    @IBOutlet weak var collectionViewers: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //As mentioned earlier for 
    //this file only having the delegates
    //and also the data source, it is vitale
    //we make a global array variable to make
    //a delegate and dataSource.
    // pokemon [] is currently an empty array.
    var pokemon = [Pokemon]()
    //We will have an array in order to make sure
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //we own the data source and delegates under
        //the variable collectionViewers for declaring the protocalls
        collectionViewers.delegate = self
        collectionViewers.dataSource = self
        
        //access to search when the app is loaded
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.Done
    
        initAudio();
        
        //Callbacked from the function 
        //parsePokemonCSV which is within this file.
        parsePokemonCSV()
        
    }
    
    func initAudio() {
        
        let path = NSBundle.mainBundle().pathForResource("pokemonThemeSong", ofType: "mp3")
    
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    //grab the csv file and then parse it.
    //define parse: Analyze (a sentence) into its parts and describe their syntactic roles.
    func parsePokemonCSV() {
        
        //An NSBundle object represents a location in the 
        //file system that groups code and resources that 
        //can be used in a program. In this case, the resource
        //we are obtaining is the csv file. first parameter "pokemon"
        //is the name of the file and second parameter "csv" is the type of file.
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            //proof we have the identity of 
            //the pokemons in the csv file.
            //print(rows)
            
            //We're going into the row and were going into each dictionary which
            //is the name of the pokemon. We are then converting the id into a integer
            for row in rows {
                
                //each row is a dictioncary know
                //as the identifier. 
                let pokeId = Int(row["id"]!)!
                
                //the identifier is the name 
                //within the row of the csv file.
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                
                pokemon.append(poke)
            }
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    //Everything that has the name collectionView is all part of the protocols
    //that was given from the new controller names we typed at the view controller.
    
    //???
    
    //format the data cell and returns it
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //Remember to set the identifier of the collection view call PokeCell
        //So we can call the string and return the cell which possibly has data within it.
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
          
            //So what we have here is a collection view of pokemons 
            //from calling the function Pokemon (name, pokeId) from the
            //file Pokemon.swift. 
            //let pokemon = Pokemon(name: "Test", pokedexId: indexPath.row)
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            }
            else{
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
    
        }else{
            
            //Object presents the content for a single data
            //item when that item is within the collection view’s visible bounds.
            return UICollectionViewCell()
            
        }
    }

    //This funciton is called back for whenever the user taps on 
    //one of the items. What we want to do after pressiong on the collection
    //is to be able to seque into another view controller. For this case we want
    //to transition into PokemonDetailVC.swift.
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        //Since we can find the pokemon either through a filter
        //using the search bar tab, or from using the original array of collection
        //where the user scrolls down the collection view without using the search bar. 
        //The way we appproch solving this problem is by going into SearchMode boolean.
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        }
        else {
            poke = pokemon [indexPath.row]
        }
        //print(poke.name)
        //print(poke.name)
        //print(poke.name)
        //this api function gets us to segue to the next view controller identifier. 
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)        
    }
    
    //returns number of items in a section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemon.count 
        }
        
        return pokemon.count;
    }
    
    //size of the grid
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //Photo app landscape. 
        return CGSizeMake(105, 105)
    }
    
    //number of sections for a specific type of pokemon.
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func musicButton(sender: UIButton!) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
        }
        else{
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            //grabb an element in the name of zero. 
            //inside the array.
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            
            collectionViewers.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //If we go into the segue "PokemonDetailVC", name of the identifier, then
        //execute everything within the function.
        if segue.identifier == "PokemonDetailVC" {
            //if the segus is being loaded by the identifier "PokemonDetailVC",
            //strore the new viewController into the variable detailsVC which will
            //cast the new class we made called PokemonDetailVC.
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                //poke object that has been casted by the sender.
                if let poke = sender as? Pokemon {
                    //set detailsVC as poke.
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}























