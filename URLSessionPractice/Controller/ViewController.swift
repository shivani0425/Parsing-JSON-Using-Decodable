
import UIKit

class ViewController: UIViewController {
    
 //MARK: Array
    var employeeDetailsArray:[UserDetails] = []
    
//MARK: Outlets
    @IBOutlet weak var tabelView: UITableView!
    
//MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        fatchData()
    }
    
//MARK: FatchData Function
    private func fatchData() {
        // 1: GET request to server
        let urlString = "https://jsonplaceholder.typicode.com/users"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //2: create session object
        let session = URLSession(configuration: .default)
        
        //3: create data task
        let dataTask = session.dataTask(with: request) {[weak self] data, response, error in
            if error == nil {// no error
                guard let data = data else {
                    print("Data is nil")
                    return
                }
                do {
                    self?.employeeDetailsArray = try JSONDecoder().decode([UserDetails].self, from: data)
                    DispatchQueue.main.async {
                        self?.tabelView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
        dataTask.resume()
    }
}

//MARK: UITableViewDataSource Methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeeDetailsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? EmployeeTableViewCell {
            let employeeIndex = employeeDetailsArray[indexPath.row]            
            cell.nameLabel.text = employeeIndex.name
            cell.zipcodeLabel.text = "Zipcode : \(employeeIndex.address.zipcode)"
            cell.latLabel.text = "Lat : \(employeeIndex.address.geo.lat)"
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//
//id    :    1
//name    :    Leanne Graham
//username    :    Bret
//email    :    Sincere@april.biz
//    address        {5}
//street    :    Kulas Light
//suite    :    Apt. 556
//city    :    Gwenborough
//zipcode    :    92998-3874
//    geo        {2}
//lat    :    -37.3159
//lng    :    81.1496
//phone    :    1-770-736-8031 x56442
//website    :    hildegard.org
//    company        {3}
//name    :    Romaguera-Crona
//catchPhrase    :    Multi-layered client-server neural-net
//bs    :    harness real-time e-markets




