        //Recuperation des donnees d'une seule personne
        let url = URL(string: "https://auth.etna-alternance.net/api/users/bailli_k")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    print(json)
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
        //Recuperation des donnees de la promo 2021
        
        let url = URL(string: "https://prepintra-api.etna-alternance.net/trombi/195")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    var json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    print(json["students"])
                }
                catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        return true
