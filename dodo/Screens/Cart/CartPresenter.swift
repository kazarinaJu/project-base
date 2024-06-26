//
//  CartPresenter.swift
//  dodo
//
//  Created by Юлия Ястребова on 22.03.2024.
//

import UIKit

protocol CartPresenterProtocol: AnyObject {
    var view: CartVCProtocol? { get set }
    
    var totalPrice: Int { get set }
    var totalProducts: Int { get set }
    
    func viewWillAppear()
    func productCountChanged(_ products: inout [Product], _ changedProduct: Product)
    
    func fetchProducts()
    func fetchTotalCountAndPrice()
    func updateCart()
}

final class CartPresenter: CartPresenterProtocol {
  
    weak var view: CartVCProtocol?
    var totalProducts: Int = 0
    var totalPrice: Int = 0

//MARK: Services
    var ordersService: OrdersServiceProtocol?
    
    func viewWillAppear() {
        fetchProducts()
        fetchTotalCountAndPrice()
        updateCart()
        
    }
}

//MARK: - Event Handler
extension CartPresenter {
    func productCountChanged(_ products: inout [Product], _ changedProduct: Product) {
        if let index = products.firstIndex(where: { $0.id == changedProduct.id }) {
            products[index] = changedProduct
            
            if changedProduct.count <= 0 {
                products.remove(at: index)
            }
        }
        self.ordersService?.save(products)
        self.updateCart()
    }
}

//MARK: - Business Logic
extension CartPresenter {
    func fetchProducts() {
        guard let products = ordersService?.fetch() else { return }
        view?.showProducts(products)
    }
    
    func fetchTotalCountAndPrice() {
        totalPrice = ordersService?.calculateTotalPrice() ?? 0
        totalProducts = ordersService?.calculateTotalCount() ?? 0
    }
    
    func updateCart() {
        fetchTotalCountAndPrice()
        view?.showCart(totalPrice, totalProducts)
    }
}
