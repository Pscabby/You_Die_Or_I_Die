//
//  CountGame.swift
//  FinalGame
//
//  Created by Abby on 2023/5/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AppleSetting:Codable,Identifiable,Hashable{
    @DocumentID var id:String?
    var opacity : Double = 0
    var name = "apple"
    var x:CGFloat
    var y:CGFloat
}

struct CountGame: Codable,Identifiable{
    @DocumentID var id:String?
    var count1 = 0
    var count2 = 0
    var count3 = 0
    var count4 = 0
    var MyCount = 0
    var OppCount = 0
    var total = 0
    var turn = "One"
    var iscorrect = false
    var Apple1 = [AppleSetting(name: "",x: 0,y: 0),AppleSetting(x:170,y:-50),AppleSetting(x:210,y:-100),AppleSetting(x:130,y:-100)]
    var Apple2 = [AppleSetting(name: "",x: 0,y: 0),AppleSetting(x:80,y: 10),AppleSetting(x:130,y: -80),AppleSetting(x:30,y: -60),AppleSetting(x:160,y: 0),AppleSetting(x:0,y: 0)]
    var Apple3 = [AppleSetting(name: "",x: 0,y: 0),AppleSetting(x: -80, y: 100),AppleSetting(x: 0, y: 50)]
    var Apple4 = [AppleSetting(name: "",x: 0,y: 0),AppleSetting(x: -90, y: -40),AppleSetting(x: -150, y: -90)]
    
    mutating func randomnumber(){
        count1 = Int.random(in: 0...3)
        count2 = Int.random(in: 0...5)
        count3 = Int.random(in: 0...2)
        count4 = Int.random(in: 0...2)
        total = count1 + count2 + count3 + count4
        print("count1: \(count1)")
        print("count2: \(count2)")
        print("count3: \(count3)")
        print("count4: \(count4)")
        print("total: \(total)")
    }
    
    mutating func ChoseApple(){
        for i in 0...count1{
            Apple1[i].opacity = 1
        }
        for i in 0...count2{
            Apple2[i].opacity = 1
        }
        for i in 0...count3{
            Apple3[i].opacity = 1
        }
        for i in 0...count4{
            Apple4[i].opacity = 1
        }
    }
    
    mutating func UpdateApple(turn:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game1").document(turn)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var count = try? document.data(as: CountGame.self)
            else{
                return
            }
            for i in 0...count.count1{
                count.Apple1[i].opacity = 1
            }
            for i in 0...count.count2{
                count.Apple2[i].opacity = 1
            }
            for i in 0...count.count3{
                count.Apple3[i].opacity = 1
            }
            for i in 0...count.count4{
                count.Apple4[i].opacity = 1
            }
            do{
                try documentReference.setData(from: count)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func creatGame1(count1:Int,count2:Int,count3:Int,count4:Int,total:Int,Mycount:Int,Oppcount:Int) {
        let db = Firestore.firestore()
        let countgame = CountGame(count1: count1,count2: count2,count3: count3,count4: count4,total: total)
        do{
            let documentReference = try db.collection("Game1").addDocument(from: countgame)
            print(documentReference.documentID)
        } catch{
            print(error)
        }
    }
    
    mutating func AddGame1(count1:Int,count2:Int,count3:Int,count4:Int,total:Int,Mycount:Int,Oppcount:Int,turn:String){
        let db = Firestore.firestore()
        let countgame = CountGame(count1: count1,count2: count2,count3: count3,count4: count4,total: total,turn: turn)
        do{
            try db.collection("Game1").document(turn).setData(from: countgame)
        } catch{
            print(error)
        }
    }
    
    mutating func fetchGame1(){
        let db = Firestore.firestore()
        db.collection("Game1").getDocuments { snapshot, error in
            guard let snapshot else {return}
            let Game1 = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: CountGame.self)
            }
            print(Game1)
        }
    }
    
    mutating func ModifyMyCount(ChangeMycount:Int,turn:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game1").document(turn)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var count = try? document.data(as: CountGame.self)
            else{
                return
            }
            count.MyCount = ChangeMycount
            do{
                try documentReference.setData(from: count)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func ModifyOppCount(ChangeOppcount:Int,turn:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game1").document(turn)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var count = try? document.data(as: CountGame.self)
            else{
                return
            }
            count.OppCount = ChangeOppcount
            do{
                try documentReference.setData(from: count)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func ModifyEnd(ChangeEnd:Bool,turn:String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game1").document(turn)
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var count = try? document.data(as: CountGame.self)
            else{
                return
            }
            count.iscorrect = ChangeEnd
            do{
                try documentReference.setData(from: count)
            }catch{
                print(error)
            }
        }
    }
    
    mutating func DeleteCount(turn: String){
        let db = Firestore.firestore()
        let documentReference = db.collection("Game1").document(turn)
        documentReference.delete()
    }
    
    func checkSongChange(turn: String) {
        let db = Firestore.firestore()
        db.collection("Game1").document(turn).addSnapshotListener { snapshot, error in
            guard let snapshot else { return }
            guard let count = try? snapshot.data(as: CountGame.self) else { return }
            print(count)
        }
    }
}

