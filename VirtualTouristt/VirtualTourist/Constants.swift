//
//  FlickerAPI.swift
//  VirtualTourist
//
//  Created by Lola M on 7/25/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

struct Constants {
    
    struct Flicker {
        static let APIScheme = "https"
        static let APIHost = "api.flicker.com"
        static let APIPath = "/services/rest"
        
        static let searchBBoxHalfWidth = 1.0
        static let searchBBoxHalfHeight = 1.0
        static let searchLatRange = (-90.0, 90.0)
        static let searchLonRange = (-180.0, 180)
    }
    
    struct FlickerParametersKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extra"
        static let Format = "format"
        static let NoJSONCallBack = "nojsoncallback"
        static let safeSearch = "safe_seach"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let PerPage = "per_page"
    }
    
    struct FlickerParameterValues {
        static let SearchKey = "flicker.photos.search"
        static let ResponseFormat = "json"
        static let DisableJSONCallBack = "1"
        static let GalleryPhotosMethod = "flicker.galleries.getPhotos"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        
        static let APIKey = ""
        static let PerPage = 9
    }
}


