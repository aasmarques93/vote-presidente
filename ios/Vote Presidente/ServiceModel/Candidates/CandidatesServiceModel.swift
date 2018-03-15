//
//  CandidatesServiceModel.swift
//  Vote Presidente
//
//  Created by Arthur Augusto Sousa Marques on 3/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class CandidatesServiceModel: ServiceModel {
    static let shared = CandidatesServiceModel()
    
    func getCandidates(handler: HandlerObject? = nil) {
        request(Candidate.self, requestUrl: .candidates, handlerObject: { (data) in
            if let handler = handler { handler(data) }
        })
    }
}
