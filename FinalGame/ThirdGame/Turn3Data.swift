//
//  TurnData.swift
//  FinalGame
//
//  Created by Abby on 2023/5/31.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Turn3Data:Identifiable,Codable {
    @DocumentID var id:String?
    var Myturn = "One"
    
    mutating func ChangeTurn(turn:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game3").document("Turn")
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var Turn = try? document.data(as: Turn3Data.self)
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
    
    mutating func fetchTurn(completion: @escaping (Turn3Data?) -> Void){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game3").document("Turn")
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var Turn = try? document.data(as: Turn3Data.self)
            else{
                completion(nil)
                return
            }
            completion(Turn)
        }
    }
}
