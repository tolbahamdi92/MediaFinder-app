//
//  MediaAPIManagera.swift
//  MediaFinder
//
//  Created by Tolba on 22/06/1444 AH.
//

import Foundation
import Alamofire

enum ErrorType: Error {
    case responseError(String)
    case noDataError
    case decodeError
}

class MediaAPIManagera {
    class func fetchMedia(term: String, type: String, completion: @escaping ((ErrorType?,[Media]?) -> Void)) {
        let params = [ParameterKey.term: term, ParameterKey.media: type]
        AF.request(URLs.base, method: HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers: nil).response { response in
            guard response.error == nil else {
                completion(.responseError(response.error!.localizedDescription), nil)
                return
            }
            
            guard let data = response.data else {
                completion(.noDataError, nil)
                return
            }
            do {
            let result = try JSONDecoder().decode(MediaResults.self, from: data)
                let dataArr = result.results
                completion(nil, dataArr)
            } catch {
                completion(.decodeError, nil)
                return
            }
        }
    }
}
