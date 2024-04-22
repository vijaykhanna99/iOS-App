import UIKit
import Alamofire


extension APIManager {
    
    func httpRequest<T: Decodable>(api: String,
                                   type: T.Type,
                                   method: HTTPMethod,
                                   parameters: [String: Any]? = nil,
                                   encoding: ParameterEncoding = URLEncoding.default,
                                   complition: @escaping(T?, Error?)->Void) {
        
        let url = ServerConfig.serverURL + api
        let headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": authToken]
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                self.handleDecodableResponse(response, type: type, complition: complition)
            }
    }
    
    func multipartRequest<T: Decodable>(method: HTTPMethod = .post,
                                        api: String,
                                        type: T.Type,
                                        parameters: [String: Any],
                                        imageNames: [String],
                                        images: [UIImage?],
                                        complition: @escaping(T?, Error?)->Void) {
        let url = ServerConfig.serverURL + api
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data",
                                    "Authorization": authToken]
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.timeoutInterval = 120
        urlRequest.headers = headers
        urlRequest.httpMethod = method.rawValue
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            for (index, img) in images.enumerated() {
                if let data = img?.pngData() {
                    let name = (imageNames.count > index) ? imageNames[index] : (imageNames.first ?? "image")
                    let timeStamp = Date().timeStampSince1970
                    multipartFormData.append(data, withName: name, fileName: "image-\(timeStamp).png", mimeType: "image/png")
                }
            }
        }, with: urlRequest)
        .validate(statusCode: 200..<300)
        .responseData { response in
            self.handleDecodableResponse(response, type: type, complition: complition)
        }
    }
    
    // Handle Response Using Decodeble Protocol
    fileprivate func handleDecodableResponse<T: Decodable>(_ response: AFDataResponse<Data>, type: T.Type, complition:@escaping(T?, Error?)->Void) {
        
#if DEBUG
        print("************************************************************")
        
        print("API Log: \n \(response.debugDescription)")
        
        print("************************************************************")
#endif
        
        switch response.result {
        case .success(let data):
            do {
                let modelObject = try JSONDecoder().decode(type.self, from: data)
                complition(modelObject, nil)
            } catch (let error) {
                complition(nil, error)
                print("Parsing Error: \(error)")
            }
            
        case .failure(let error):
            guard let data = response.data else {
                complition(nil, error.underlyingError)
                return
            }
            complition(nil, jsonDataToError(data))
        }
    }
    
    fileprivate func jsonDataToError(_ data: Data) -> Error? {
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                let errorCode = json["code"] as? Int ?? 502
                let errorMsg = json["message"] as? String ?? AlertMessage.UNKNOWN_ERROR
                let error = NSError(domain: "", code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMsg])
                return error
            }
        } catch let error as NSError {
            return error
        }
        return nil
    }
}


extension APIManager {
    
    func downloadFile(_ urlString: String, fileName: String, complition: @escaping CompletionURLResult) {
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile])
        }
        AF.download(urlString, headers: ["Authorization": authToken], to: destination)
            .validate(statusCode: 200..<300)
            .response { response in
#if DEBUG
                print("************************************************************")
                print("Downlaod File: \(response.error == nil ? String(describing: response.fileURL) : String(describing: response.error))")
                print("************************************************************")
#endif
                switch response.result {
                case .success(let fileURL):
                    complition(.success(fileURL))
                case .failure(let error):
                    complition(.failure(NSError.generate(code: error.responseCode, message: error.localizedDescription)))
                }
            }
    }
}
