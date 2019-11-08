//
//  FlickerAPI.swift
//  VirtualTourist
//
//  Created by Lola M on 7/25/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct FlickerAPI {
    
    static func getPhotosUrls (with coordinate: CLLocationCoordinate2D, pageNumber: Int, completion: @escaping ([URL]?, Error?, String?) -> ()) {
        let methodParameters = [
            Constants.FlickerParametersKeys.Method: Constants.FlickerParameterValues.SearchKey,
            Constants.FlickerParametersKeys.APIKey: Constants.FlickerParameterValues.APIKey,
            Constants.FlickerParametersKeys.BoundingBox: bboxString(for: coordinate),
            Constants.FlickerParametersKeys.safeSearch: Constants.FlickerParameterValues.UseSafeSearch,
            Constants.FlickerParametersKeys.Extras: Constants.FlickerParameterValues.MediumURL,
            Constants.FlickerParametersKeys.Format: Constants.FlickerParameterValues.ResponseFormat,
            Constants.FlickerParametersKeys.NoJSONCallBack: Constants.FlickerParameterValues.DisableJSONCallBack,
            Constants.FlickerParametersKeys.Page: pageNumber,
            Constants.FlickerParametersKeys.PerPage: Constants.FlickerParameterValues.PerPage
            ] as [String: Any]
        
        let request = URLRequest(url: getURL (from: methodParameters))
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard (error == nil)
                else {
                    completion(nil, error, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                statusCode >= 200 && statusCode <= 299
                else {
                    completion(nil, nil,  "your request retuturn a statusCode other 2xx!")
                    return
            }
            guard let data = data else {
                completion(nil, nil, "No data was returned by the request.")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                else {
                    completion(nil, nil, "Couldn't parse the data as json")
                    return
            }
            
            guard let stat = result["stat"] as? String, stat == "ok"
                else {
                    completion(nil, nil, "flicker api returned an error, see error message in \(result)")
                    return
            }
            
            guard let photosDictionary = result ["photos"] as? [String: Any]
                else {
                    completion(nil, nil, "Cannot find key photos in \(result)")
                    return
            }
            
            guard let photosArray = photosDictionary["photo"] as? [[String: Any]]
                else {
                    completion(nil, nil, "Cannot find key photos in \(photosDictionary)")
                    return
            }
            let PhotosURLs = photosArray.compactMap { photosDictionary -> URL? in
                guard let url = photosDictionary["url_m"] as? String
                    else { return nil}
                return URL(string: url)
            }
            completion(PhotosURLs, nil, nil)
        }
    }
    
    
    static func bboxString(for coordinate: CLLocationCoordinate2D) -> String {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let minimumLon = max(longitude - Constants.Flicker.searchBBoxHalfWidth, -180)
        let minimomLat = max(latitude - Constants.Flicker.searchBBoxHalfHeight, -90)
        _ = min(longitude + Constants.Flicker.searchBBoxHalfWidth, 180.0)
        let maximomLat = min(latitude + Constants.Flicker.searchBBoxHalfHeight, 90.0)
        return "\(minimumLon), \(minimomLat), \(maximomLat), \(maximomLat)"
    }
    
    static func getURL (from parameters: [String: Any]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flicker.com"
        components.path = "/services/rest"
        components.queryItems = [URLQueryItem]()
        
        for (_, value) in parameters {
            let queryItem = URLQueryItem(name: "key", value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
}

