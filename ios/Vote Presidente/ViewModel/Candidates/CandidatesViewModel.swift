//
//  CandidatesViewModel.swift
//  Vote Presidente
//
//  Created by Arthur Augusto Sousa Marques on 3/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

protocol CandidatesViewModelDelegate: class {
    func reloadData()
}

class CandidatesViewModel: ViewModel {
    static let shared = CandidatesViewModel()
    
    weak var delegate: CandidatesViewModelDelegate?
    
    private var arrayCandidates = [Candidate]() { didSet { self.delegate?.reloadData() } }
    var numberOfCandidates: Int { return arrayCandidates.count }
    
    func loadData() {
        getCandidates()
    }
    
    func getCandidates() {
        if arrayCandidates.count == 0 {
            loadingView.startInWindow()
            CandidatesServiceModel.shared.getCandidates { (object) in
                self.loadingView.stop()
                if let array = object as? [Candidate] {
                    self.arrayCandidates = array
                }
            }
        }
    }
    
    func candidateName(at indexPath: IndexPath) -> String? {
        return valueDescription(arrayCandidates[indexPath.row].name)
    }
    
    func candidateParty(at indexPath: IndexPath) -> String? {
        return valueDescription(arrayCandidates[indexPath.row].broken)
    }
    
    func candidateCurrentPosition(at indexPath: IndexPath) -> String? {
        return valueDescription(arrayCandidates[indexPath.row].currentPosition)
    }
    
    func candidateDescription(at indexPath: IndexPath) -> String? {
        return valueDescription(arrayCandidates[indexPath.row].descriptionValue)
    }
    
    func candidateDescriptionHeight(at indexPath: IndexPath) -> CGFloat {
        return valueDescription(arrayCandidates[indexPath.row].descriptionValue).height - 40
    }
    
    func imageData(at indexPath: IndexPath) -> Data? {
        let candidate = arrayCandidates[indexPath.row]
        
        if let data = candidate.imageData {
            return data
        }
        
        if let value = candidate.photoUrl { arrayCandidates[indexPath.row].imageData = Data(base64Encoded: value) }
        
        return arrayCandidates[indexPath.row].imageData
    }
}
