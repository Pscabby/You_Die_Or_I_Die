//
//  ChoseGame.swift
//  FinalGame
//
//  Created by Abby on 2023/6/10.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChoseGame: Identifiable, Codable {
    @DocumentID var id:String?
    var Myindex = 0
    var Oppindex = 0
    var Answer = 5
    var isEnd = false
    var turn = "One"
    
    mutating func randomFurit(turn : String) {
        let number = Int.random(in: 0...15)
        let db = Firestore.firestore()
        let chose = ChoseGame(Answer: number,turn:turn)
        do{
            try db.collection("Game3").document(turn).setData(from: chose)
        } catch{
            print(error)
        }
    }
    
    mutating func ModifyMyIndex(Myindex:Int,turn:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game3").document(turn)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var chose = try? document.data(as: ChoseGame.self)
            else{
                return
            }
            chose.Myindex = Myindex
            do{
                try documentReference.setData(from: chose)
            }catch{
                print(error)
            }
        }
    }
    mutating func ModifyOppIndex(Oppindex:Int,turn:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game3").document(turn)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var chose = try? document.data(as: ChoseGame.self)
            else{
                return
            }
            chose.Oppindex = Oppindex
            do{
                try documentReference.setData(from: chose)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func SomeoneWin(turn:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game3").document(turn)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var chose = try? document.data(as: ChoseGame.self)
            else{
                return
            }
            chose.isEnd = true
            do{
                try documentReference.setData(from: chose)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func fetchGame3(turn:String, completion: @escaping (ChoseGame?) -> Void){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game3").document(turn)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var chose = try? document.data(as: ChoseGame.self)
            else{
                completion(nil)
                return
            }
            completion(chose)
        }
    }
}
