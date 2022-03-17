//
//  Service.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 17/03/2022.
//

import Foundation
import Combine

struct NetworkError: Error {
    let initialError: String
    //  let backendError: BackendError?
}
protocol ServiceProtocol {
    func fetchData<T:Codable>(url:String,method:String,isHeaderToke:Bool) -> AnyPublisher<T,NetworkError>
}


class Service: ServiceProtocol {
    
    
    static let shared: ServiceProtocol = Service()
    private init() { }
    
    func fetchData<T:Codable>(url:String,method:String,isHeaderToke:Bool) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.init(initialError: "Invalid URL")).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMTJhOTg2YjcyZmQxODlhMjg1NjZjNWJmMzI5YzYwMGM5NDY2OTY3OTgyNDZjNzkyNjQ0MWJhMTJiM2RhYjg2ZTAyYTMzNjFjNjQ5ZDVmMWUiLCJpYXQiOjE2NDc0NTcwMjguMDgzMTk2LCJuYmYiOjE2NDc0NTcwMjguMDgzMjAxLCJleHAiOjE2Nzg5OTMwMjguMDc4NjgzLCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.RnmJuIwigkahH_WR486P-3C6jqpZKrUZapjYp4ZjOP18DgZTg_pSnBLa19ipnu9yMZcVbubYE-fg_gMZm2dZFh4Ltq8rRWdaMSvO-TdOkQ8pvM5rCPkCDq4puMmQ6yfkYKRW_HwF6ct5uU0PQ1EM8be-IbBUcnQ3yOXOLHcPZBGgiHWjHIj_a-jGwAkQpKezJHOOeMRNiA2Y5oy9wTQ_bGnTxRDT0tM_rFmt2IcCGFHq2hxU3vdjy3yJilw8qJBHitR98AbMGe0RciLTjaEf70ZH4JlgbgIkTkWEBPcZWdukmaN7_G3vyJzC-W3N-agc9RQYjnz4KbDwCOHcn09FWfuIv67YZZdwE_epqHBmloL9H27wndQlrwKjT4qptusYkQvaiYZ-f0UZHV7oqQmGhk4NA6Mp0oj4PS2SqwLUctxLzpGJMU3yTy9dCyB-j9HDsXd4JkPRAACRbbzENen1a9jaUWbWTZkH7WqZV7F7e2bexNJBV_VYj9NNHYPkjsnneNwJNYKQtKGZQrx3-SJU7VbqOG8L5N1PfIEI3C5IvIZcIm8P6GIpbGCAm3MCmTQ3nVGx_7HNHoDInAWa1-WI5hKdqxDTwmShm_e5_16C-G6H1egUKF_gECsYX3oUCo_PdKwYEWrqe0822lgIqH3HwO36T2mYDs7kSzzVYfTDEsM", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                return .init(initialError: error.localizedDescription)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
