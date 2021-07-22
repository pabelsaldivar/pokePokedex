//
//  LoginInteractor.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import Foundation
import Firebase

final class LoginInteractor {
}

// MARK: - Extensions -

extension LoginInteractor: LoginInteractorInterface {
    func validate(user: String?, password: String?) -> Result<(email: String, password: String), Error> {
        guard let user = user, !user.isEmpty else {
            return .failure(GenericError.emptyUser)
        }
        if !user.isEmail {
            return .failure(GenericError.emptyUser)
        }
        guard let password = password, !password.isEmpty else {
            return.failure(GenericError.emptyPasword)
        }
        return .success((email: user, password: password))
    }
    
    func login(user email: String, by password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user?.user.uid ?? ""))
            }
        }
    }
}
