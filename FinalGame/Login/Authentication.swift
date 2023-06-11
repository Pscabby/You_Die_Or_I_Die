//
//  JoinTheRoom.swift
//  FinalGame
//
//  Created by Abby on 2023/5/17.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class Authentication : ObservableObject{
    @AppStorage("userMail") var userMail: Data?
    @AppStorage("userPassword") var userPassword: Data?
    @Published var User : players = players()
    @Published var isLogin: Bool = false
    @Published var showAltert: Bool = false
    @Published var alertTitle : String = ""
    
    func getLoginState() {
        if let userMail = userMail,
           let userPassword = userPassword {
            let decoder = JSONDecoder()
            if let decodeMail = try? decoder.decode(String.self, from: userMail),
               let decodePassWord = try? decoder.decode(String.self, from: userPassword) {
                login(mail: decodeMail, password: decodePassWord)
            }
        }
    }
    
    func saveLoginState(mail: String, password: String){
        let encoder = JSONEncoder()
        if let encodeMail = try? encoder.encode(mail),
           let encodePassword = try? encoder.encode(password) {
            userMail = encodeMail
            userPassword = encodePassword
        }
    }
    
    func signUp(name: String, mail: String, password: String) {
        AccountSignUp(mail: mail, password: password) { result in
            switch result {
            case.failure(let err):
                switch err.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    self.alertTitle = "此信箱已註冊過！"
                case AuthErrorCode.networkError.rawValue:
                    self.alertTitle = "NetWork Problem!"
                default:
                    self.alertTitle = "Unknown error: \(err.localizedDescription)"
                }
                self.showAltert = true
                return
                
            case .success(let id):
                print("HiA: \(id)")
                self.creatUser(uid: id, mail: mail, name: name)
                self.login(mail: mail, password: password)
            }
        }
    }
    
    func creatUser(uid: String, mail: String, name: String) {
        let db = Firestore.firestore()
        User.id = uid
        User.name = name
        User.mail = mail
        User.joinedDate = Date()
        do {
            try db.collection("Players").document(self.User.id!).setData(from: User)
        } catch {
            print(error)
        }
    }
    
    func login(mail: String, password: String){
        AccountLogin(mail: mail, password: password) { result in
            switch result{
            case .failure(let err):
                switch err.code{
                case AuthErrorCode.wrongPassword.rawValue:
                    self.alertTitle = "密碼錯誤"
                case AuthErrorCode.invalidEmail.rawValue:
                    self.alertTitle = "無此信箱"
                case AuthErrorCode.networkError.rawValue:
                    self.alertTitle = "網路連線錯誤"
                default:
                    self.alertTitle = "UnKnown error: \(err.localizedDescription)"
                }
                self.showAltert = true
                return
                
            case .success(let id):
                print("HiB: \(id)")
                if AccounIsLogin() {
                    self.isLogin = true
                }
                
            }
        }
    }
    
    func LogOut() {
        AccountLogOut()
        if !AccounIsLogin() {
            self.isLogin = false
        } else {
            self.alertTitle = "登出失敗"
            self.showAltert = true
        }
    }
    
    func setUserData() {
        let db = Firestore.firestore()
        do{
            try db.collection("Players").document(User.id!).setData(from: User)
        } catch {
            print(error)
        }
    }
    
}
