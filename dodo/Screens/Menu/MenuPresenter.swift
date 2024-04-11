//
//  MenuPresenter.swift
//  dodo
//
//  Created by Юлия Ястребова on 21.03.2024.
//

import UIKit

protocol MenuPresenterProtocol: AnyObject {
    var view: MenuVCProtocol? { get set }
    
    //User Event & View Event
    func viewDidLoad()
    func bannerPriceButtonTapped(_ product: Product)
    func productPriceButtonTapped(_ product: Product)
    func productCellSelected(_ selectedProduct: Product)
    
    //Business Logic
    func fetchProducts()
    func fetchStories()
    func fetchCategories()
}

final class MenuPresenter: MenuPresenterProtocol {
   
    
    
    weak var view: MenuVCProtocol?
    
//MARK: Services
    private let storiesService = StoriesService.init()
    private let productsService = ProductsService.init()
    private let ordersService = OrdersService.init()
    
    func viewDidLoad() {
        fetchProducts()
        fetchStories()
        fetchCategories()
    }
}

//MARK: - Event Handler
extension MenuPresenter {
    
    func bannerPriceButtonTapped(_ product: Product) {
        ordersService.add(product)
    }
    
    func productPriceButtonTapped(_ product: Product) {
        ordersService.add(product)
    }
    
    func productCellSelected(_ selectedProduct: Product) {
        view?.navigateToDetailScreen(selectedProduct)
    }
}

//MARK: - Business Logic
extension MenuPresenter {
    func fetchProducts() {
        productsService.fetchProducts { [self] products in
            view?.showProducts(products)
        }
    }

    func fetchStories() {
        storiesService.fetchStories { [self] stories in
            view?.showStories(stories)
        }
    }

    func fetchCategories() {
        productsService.fetchCategories { [self] categories in
            view?.showCategories(categories)
        }
    }
}