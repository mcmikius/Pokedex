

import FluentSQLite
import Vapor

/// Controllers querying and storing new Pokedex entries.
final class PokemonController {
  /// Lists all known pokemon in our pokedex.
  func index(_ req: Request) throws -> Future<[Pokemon]> {
    return Pokemon.query(on: req).all()
  }
  
  /// Stores a newly discovered pokemon in our pokedex.
  func create(_ req: Request, _ newPokemon: Pokemon) throws -> Future<Pokemon> {
    /// Check to see if the pokemon already exists
    return Pokemon.query(on: req).filter(\.name == newPokemon.name).count().flatMap { count -> Future<Bool> in
        /// Ensure number of Pokemon with the same name is zero
        guard count == 0 else {
          throw Abort(.badRequest, reason: "You already caught \(newPokemon.name).")
        }
          
        /// Check if the pokemon is real. This will throw an error aborting
        /// the request if the pokemon is not real.
        return try req.make(PokeAPI.self).verifyName(newPokemon.name, on: req)
      }.flatMap { nameVerified -> Future<Pokemon> in
        /// Ensure the name verification returned true, or throw an error
        guard nameVerified else {
          throw Abort(.badRequest, reason: "Invalid Pokemon \(newPokemon.name).")
        }
        
        /// Save the new Pokemon
        return newPokemon.save(on: req)
    }
  }
}
