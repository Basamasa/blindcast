//
//  API.swift
//  Blindcast
//
//  Created by Jan Anstipp on 14.12.19.
//  Copyright © 2019 handycap. All rights reserved.
//

import Foundation
import Alamofire
import AppleiTunesSearchURLComponents
import FeedKit

struct ITunesSearchAPI{
    
    static private func fetchData(url: URL, completionHandler: @escaping (Data) -> Void){
        Alamofire.request(url).responseData{ response in
            if response.result.isSuccess {
                if let data = response.data {
                    completionHandler(data)
                }else{
                    print("<Fail No Data> url:\(String(describing: response.request?.url))")
                }
              
            }
            if response.result.isFailure {
                print("<Fail Decode Data> url:\(String(describing: response.request?.url))")
            }
        }
    }
    
    static private func getUrl<Media: MediaType>(mediaType: Media.Type, term: String, entity: Media.Entity? = nil, attribut: Media.Attribute? = nil) -> URL?{
        let component = AppleiTunesSearchURLComponents<Media>(term: term,entity: entity, attribute: attribut)
        guard let url = component.url else { return nil}
        return url
    }
    
    static func fetchMedia<media: MediaType>(mediaType: media.Type, term: String, entity: media.Entity? = nil, attribut: media.Attribute? = nil, completionHandler: @escaping ([Media]) -> Void){
        
        let component = AppleiTunesSearchURLComponents<media>(term: term,entity: entity, attribute: attribut, limit: 200)
        guard let url = component.url else { return }
        
        fetchData(url: url) { data in
            do{
                let decodeData = try JSONDecoder().decode( ITunesCodableModel<Media>.self, from: data )
                completionHandler(decodeData.results)
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    static func fetchImage(url: URL, completionHandler: @escaping (UIImage) -> Void){
        self.fetchData(url: url){ data in
            if let image = UIImage(data:data){
                 completionHandler(image)
            }
        }
    }
    
}
