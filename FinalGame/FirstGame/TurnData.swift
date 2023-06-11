//
//  TurnData.swift
//  FinalGame
//
//  Created by Abby on 2023/5/31.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TurnData:Identifiable,Codable {
    @DocumentID var id:String?
    var Myturn = "One"
    
    mutating func ChangeTurn(turn:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game1").document("Turn")
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var Turn = try? document.data(as: TurnData.self)
            else{
                return
            }
            Turn.Myturn = turn
            do{
                try documentReference.setData(from: Turn)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func fetchTurn(completion: @escaping (TurnData?) -> Void){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game1").document("Turn")
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var Turn = try? document.data(as: TurnData.self)
            else{
                completion(nil)
                return
            }
            completion(Turn)
        }
    }
}
