//
//  PlayerData.swift
//  FinalGame
//
//  Created by Abby on 2023/6/7.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct players : Identifiable, Codable{
    @DocumentID var id:String?
    var name = ""
    var currentRoom = ""
    var role = ""
    var isPlayer1 = true
    var mail = ""
    var joinedDate: Date = Date()
    
    mutating func CreatPlayer(name:String){
        let db = Firestore.firestore()
        
        let player = players(name: name, currentRoom: "", role: "bear")
        do {
            let documentReference = try db.collection("Players").addDocument(from: player)
            print(documentReference.documentID)
        } catch {
            print(error)
        }
    }
    
    mutating func EnterRoom(PlayerID : String, RoomID : String, isPlayer1 : Bool){
        let db = Firestore.firestore()
        let documentReference = db.collection("Players").document(PlayerID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var player = try? document.data(as: players.self)
            else{
                return
            }
            player.currentRoom = RoomID
            player.isPlayer1 = isPlayer1
            do{
                try documentReference.setData(from: player)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func ChangeRole(Role : String, PlayerID : String) {
        let db = Firestore.firestore()
        let documentReference = db.collection("Players").document(PlayerID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var player = try? document.data(as: players.self)
            else{
                return
            }
            player.role = Role
            do{
                try documentReference.setData(from: player)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func fetchPlayer(PlayerID : String, completion: @escaping (players?) -> Void){
        let db = Firestore.firestore()
        let documentReference = db.collection("Players").document(PlayerID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  let player = try? document.data(as: players.self)
            else{
                completion(nil)
                return
            }
            completion(player)
        }
    }
}
