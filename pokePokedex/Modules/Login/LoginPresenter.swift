//
//  LoginPresenter.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.

import UIKit

final class LoginPresenter {

    // MARK: - Private properties -

    private unowned let _view: LoginViewInterface
    private let _wireframe: LoginWireframeInterface
    private let _interactor: LoginInteractorInterface

    // MARK: - Lifecycle -

    init(wireframe: LoginWireframeInterface, view: LoginViewInterface, interactor: LoginInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension LoginPresenter: LoginPresenterInterface {
    func navigate(to option: LoginNavigationOption) {
        _wireframe.navigate(to: option)
    }
    
    func validate(email: String?, password: String?) {
        let result = _interactor.validate(user: email, password: password)
        switch result {
        case .success(let userData):
            _view.login(didFinishToValidate: userData)
        case .failure(let error):
            _view.show(error)
        }
    }
    
    func login(user email: String, by password: String) {
        _view.showLoader()
        _interactor.login(user: email, by: password) { result in
            self._view.hideLoader()
            switch result {
            case .success(let token):
                self._view.login(didFinishToLogin: token)
            case .failure(let error):
                self._view.show(error)
            }
        }
    }
}
