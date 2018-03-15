//
//  CandidatesViewCell.swift
//  Vote Presidente
//
//  Created by Arthur Augusto Sousa Marques on 3/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class CandidatesViewCell: UITableViewCell {
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelParty: UILabel!
    @IBOutlet weak var labelCurrentPosition: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    
    let viewModel = CandidatesViewModel.shared
    
    func setupView(at indexPath: IndexPath) {
        labelName.text = viewModel.candidateName(at: indexPath)
        labelParty.text = viewModel.candidateParty(at: indexPath)
        labelCurrentPosition.text = viewModel.candidateCurrentPosition(at: indexPath)
        textViewDescription.text = viewModel.candidateDescription(at: indexPath)
        
        DispatchQueue.main.async {
            if let data = self.viewModel.imageData(at: indexPath) { self.imageViewPhoto.image = UIImage(data: data) }
        }
    }
}
