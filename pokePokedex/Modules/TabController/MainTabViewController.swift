//
//  MainTabViewController.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 22/07/21.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarElements()
    }

    private func configureTabBarElements() {
        let dashboardTabBarItem = UITabBarItem()
        dashboardTabBarItem.image = UIImage(systemName: "heart.fill")
        dashboardTabBarItem.title = "Pokemon"
        let dashboardWireframe = DashboardWireframe()
        let dashboardNavigationController = UINavigationController(rootViewController: dashboardWireframe.viewController)
        dashboardNavigationController.tabBarItem = dashboardTabBarItem
        
        let favouritesTabBarItem = UITabBarItem()
        favouritesTabBarItem.image = UIImage(systemName: "heart.fill")
        favouritesTabBarItem.title = "Favoritos"
        let favouritesWireframe = FavouritesWireframe()
        let favouritesNavigationController = UINavigationController(rootViewController: favouritesWireframe.viewController)
        favouritesNavigationController.tabBarItem = favouritesTabBarItem
        
        self.viewControllers = [dashboardNavigationController, favouritesNavigationController]
    }
}
