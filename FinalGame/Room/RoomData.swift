//
//  RoomData.swift
//  FinalGame
//
//  Created by Abby on 2023/6/7.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct rooms : Identifiable,Codable{
    @DocumentID var id:String?
    var player = [""]
    var gameState = ""
    var Player1Ok = false
    var Player2Ok = false
    var Player1Ready = false
    var Player2Ready = false
    var Player1Score = 0
    var Player2Score = 0
    
    mutating func CreatRoom(playerID : String) -> String{
        let db = Firestore.firestore()
        
        let room = rooms(player: [playerID], gameState: "waiting")
        var RoomID = ""
        do {
            let documentReference = try db.collection("Rooms").addDocument(from: room)
            print(documentReference.documentID)
            RoomID = documentReference.documentID
        } catch {
            print(error)
        }
        return RoomID
    }
    
    mutating func EnterRoom(playerID : String, RoomID : String) {
        let db = Firestore.firestore()
        let documentReference = db.collection("Rooms").document(RoomID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var room = try? document.data(as: rooms.self)
            else{
                return
            }
            room.player.append(playerID)
            do{
                try documentReference.setData(from: room)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func Ready1Room(RoomID : String, ok : Bool) {
        let db = Firestore.firestore()
        let documentReference = db.collection("Rooms").document(RoomID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var room = try? document.data(as: rooms.self)
            else{
                return
            }
            room.Player1Ok = ok
            do{
                try documentReference.setData(from: room)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func Ready2Room(RoomID : String, ok : Bool) {
        let db = Firestore.firestore()
        let documentReference = db.collection("Rooms").document(RoomID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var room = try? document.data(as: rooms.self)
            else{
                return
            }
            room.Player2Ok = ok
            do{
                try documentReference.setData(from: room)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func GameReady1(RoomID : String, ok : Bool) {
        let db = Firestore.firestore()
        let documentReference = db.collection("Rooms").document(RoomID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var room = try? document.data(as: rooms.self)
            else{
                return
            }
            room.Player1Ready = ok
            do{
                try documentReference.setData(from: room)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func GameReady2(RoomID : String, ok : Bool) {
        let db = Firestore.firestore()
        let documentReference = db.collection("Rooms").document(RoomID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var room = try? document.data(as: rooms.self)
            else{
                return
            }
            room.Player2Ready = ok
            do{
                try documentReference.setData(from: room)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func Player1Win(RoomID : String) {
        let db = Firestore.firestore()
        let documentReference = db.collection("Rooms").document(RoomID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var room = try? document.data(as: rooms.self)
            else{
                return
            }
            room.Player1Score += 1
            do{
                try documentReference.setData(from: room)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func Player2Win(RoomID : String) {
        let db = Firestore.firestore()
        let documentReference = db.collection("Rooms").document(RoomID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var room = try? document.data(as: rooms.self)
            else{
                return
            }
            room.Player2Score += 1
            do{
                try documentReference.setData(from: room)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func StartRoom(RoomID : String) {
        let db = Firestore.firestore()
        let documentReference = db.collection("Rooms").document(RoomID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var room = try? document.data(as: rooms.self)
            else{
                return
            }
            room.gameState = "playing"
            do{
                try documentReference.setData(from: room)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func fetchRoom(RoomID : String, completion: @escaping (rooms?) -> Void){
        let db = Firestore.firestore()
        let documentReference = db.collection("Rooms").document(RoomID)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  let room = try? document.data(as: rooms.self)
            else{
                completion(nil)
                return
            }
            completion(room)
        }
    }
    
}
