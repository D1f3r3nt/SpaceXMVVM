import UIKit

protocol DetailsViewControllerProtocol: AnyObject {
    func updateValues(with mission: Mission)
    func navigateToRocket(with rocket: Rocket)
}

class DetailsViewController: UIViewController {
    
    private let defualtImage: String = "https://paganresearch.io/images/SpaceX.jpg"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imagePatch: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    @IBOutlet weak var failureLabel: UITextView!
    @IBOutlet weak var succesLabel: UILabel!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var rocketButton: UIButton!
    
    var viewModel: DetailsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set back button color
        self.navigationController?.navigationBar.tintColor = .white
        self.viewModel?.handleLoadData()
    }

    @IBAction func didTapVideo(_ sender: Any) {
        guard let safari = self.viewModel?.openVideo() else {
            return
        }
        
        present(safari, animated: true, completion: nil)
    }
    
    @IBAction func didTapRocket(_ sender: Any) {
        self.viewModel?.handleLoadRocket()
    }
}

extension DetailsViewController: DetailsViewControllerProtocol {
    func navigateToRocket(with rocket: Rocket) {
        let rocketView = RocketViewController()
        rocketView.viewModel = RocketViewModel(viewDelegate: rocketView, rocket: rocket)
        
        self.navigationController?.pushViewController(rocketView, animated: true)
    }
    
    func updateValues(with mission: Mission) {
        let formattedDate: String = String(mission.date.split(separator: "T")[0])
        
        codeLabel.text = "#\(mission.flightNumber)"
        title = "#\(mission.flightNumber)"
        nameLabel.text = mission.name
        dateLabel.text = formattedDate
        succesLabel.text = mission.succes ? "Success" : "Failed"
        succesLabel.textColor = mission.succes ? .green : .red
        imagePatch.setImage(for: URL(string: mission.patch ?? defualtImage)!)
        detailLabel.text = mission.details
        failureLabel.text = mission.failure ?? "No failures"
        videoButton.isHidden = mission.video == nil
    }
}
