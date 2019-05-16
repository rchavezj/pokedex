//
//  Pokemon.swift
//  Pokemon_Pokedex
//
//  Everything within this file will be provided with the given data 
//  to find a pokemons name and the number its listed inside the pokedex parse data.



import Foundation

import Alamofire

class Pokemon {
    
    //making the name a string type
    //to make reference of every thing within the csv file.
    private var _name: String!
    
    //making the name a int (pokedexId) type
    //to make reference of every thing within the csv file.
    private var _pokedexId: Int!
    
    //making the name a string (description) type
    //to make reference of every thing within the csv file.
    private var _description: String!
    
    //making the name a string (type) type
    //to make reference of every thing within the csv file.
    private var _type: String!
    
    //making the name a string (defense) type
    //to make reference of every thing within the csv file.
    private var _defense: String!
    
    //making the name a string (height) type
    //to make reference of every thing within the csv file.
    private var _height: String!
    
    //making the name a string (weight) type
    //to make reference of every thing within the csv file.
    private var _weight: String!
    
    //making the name a string (attack) type
    //to make reference of every thing within the csv file.
    private var _attack: String!
    
    //making the name a string (nextEvolutionText) type
    //to make reference of every thing within the csv file.
    private var _nextEvoluationTxt: String!
    
    //awesomness
    private var _nextEvolutionId: String!
    
    private var _nextEvolutionLvl: String!
    
    //
    private var _pokemonUrl: String!
    
    
    
    
    
    
    var nextEvolutionLvl: String {
        get{
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    
    var nextEvolutionTxt: String {
        if _nextEvoluationTxt == nil {
            _nextEvoluationTxt = ""
        }
        return _nextEvoluationTxt
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    //
    var description: String {
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }

    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    //constructors for the name and number inside the pokedex.
    //pokedex is a fancy way to word it out for the programmer
    //since everything will be referenced inside the csv file 
    //that was provided from github
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    //"/api/v1/pokemon/1/"
    
    //initializer to pass in a pokemon object 
    //with an id to find a pokemon. 
    //example --> (bulbasaur, 1).
    init(name: String , pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        //enjecting the base of the url.
        //enjecting the pokemon into the url.
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    //Download is a syncrhonous, we won't know when the
    //download is complete. Lets say i click on a pokemon
    //and question my self going into the next view controller
    //screen..."am I expected the details of the pokemon instantly?"
    //its not going to be instantly and we have to make sure the view controller
    //has to wait until the view controller is complete.
    func downloadPokemonDetails(completed: DownloadComplete){
        
        //obtaining the url data thats inside the pokedexId.
        let url = NSURL(string: _pokemonUrl)!
        
        //make a request (get) to obtain data from pokeapi
        //responseJSON tells the user when the download is complete.
        //after the download is complete. run everything thats inside the curly braces (closure).
        Alamofire.request(.GET, url).responseJSON{ response in
            
            //After the alamo request is done, run this code.
            let result = response.result
            
            //succesfully having data from the pokeapi
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                //Now we are grabing the outletvariable from the main controller
                //equals to the downloaded data on the weight of the pokemon.
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                
                print(self._height)
                
                print(self._attack)
                
                print(self._defense)
            
                //where checking to see how many types the pokemon has for its data.
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0{
                    
                    //grab the first type within the type array. and the name property.
                    if let name = types[0]["name"]{
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                }
                else {
                    self._type = ""
                }
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0{
                    
                    if let url = descArr[0]["resource_uri"] {
                        //make a reqest and download the file. 
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            //whether the request success/fails, then were gonna call completed.
                            completed()
                        }
                    }
                }else{
                    self._description = ""
                }
                //at least one pokemon.
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>]
                    where evolutions.count > 0 {
                        
                    //The name as the property.
                    //we also need to get rid of all of the mega evolutions
                    //inside the evolutions.
                    if let to = evolutions[0]["to"] as? String {
                        
                        //Can't support mega pokemon.
                        // if condition to get rid of the mega pokemon.
                        if to.rangeOfString("mega") == nil {
                            
                            //we need to find the mega pokemon's uri in order to find 
                            //these absurd pokemon's.
                            if let uri = evolutions[0]["resourse_uri"] as? String {
                                
                                //create a new string from an existing /api/v1/pokemon/
                                //in order to get rid of the mega evolution pokemons.
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/",
                                    withString: "")
                                
                                //same methods as mentioned above but to get rid of the last forward slash.
                                let num = newStr.stringByReplacingOccurrencesOfString("/",
                                    withString: "")
                                
                                //we need to store the if
                                self._nextEvolutionId = num
                                self._nextEvoluationTxt = to
                                
                                //In order for a pokemon to evolve, it's important
                                //to make sure that the 
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                print(self._nextEvolutionId)
                                print(self._nextEvoluationTxt)
                                print(self._nextEvolutionLvl)
                            }
                        }
                    }
                }
            }
        }
    }
}











