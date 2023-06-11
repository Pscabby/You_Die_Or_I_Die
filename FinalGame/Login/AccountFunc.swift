//
//  AccountFunc.swift
//  FinalGame
//
//  Created by Abby on 2023/5/20.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

func AccountSignUp(mail: String, password: String, completion: @escaping(Result<String, NSError>) -> Void) {
    Auth.auth().createUser(withEmail: mail, password: password) { result, error in
        guard let user = result?.user,
              error == nil else {
            if let error = error{
                let err = error as NSError
                completion(.failure(err))
            }
            print(error?.localizedDescription)
            return
        }
        completion(.success(user.uid))
    }
}

func AccountLogin(mail: String,password: String,completion: @escaping(Result<String, NSError>) -> Void){
    Auth.auth().signIn(withEmail: mail, password: password){ result, error in
        guard error == nil else{
            if let error = error{
                let err = error as NSError
                completion(.failure(err))
            }
            return
        }
        if let uid = result?.user.uid{
            completion(.success(uid))
        }
    }
}

//判斷user是否已經登入
func AccounIsLogin() -> Bool{
    if let user = Auth.auth().currentUser {
        print("\(user.uid) login")
        return true
    } else {
        print("not login")
        return false
    }
}

func AccountLogOut() {
    do {
        try Auth.auth().signOut()
    } catch {
        print(error)
    }
}

func AccountID() -> String {
    if let user = Auth.auth().currentUser {
        return user.uid
    } else {
        print("not login")
        return ""
    }
}
