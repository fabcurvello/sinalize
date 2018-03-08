//
//  MapaViewController.swift
//  sinalize
//
//  Created by Fabricio Curvello on 07/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    var tmpViewController = MapaViewController.self

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var lbEndereco: UILabel!
    
    // "Salvar" o Endereço e encerrar esta tela, retornando para a tela de Solicitacao
    @IBAction func salvarEndereco(_ sender: Any) {
        enderecoMapa = lbEndereco.text!
        
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)

    }
    
    // Encerrar esta tela, retornando para a tela de Solicitacao
    @IBAction func cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    var gerenciadorLocalizacao = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Para ocultar a tabBar (barra de rodapé)
        self.tabBarController?.tabBar.isHidden = true
        
        configuraGerenciadorLocalizacao()
    }
    
    // Solicita ao usuário permissão de localização quando o app está em uso. Quando autorizado, atualiza a localização.
    func configuraGerenciadorLocalizacao() {
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
    // Para assegurar que o usuário permitiu que o app acesse a sua localização
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // se status de autorização for diferente de permissão de autorização em uso do app e diferente de não determinado significa que o usuário não autorizou.
        if ( (status != .authorizedWhenInUse) && (status != .notDetermined) ) {
            print("Usuário não autorizou")
            
            //Alert
            let alertaController = UIAlertController(title: "Permissão de localização",
                                                     message: "Necessário acesso à sua localização! Por favor habilite a permissão.",
                                                     preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertaController.addAction( acaoConfiguracoes )
            alertaController.addAction( acaoCancelar )
            present( alertaController , animated: true , completion: nil )
        } else {
            print("Usuário autorizou")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Buscando a última localização do usuário (localização atual)
        if let localizacaoUsuario = locations.last {
            
            let latitude = localizacaoUsuario.coordinate.latitude
            let longitude = localizacaoUsuario.coordinate.longitude
            
            // Para atualizar a posição do usuário no mapa:
            let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let deltaLatitude: CLLocationDegrees = 0.001
            let deltaLongitude: CLLocationDegrees = 0.001
            let areaExibicao: MKCoordinateSpan = MKCoordinateSpanMake(deltaLatitude, deltaLongitude)
            let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaExibicao)
            mapa.setRegion(regiao, animated: true)
            
            //Para exibir o endereço onde o usuário se encontra:
            CLGeocoder().reverseGeocodeLocation( localizacaoUsuario ) { (detalhesLocal, erro) in
                if erro == nil {
                    if let dadosLocal = detalhesLocal?.first {
                        
                        var logradouro = ""
                        if dadosLocal.thoroughfare != nil {
                            logradouro = dadosLocal.thoroughfare!
                        }
                        var numero = ""
                        if dadosLocal.subThoroughfare != nil {
                            numero = dadosLocal.subThoroughfare!
                        }
                        var bairro = ""
                        if dadosLocal.subLocality != nil {
                            bairro = dadosLocal.subLocality!
                        }
                        var cidade = ""
                        if dadosLocal.locality != nil {
                            cidade = dadosLocal.locality!
                        }
                        var estado = ""
                        if dadosLocal.administrativeArea != nil {
                            estado = dadosLocal.administrativeArea!
                        }
                        var pais = ""
                        if dadosLocal.country != nil {
                            pais = dadosLocal.country!
                        }
                        
                        self.lbEndereco.text = logradouro + ", " + numero + ". " + bairro + "\n" + cidade + " - " + estado + ". " + pais
                        
                    }//fim if let dadosLocal
                    // fim if erro
                } else {
                    print (erro as Any)
                }//fim else
            }//fim closure
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
