//
//  HistoricoTableViewController.swift
//  sinalize
//
//  Created by Fabricio Curvello on 24/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//

import UIKit
import FirebaseAuth // Para autenticação no Firebase
import FirebaseDatabase // Para acesso a dados no Database do Firebase
import SDWebImage // Para facilitar o download da foto do Firebase Storage

class HistoricoTableViewController: UITableViewController {
  
    var usuarioLogado: Usuario!
    var solicitacoesUsuarioLogado: [Solicitacao] = []
    
    //valores que são enviados da classe SolicitacaoViewController
    var endereco = ""
    var referencia = ""
    var descricao = ""
    var idImagem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("----- viewDidLoad -----")

        //Recupera id do usuário logado
        let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            
            //Acessar o Database do Firebase e pegar a referência
            let database = Database.database().reference()
            
            //Acessar o nó de solicitaçoes
            let solicitacoes = database.child("solicitacoes")
            
            //Cria ouvinte para solicitacoes
            solicitacoes.observe(DataEventType.childAdded, with: { (snapshot) in
                //print("----- SNAPSHOT SOLICITACOES -----")
                //print(snapshot)
                
                //Recupera os dados da solicitacao
                let dadosSolicitacao = snapshot.value as! NSDictionary
                
                //converte em objeto
                let solicitacao = Solicitacao()

                //Adiciona ao array de solicitaçoes do usuário logado caso a solicitacao seja dele
                if dadosSolicitacao["idUsuario"] as! String == idUsuarioLogado {
                
                    solicitacao.endereco = dadosSolicitacao["endereco"] as! String
                    solicitacao.referencia = dadosSolicitacao["referencia"] as! String
                    solicitacao.descricao = dadosSolicitacao["descricao"] as! String
                    solicitacao.urlFotoSolicitacao = dadosSolicitacao["urlFotoSolicitacao"] as! String
                    solicitacao.nomeUsuario = dadosSolicitacao["nomeUsuario"] as! String
                    solicitacao.emailUsuario = dadosSolicitacao["emailUsuario"] as! String
                    solicitacao.idUsuario = dadosSolicitacao["idUsuario"] as! String
                    solicitacao.dataSolicitacao = dadosSolicitacao["dataSolicitacao"] as! String
                    solicitacao.status = dadosSolicitacao["status"] as! String
                    solicitacao.nomeTecnicoAtendimento = dadosSolicitacao["nomeTecnicoAtendimento"] as! String
                    solicitacao.dataAtendimento = dadosSolicitacao["dataAtendimento"] as! String
                    solicitacao.urlFotoAtendimento = dadosSolicitacao["urlFotoAtendimento"] as! String
                    solicitacao.idOrderSolicitacao = dadosSolicitacao["idOrderSolicitacao"] as! String
                    solicitacao.idSolicitacao = snapshot.key

                    self.solicitacoesUsuarioLogado.append( solicitacao )
                }
                
                //Ordena o array da solicitação mais atual para a mais antiga pelo idOrdenador
                self.solicitacoesUsuarioLogado.sort(by: { (a: Solicitacao, b: Solicitacao) -> Bool in
                    return a.idOrderSolicitacao > b.idOrderSolicitacao
                })
                
                //Recarrega a table, pois o Firebase demora a retornar os dados
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("----- viewDidAppear -----")
        
        //Para exibir a tabBar (barra de rodapé)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //Número de seções da tabela
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //Número de linhas da tabela
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Quando não houver solicitações deverá existir uma linha na tabela
        //para exibir mensagem de que não há solicitações
        
        let totalSolicitacoes = solicitacoesUsuarioLogado.count
        if totalSolicitacoes == 0 {
            return 1
        } else {
            return self.solicitacoesUsuarioLogado.count
        }
    }
    
    
    //Monta conteúdo da célula da tabela
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Quando não houver solicitações deverá existir uma linha na tabela
        //para exibir mensagem de que não há solicitações
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath) as! SolicitacaoCelula
        
        let totalSolicitacoes = solicitacoesUsuarioLogado.count
        if totalSolicitacoes != 0 {
            
            let solicitacao : Solicitacao = self.solicitacoesUsuarioLogado[ indexPath.row ]
            
            //Fazer a imagem preencher toda a celula
            celula.imgFotoSolicitacao.contentMode = UIViewContentMode.scaleAspectFill
            
            let urlFotoSolicitacao = URL(string: solicitacao.urlFotoSolicitacao)
            celula.imgFotoSolicitacao.sd_setImage(with: urlFotoSolicitacao, completed: { (imagem, erro, cache, url) in
                if erro == nil {
                    print("Foto da Solicitação exibida OK")
                }
            })

            celula.lbDescricao.text = solicitacao.descricao
            celula.lbEndereco.text = solicitacao.endereco
            celula.lbDataSolicitacao.text = "Data da solicitação: \(solicitacao.dataSolicitacao)"
            celula.lbStatus.text = "Status: \(solicitacao.status)"
            if solicitacao.status != "Aguardando atendimento" {
                celula.lbStatus.textColor = UIColor.blue
            }

        } else {
            //Fazer a imagem caber totalmente dentro da celula
            celula.imgFotoSolicitacao.contentMode = UIViewContentMode.scaleAspectFit
            
            celula.imgFotoSolicitacao.image = #imageLiteral(resourceName: "LOGOMARCA")
            celula.lbDescricao.text = "Você ainda não sinalizou!"
            celula.lbEndereco.text = "Solicite manutenção de placas ou pinturas de pista."
            celula.lbDataSolicitacao.text = ""
            celula.lbStatus.text = ""
        }

        return celula
    }
    
    
    //Recuperar a célula clicada pelo usuário e colocar o objeto da solicitacao clicada no sender
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Lembrando que, quando não existirem solicitações, existirá uma linha sendo exibida na table.
        //Esta linha não pode ser clicável.
        let totalSolicitacoes = solicitacoesUsuarioLogado.count
        if totalSolicitacoes > 0 {
            let solicitacao = self.solicitacoesUsuarioLogado[ indexPath.row ]
            self.performSegue(withIdentifier: "DetalhesSolicitacaoSegue", sender: solicitacao)
        }
    }
    
    //Enviar os dados da solicitação clicada pelo usuário para a DetalhesSolicitacaoViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetalhesSolicitacaoSegue" {
            
            let detalhesSolicitacaoVC = segue.destination as! DetalhesSolicitacaoViewController
            detalhesSolicitacaoVC.solicitacaoClicada = sender as! Solicitacao
        }
    }
    
    
    @IBAction func sair(_ sender: Any) {
        
        //Fazer logoff no Firebase
        let autenticacao = Auth.auth()
        
        do {
            try autenticacao.signOut()
            
            //Encerrar esta tela
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Erro ao efetuar logoff do usuário")
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
