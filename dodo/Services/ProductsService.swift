//
//  ProductsService.swift
//  dodo
//
//  Created by Юлия Ястребова on 28.01.2024.
//
import Foundation

protocol ProductsServiceProtocol: AnyObject {
    func fetchProducts(completion: @escaping ([Product]) -> Void)
    func fetchCategories(completion: @escaping ([Category]) -> Void)
    func fetchIngredients(completion: @escaping ([Ingredient]) -> Void)
    func fetchSizesAndDough(completion: @escaping ([String]?, [String]?) -> Void)
}

class ProductsService: ProductsServiceProtocol {

    private let networkClient: NetworkClientProtocol
    private let decoder: JSONDecoder
    
    init(networkClient: NetworkClientProtocol, decoder: JSONDecoder = JSONDecoder()) {
        self.networkClient = networkClient
        self.decoder = decoder
    }
    
    private var productsUrl: URL {
        guard let url = URL(string: "https://mocki.io/v1/91ef3aa0-da24-41e5-a4e1-effe4c66801b") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func fetchProducts(completion: @escaping ([Product]) -> Void) {
        
        networkClient.fetch(url: productsUrl) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    //print 
                    print(data.prettyPrintedJSONString)
                    let productResponse = try decoder.decode(ProductResponse.self, from: data)
                    let products = productResponse.products
                    
                    DispatchQueue.main.async {
                        completion(products)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCategories(completion: @escaping ([Category]) -> Void) {
        networkClient.fetch(url: productsUrl) { [self] result in
            switch result {
            case .success(let data):
                do {
                    let categoryResponse = try decoder.decode(ProductResponse.self, from: data)
                    let categories = categoryResponse.categories
                    
                    DispatchQueue.main.async {
                        completion(categories)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchIngredients(completion: @escaping ([Ingredient]) -> Void) {
        
        networkClient.fetch(url: productsUrl) { [self] result in
            switch result {
            case .success(let data):
                do {
                    let ingredientResponse = try decoder.decode(ProductResponse.self, from: data)
                    let ingredients = ingredientResponse.ingredients
                    
                    DispatchQueue.main.async {
                        completion(ingredients)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchSizesAndDough(completion: @escaping ([String]?, [String]?) -> Void) {
        networkClient.fetch(url: productsUrl) { [self] result in
            switch result {
            case .success(let data):
                do {
                    let productResponse = try decoder.decode(ProductResponse.self, from: data)
                    let sizes = productResponse.sizes
                    let dough = productResponse.dough
                    DispatchQueue.main.async {
                        completion(sizes, dough)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
