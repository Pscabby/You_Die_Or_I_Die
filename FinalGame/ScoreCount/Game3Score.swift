//
//  Game1Score.swift
//  FinalGame
//
//  Created by Abby on 2023/5/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game3Score: Codable,Identifiable{
    @DocumentID var id:String?
    var MyScore = 0
    var OppScore = 0
    
    mutating func Addscore(my:Int, opp:Int){
        let db = Firestore.firestore()
        let score  = Game3Score(MyScore: my,OppScore: opp)
        do{
            try db.collection("Game3").document("Score").setData(from: score)
        } catch{
            print(error)
        }
    }
    
    mutating func DeleteScore(){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game3").document("Score")
        documentReference.delete()
    }
    
    mutating func ReScore(){
        let db = Firestore.firestore()
        let score  = Game3Score()
        do{
            try db.collection("Game3").document("Score").setData(from: score)
        } catch{
            print(error)
        }
    }
    
    mutating func fetchScore(completion: @escaping (Game3Score?) -> Void){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game3").document("Score")
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var score = try? document.data(as: Game3Score.self)
            else{
                completion(nil)
                return
            }
            completion(score)
        }
    }
}
