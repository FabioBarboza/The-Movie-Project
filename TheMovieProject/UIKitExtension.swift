//
//  UIKitExtension.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 03/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import UIKit
import Alamofire

typealias IMAGE_SUCCESS = ((_ image: UIImage) -> Void)

extension UIImage {
    
    static func image(from path: String, response: @escaping IMAGE_SUCCESS) {
        let PATH_IMAGE = "http://image.tmdb.org/t/p/w500"
        if path == "" {
            response(#imageLiteral(resourceName: "placeholder"))
        } else {
            Alamofire.request(PATH_IMAGE + path, method: Alamofire.HTTPMethod.get).responseData { (data) in
                if data.result.error == nil {
                    let image = UIImage(data: data.result.value!)
                    response(image!)
                } else {
                    response(#imageLiteral(resourceName: "placeholder"))
                }
            }
        }
    }
}