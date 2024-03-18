//
//  UserViewModel.swift
//  YellowRed
//
//  Created by Krish Mehta on 11/4/23.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var userId: String?
    
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var emailAddress: String = ""
    @Published var emergencyContacts: [EmergencyContact] = []
    @Published var yellowMessage: String = ""
    @Published var redMessage: String = ""
    
    @Published var button: String = ""
    
    private let firestoreManager = FirestoreManager()
    
    func createUser(userId: String, fullName: String, phoneNumber: String, emailAddress: String, affiliation: String, university: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.createUser(userId: userId, fullName: fullName, phoneNumber: phoneNumber, emailAddress: emailAddress, affiliation: affiliation, university: university) { result in
            self.handleResult(result: result, successAction: {
                self.userId = userId
            }, completion: completion)
        }
    }
    
    func updateUser(userId: String, phoneNumber: String, emailAddress: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.updateUser(userId: userId, phoneNumber: phoneNumber, emailAddress: emailAddress) { result in
            self.handleResult(result: result, successAction: {
                DispatchQueue.main.async {
                    self.phoneNumber = phoneNumber
                    self.emailAddress = emailAddress
                }
            }, completion: completion)
        }
    }
    
    func updateEmergencyContacts(userId: String, emergencyContacts: [EmergencyContact], completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.updateEmergencyContacts(userId: userId, emergencyContacts: emergencyContacts) { result in
            self.handleResult(result: result, successAction: {
                DispatchQueue.main.async {
                    self.emergencyContacts = emergencyContacts
                }
            }, completion: completion)
        }
    }
    
    func updateYellowRedMessages(userId: String, yellowMessage: String, redMessage: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.updateYellowRedMessages(userId: userId, yellowMessage: yellowMessage, redMessage: redMessage) { result in
            self.handleResult(result: result, successAction: {
                DispatchQueue.main.async {
                    self.yellowMessage = yellowMessage
                    self.redMessage = redMessage
                }
            }, completion: completion)
        }
    }
    
    func fetchUserData(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.fetchUserData(userId: userId) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.fullName = data["fullName"] as? String ?? ""
                    self.phoneNumber = data["phoneNumber"] as? String ?? ""
                    self.emailAddress = data["emailAddress"] as? String ?? ""
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchEmergencyContacts(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.fetchEmergencyContacts(userId: userId) { result in
            switch result {
            case .success(let contacts):
                DispatchQueue.main.async {
                    self.emergencyContacts = contacts
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchYellowRedMessages(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.fetchYellowRedMessages(userId: userId) { result in
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.yellowMessage = messages.yellowMessage
                    self.redMessage = messages.redMessage
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchButtonData(userId: String, sessionId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.fetchButtonData(userId: userId, sessionId: sessionId) { result in
            switch result {
            case .success(let button):
                DispatchQueue.main.async {
                    self.button = button
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func handleResult(result: Result<Void, Error>, successAction: @escaping () -> Void, completion: @escaping (Result<Void, Error>) -> Void) {
        switch result {
        case .success:
            successAction()
            completion(.success(()))
        case .failure(let error):
            NSLog("Error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

}
