//
//  BoomGame.swift
//  FinalGame
//
//  Created by Abby on 2023/5/28.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BoomGame:Codable,Identifiable{
    @DocumentID var id:String?
    var MyCount:Int = 0
    var OppCount:Int = 0
    var MyScale:Double = 0.8
    var Oppscale:Double = 0.8
    var isEnd:Bool = false
    
    mutating func ReGame2(){
        let db = Firestore.firestore()
        let boom  = BoomGame()
        do{
            try db.collection("Game2").document("Boom").setData(from: boom)
        } catch{
            print(error)
        }
    }
    
    mutating func SetGame2(Mycount:Int,Oppcount:Int,Myscale:Double,Oppscale:Double){
        let db = Firestore.firestore()
        let boom = BoomGame(MyCount: Mycount,OppCount: Oppcount,MyScale: Myscale,Oppscale: Oppscale)
        do{
            try db.collection("Game2").document("Boom").setData(from: boom)
        } catch{
            print(error)
        }
    }
    
    mutating func SetMyGame2(Mycount:Int,Oppscale:Double){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game2").document("Boom")
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var boom = try? document.data(as: BoomGame.self)
            else{
                return
            }
            boom.MyCount = Mycount
            boom.Oppscale = Oppscale
            do{
                try documentReference.setData(from: boom)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func SetOppGame2(Oppcount:Int,Myscale:Double){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game2").document("Boom")
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var boom = try? document.data(as: BoomGame.self)
            else{
                return
            }
            boom.OppCount = Oppcount
            boom.MyScale = Myscale
            do{
                try documentReference.setData(from: boom)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func SomeoneWin() {
        let db = Firestore.firestore()
        let documentReference = db.collection("Game2").document("Boom")
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var boom = try? document.data(as: BoomGame.self)
            else{
                return
            }
            boom.isEnd = true
            do{
                try documentReference.setData(from: boom)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func fetchGame2(completion: @escaping (BoomGame?) -> Void){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game2").document("Boom")
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var boom = try? document.data(as: BoomGame.self)
            else{
                completion(nil)
                return
            }
            completion(boom)
        }
    }
}
