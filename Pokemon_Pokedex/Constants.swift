//
//  Constants.swift
//  Pokemon_Pokedex
//
//  So what will have here is something 
//  that will be globally accessable to make sure
//  whenever we want to access the url site, it'll be
//  instantly.
//

import Foundation

let URL_BASE = "http://pokeapi.co"

let URL_POKEMON = "/api/v1/pokemon/"

//We are creating a closire whenever 
//the download is completed. An emtpy closure 
//with empty parameters. 
typealias DownloadComplete = () -> ()
