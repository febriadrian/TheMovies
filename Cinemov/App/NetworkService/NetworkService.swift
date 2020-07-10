//
//  NetworkService.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import Alamofire
import Foundation
import SwiftyJSON

typealias successHandler = (_ data: JSON?) -> Void
typealias failureHandler = (_ error: Error?) -> Void

protocol IEndpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: Parameters? { get }
    var header: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

struct NetworkStatus {
    static var isInternetAvailable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class NetworkService {
    static let share = NetworkService()

    private var dataRequest: DataRequest?

    @discardableResult
    private func _dataRequest(
        url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    )
        -> DataRequest {
        return Session.default.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }

    func request<T: IEndpoint>(endpoint: T, success: (successHandler)? = nil, failure: (failureHandler)? = nil) {
        if NetworkStatus.isInternetAvailable {
            DispatchQueue.global(qos: .background).async {
                self.dataRequest = self._dataRequest(url: endpoint.path,
                                                     method: endpoint.method,
                                                     parameters: endpoint.parameter,
                                                     encoding: endpoint.encoding,
                                                     headers: endpoint.header)

                self.dataRequest?.responseJSON(completionHandler: { response in
                    if response.response?.statusCode != 200 {
                        failure?(nil)
                    } else {
                        switch response.result {
                        case .success(let value):
                            success?(JSON(value))
                        case .failure(let error):
                            failure?(error)
                        }
                    }
                })
            }
        } else {
            failure?(nil)
        }
    }
}
