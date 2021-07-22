//
//  LoginInterfaces.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit

enum LoginNavigationOption {
    case Dashboard
}

protocol LoginWireframeInterface: WireframeInterface {
    func navigate(to option: LoginNavigationOption)
}

protocol LoginViewInterface: ViewInterface {
    func show(_ error:Error)
    func showLoader()
    func hideLoader()
    func login(didFinishToValidate userData:(email: String, password: String))
    func login(didFinishToLogin userToken: String)
}

protocol LoginPresenterInterface: PresenterInterface {
    func navigate(to option: LoginNavigationOption)
    func validate(email: String?, password: String?)
    func login(user email: String, by password: String)
}

protocol LoginInteractorInterface: InteractorInterface {
    func validate(user: String?, password: String?) -> Result<(email: String, password: String), Error>
    func login(user email: String, by password: String, completion: @escaping (Result<String, Error>) -> Void)
}
