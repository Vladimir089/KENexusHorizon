import UIKit
import SnapKit

class noHistoryView: UIView {
    
    

    private let secondView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 25/255, green: 4/255, blue: 14/255, alpha: 1)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "rock"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "You haven't added\nany entries" // Установите нужный текст
        label.textColor = .white // Установите нужный цвет текста
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(red: 40/255, green: 18/255, blue: 27/255, alpha: 1)
        self.layer.cornerRadius = 20
        
        self.addSubview(secondView)
        secondView.addSubview(imageView)
        secondView.addSubview(label)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        secondView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(15)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
}
