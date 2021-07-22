//
//  Interfaces.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.
//

protocol ViewInterface: class {
}

extension ViewInterface {
}

protocol InteractorInterface: class {
}

extension InteractorInterface {
}

protocol PresenterInterface: class {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func viewWillDisappear(animated: Bool)
    func viewDidDisappear(animated: Bool)
}

extension PresenterInterface {

    func viewDidLoad() {
        fatalError("Implementation pending...")
    }

    func viewWillAppear(animated: Bool) {
        fatalError("Implementation pending...")
    }

    func viewDidAppear(animated: Bool) {
        fatalError("Implementation pending...")
    }

    func viewWillDisappear(animated: Bool) {
        fatalError("Implementation pending...")
    }

    func viewDidDisappear(animated: Bool) {
        fatalError("Implementation pending...")
    }

}

