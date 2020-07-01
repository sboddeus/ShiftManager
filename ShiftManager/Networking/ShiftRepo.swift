//
//  ShiftRepo.swift
//  ShiftManager
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import Foundation
import Alamofire

struct ModelRepo {
    // MARK: - Error Type
    enum RepoError: Error {
        case failedRequest(Error)
        case incorrectURLFormatting
        case jsonError
    }

    // MARK: - Getting Shifts

    func getAllShifts(_ completion: @escaping (Result<[Shift], RepoError>) -> Void) {
        guard let url = URL(string: NetworkingConstants.baseURL + "/shifts") else {
            completion(.failure(.incorrectURLFormatting))
            return
        }
        AF.request(url, method: .get, headers: headers).response { (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    completion(.failure(.failedRequest(error)))
                } else if let data = response.data {
                    do {
                        let shifts = try JSONDecoder().decode([Shift].self, from: data)
                        completion(.success(shifts))
                    } catch {
                        completion(.failure(.failedRequest(error)))
                    }
                } else {
                    completion(.success([]))
                }
            }
        }
    }

    // MARK: - Starting and Ending A Shift

    func start(shift: ShiftRequest, completion: @escaping (Result<ShiftRequest, RepoError>) -> Void) {
        guard let url = URL(string: NetworkingConstants.baseURL + "/shift/start") else {
            completion(.failure(.incorrectURLFormatting))
            return
        }

        postRequest(shift: shift, url: url, completion: completion)
    }

    func end(shift: ShiftRequest, completion: @escaping (Result<ShiftRequest, RepoError>) -> Void) {
        guard let url = URL(string: NetworkingConstants.baseURL + "/shift/end") else {
            completion(.failure(.incorrectURLFormatting))
            return
        }

        postRequest(shift: shift, url: url, completion: completion)
    }

    private func postRequest(shift: ShiftRequest, url: URL, completion: @escaping (Result<ShiftRequest, RepoError>) -> Void) {

        AF.request(url, method: .post, parameters: shift, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            DispatchQueue.main.async {
                    if let error = response.error {
                        completion(.failure(.failedRequest(error)))
                    } else {
                        completion(.success(shift))
            }
            }
        }
    }

    // MARK: - Common Headers
    
    private var headers: HTTPHeaders {
        return [NetworkingConstants.authHeaderKey: NetworkingConstants.authHeaderValue,
                NetworkingConstants.contentKey: NetworkingConstants.contentValue]
    }
}
