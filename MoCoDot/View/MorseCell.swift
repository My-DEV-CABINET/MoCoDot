//
//  MorseCell.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/3/24.
//

import UIKit

import SnapKit

class MorseCell: UITableViewCell {
    static let identifier: String = "MorseCell"
    
    var eventHandler: ((String) -> Void)?
    
    let alphabet = UILabel(frame: .zero)
    let morseCode = UILabel(frame: .zero)
    let soundButton = CustomButton(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        [alphabet, morseCode, soundButton].forEach { contentView.addSubview($0) }
    }
    
    func setupUI() {
        addView()
        
        createAlphabet()
        createMorseCode()
        createSoundButton()
    }
    
    func configure(_ value: MorseProtocol) {
        alphabet.text = value.alphabetName
        morseCode.text = value.morseCode
    }
    
    func createAlphabet() {
        alphabet.textColor = .white
        alphabet.font = .systemFont(ofSize: 30, weight: .bold)
        
        alphabet.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(30)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.width.equalTo(60)
        }
    }
    
    func createMorseCode() {
        morseCode.textColor = .white
        morseCode.font = .systemFont(ofSize: 40, weight: .bold)
        morseCode.textAlignment = .center
        
        morseCode.snp.makeConstraints { make in
            make.leading.equalTo(alphabet.snp.trailing).offset(22)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-30)
            make.width.greaterThanOrEqualTo(30)
        }
    }
    
    func createSoundButton() {
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "speaker.wave.3", withConfiguration: imgConfig)
        soundButton.setImage(image, for: .normal)
        soundButton.backgroundColor = UIColor(named: UIType.selectButton.type)
        soundButton.layer.cornerRadius = 10
        soundButton.tintColor = .white
        soundButton.contentMode = .scaleAspectFit
        
        soundButton.addTarget(self, action: #selector(didTapSoundButton), for: .touchUpInside)
        
        soundButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-30)
            make.height.width.equalTo(60)
        }
    }
    
    @objc private func didTapSoundButton(_ sender: UIButton) {
        eventHandler?(morseCode.text ?? "")
    }
}
