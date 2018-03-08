//
//  SolicitacaoViewController.swift
//  sinalize
//
//  Created by Fabricio Curvello on 07/09/17.
//  Copyright © 2017 Fabricio Curvello. All rights reserved.
//

import UIKit
import FirebaseAuth // Para autenticação no Firebase
import FirebaseStorage // Para salvar a foto no Firebase
import FirebaseDatabase // Para salvar a solicitacao no Firebase

//Desabilitado pois era para fazer persistência com UserDefaults. Foi substituído por autenticação no Firebase.
//Constante acessada nas classes SolicitacaoViewController e CadastroUsuarioViewController
//let chave = "usuario"


//Var acessada nas classes SolicitacaoViewController, MapaViewController, InicioViewController, EntrarViewController e CriarContaViewController
var enderecoMapa = ""

class SolicitacaoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tfEndereco: UITextField!
    @IBOutlet weak var tfReferencia: UITextField!
    @IBOutlet weak var tvDescricao: UITextView!
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var btTirarFoto: UIButton!
    @IBOutlet weak var btEscolherFoto: UIButton!
    @IBOutlet weak var btEnviarSolicitacao: UIButton!
    
    var imagePicker = UIImagePickerController() // Controller responsável pelas funcionalidades da câmera
    var validaCamera = false // Valida se existe câmera disponível
    
    
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
    

    
    // Tirar uma foto com a câmera do device
    @IBAction func tirarFoto(_ sender: Any) {
        print("tirar Foto")
        
        if validaCamera ==  true {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Não é possível tirar foto no Simulator. Apenas no iPhone de verdade")
            
            //Preencher campos para teste do app no Simulator
            self.tfEndereco.text = "Endereço para teste"
            self.tfReferencia.text = "Ponto de Referência para teste"
            self.tvDescricao.text = "Descrição para teste"
            self.imgFoto.image = #imageLiteral(resourceName: "placaDanificada")
        }
    }
    
    // Escolher foto da galeria de fotos do device
    @IBAction func escolherFoto(_ sender: Any) {
        print("escolher Foto")
        
        // .savedPhotosAlbum = Fotos recentes dentro do Device
        // .photoLibrary = Álbum de fotos do Device
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // Pega a foto selecionada pelo usuário e encerra a aplicação externa de câmera/galeria
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print("didFinishPickingMediaWithInfo")
        
        let foto = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imgFoto.image = foto
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // Quando o usuário cancela, encerra a aplicação externa de câmera/galeria sem pegar a foto selecionada
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func enviarSolicitacao(_ sender: Any) {
        
        // Todos os campos precisam ser preenchidos para poder enviar solicitação
        if validarCamposPreenchidos() {
            enviarSolicitacaoAoFirebase()

        }


        // Desativado o recurso abaixo uma vez que foi implementado o Firebase
        
//        // Se existir cadastro de usuário (UserDefaults) então enviar solicitação senão ir para a tela de cadastro de usuário
//        if UserDefaults.standard.object(forKey: chave) != nil {
//            print ("abrir chamado")
//
//        } else {
//
//            //"ViewCadastro" foi o termo inserido no Storyboard id da tela de cadastro (no Inspetor de Identidade na Main.storyboard)
//            let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewCadastro")
//            self.present(viewController, animated: true, completion: nil)
//        }
    }
    
    func validarCamposPreenchidos() -> Bool {
        
        let tituloErro = "Erro de validação:"
        var mensagemErro = ""
        
        if let endereco = self.tfEndereco.text {
            if endereco == "" {
                //print ("ERRO: Necessário inserir o Endereço")
                mensagemErro = "Necessário inserir o Endereço."
            } else {
                
                if let referencia = self.tfReferencia.text {
                    if referencia == "" {
                        //print ("ERRO: Necessário inserir o Ponto de Referência")
                        mensagemErro = "Necessário inserir o Ponto de Referência."
                    } else {
                        
                        if let descricao = self.tvDescricao.text {
                            if descricao == "" {
                                //print ("ERRO: Necessário inserir a Descrição")
                                mensagemErro = "Necessário inserir a Descrição do problema."
                            } else {
                                
                                if self.imgFoto.image == nil {
                                    //print ("ERRO: Necessário inserir a Foto")
                                    mensagemErro = "Necessário inserir a Foto."
                                } else {
                                    // VALIDAÇÕES OK
                                    print ("--- Todas as validações OK ---")
                                    
                                    return true
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //Emitir alerta caso tenha acontecido erro na validação dos campos
        if mensagemErro != "" {
            let alerta = Alerta(titulo: tituloErro, mensagem: mensagemErro)
            self.present(alerta.getAlerta(), animated: true, completion: nil)
        }
        
        return false
    }
    
    
    func enviarSolicitacaoAoFirebase() {
        
        //Quando clicar em enviar solicitaçao, desabilitar o botão e mudar seu texto
        self.btEnviarSolicitacao.isEnabled = false
        self.btEnviarSolicitacao.setTitle("Enviando...", for: .normal)
        
        //Salvar a foto da solicitação no Firebase Storage
        let armazenamento = Storage.storage().reference() // reference aponta p raiz do Storage no Firebase
        let imagens = armazenamento.child("imagens") // cria pasta imagens no storage do Firebase
        
        if let imagemSelecionada = self.imgFoto.image {
            
            // É preciso converter a foto em uma representação de dados
            let imagemDados = UIImageJPEGRepresentation(imagemSelecionada, 0.05) // 0.05 é compressão. Pode ir de 0 a 1.
            
            // Salvando a foto no Storage do Firebase com nome que foi gerado na var idFoto
            let idFoto = NSUUID().uuidString // gera id único String para virar o nome da foto no Firebase
            imagens.child("\(idFoto).jpg").putData(imagemDados!, metadata: nil, completion: { (metaDados, erro) in
                
                if erro == nil { // Conseguiu salvar a foto no Storage do Firebase
                    
                    //Salvar dados da solicitação no Database do Firebase
                    
                    //Recupera a URL da foto da solicitacao
                    let urlFotoSolicitacao = metaDados?.downloadURL()?.absoluteString
                    
                    //Para gerar a data da solicitacao
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                    let dataSolicitacao = dateFormatter.string(from: Date())

                    //Acessar o database do Firebase
                    let database = Database.database().reference()
                    
                    //Acessar o nó usuarios no database do Firebase
                    let usuarios = database.child("usuarios")
                    
                    //Recupera dados do usuário logado
                    let autenticacao = Auth.auth()
                    if let idUsuarioLogado = autenticacao.currentUser?.uid {
                        
                        let usuarioLogado = usuarios.child(idUsuarioLogado)
                        usuarioLogado.observeSingleEvent(of: DataEventType.value, with: { (snaphot) in
                            
                            let dadosUsuario = snaphot.value as! NSDictionary
                            let usuario = Usuario(
                                nome: dadosUsuario["nome"] as! String,
                                email: dadosUsuario["email"] as! String,
                                idUsuario: idUsuarioLogado)
                            
                            //Para gerar o idOrderSolicitacao. Utilizado para ordenar a table pela data das solicitações
                            dateFormatter.dateFormat = "yyyy.MMdd.HHmm-ss"
                            let idOrderSolicitacao = dateFormatter.string(from: Date()) + "#" + usuario.email
                            
                            //Criar ou acessar nó solicitacoes na raiz do database
                            let solicitacoes = database.child("solicitacoes")
                            
                            //Criar dicionário de dados com dados da solicitacao
                            let solicitacaoDados = [
                                "endereco" : self.tfEndereco.text!,
                                "referencia" : self.tfReferencia.text!,
                                "descricao" : self.tvDescricao.text!,
                                "urlFotoSolicitacao" : urlFotoSolicitacao,
                                "nomeUsuario" : usuario.nome,
                                "emailUsuario" : usuario.email,
                                "idUsuario" : usuario.idUsuario,
                                "dataSolicitacao" : dataSolicitacao,
                                "status" : "Aguardando atendimento",
                                "nomeTecnicoAtendimento" : "",
                                "dataAtendimento" : "",
                                "urlFotoAtendimento" : "",
                                "idOrderSolicitacao" : idOrderSolicitacao
                            ]
                            
                            //Criar a solicitação no Firebase
                            solicitacoes.childByAutoId().setValue(solicitacaoDados)

                            //Ir para a tela de histórico de solicitações, enviando a url da foto da solicitacao para lá
                            self.performSegue(withIdentifier: "HistoricoSegue", sender: urlFotoSolicitacao)
                        })
                        
                    } else {
                        print("Erro ao criar solicitação")
                        
                        let alerta = Alerta(titulo: "Erro:", mensagem: "Erro ao criar solicitação. Tente novamente!")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
  
                } else {
                    print("Erro ao fazer upload da foto")
                    
                    let alerta = Alerta(titulo: "Erro de Upload:", mensagem: "Erro ao fazer upload da foto. Tente novamente!")
                    self.present(alerta.getAlerta(), animated: true, completion: nil)
                }
            })
        }
    }
    
    
    // Para enviar dados para a tela HistoricoTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "HistoricoSegue" {
            
            let historicoVC = segue.destination as! HistoricoTableViewController
            
            historicoVC.endereco = self.tfEndereco.text!
            historicoVC.referencia = self.tfReferencia.text!
            historicoVC.descricao = self.tvDescricao.text!
            historicoVC.idImagem = sender as! String
            
            
            //"Zerar" todos os campos de SolicitacaoViewController pois a solicitação já foi enviada
            enderecoMapa = ""
            self.tfEndereco.text = ""
            self.tfReferencia.text = ""
            self.tvDescricao.text = ""
            self.imgFoto.image = nil
        }
    }

    
    // Para que o teclado recolha ao clicar fora da Text View ou da Text Field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // o delegate do imagePicker é esta classe mesmo
        self.imagePicker.delegate = self
        
        // recebe true se existir cmaera disponível (se for executado num iPhone)
        let isCameraDisponivel = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // O Simulator não emula a câmera. Então se o app rodar no Simulator o botão tirarFoto será desativado
        if(!isCameraDisponivel) {
            // Esconde o botão da câmera
            // Desativei esta ação pois estava bagunçando o layout todo
            //self.btTirarFoto.isHidden = true // Desativado por problemas com constraints e stack view
            
            validaCamera = false
        } else {
            validaCamera = true
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Para exibir a tabBar (barra de rodapé)
        self.tabBarController?.tabBar.isHidden = false
        
        //Sempre que esta tela for recarregada, atualizar o endereço na Text Field
        tfEndereco.text = enderecoMapa
    }
    
    // Sempre que esta tela desaparecer, salvar o que estiver na Text Field Endereço na var enderecoMapa
    override func viewDidDisappear(_ animated: Bool) {
        if let endereco = tfEndereco.text {
            enderecoMapa = endereco
        }
        
        //Retroceder o botão Enviar Solicitacao ao seu estado original
        self.btEnviarSolicitacao.setTitle("Enviar Solicitação", for: .normal)
        self.btEnviarSolicitacao.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

