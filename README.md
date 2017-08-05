*Esse tutorial é continuação do [Custom Camera](https://github.com/GuilhermeGatto/CustomCamera) e foi escrito utilizando Xcode 8.3.3 e Swift 3.*

# iOS Custom Camera, salvando e compartilhando a imagem customizada.

### Introdução ###

Nesse tutorial será explicado como salvar e compartilhar imagens capturadas da camera customizada.

## Vamos começar ##

*Projeto incial encontra-se na branch master.*

1. Abra o projeto no Xcode.
2. Vamos adicionar uma nova StoryBoard chamada **SegundaTela.storyboard**.

>*Essa nova storyboard será usada para mostrarmos a imagem capturada.*

![image01](https://raw.githubusercontent.com/GuilhermeGatto/salvando-e-compartilhando-imagens-customizadas/master/imagens/01.jpg)

Adicione na **SegundaTela.storyboard** um **UIViewController** e dentro da viewController um **UIImageView** e um **UIButton**, lembre de colocar a viewController como **is Initial View Controller** na aba inspector. 

![image02](https://raw.githubusercontent.com/GuilhermeGatto/salvando-e-compartilhando-imagens-customizadas/master/imagens/04.jpg)

Agora na **Main.storyboard**, precisamos adicionar uma *Storyboard Reference 1.1*, na qual iremos referenciar a **SegundaTela.storyboard** 1.2 e linkar essa referencia  através de uma **segue** 1.3 na viewController, nomeando a segue de **toSegundaTela**.

1.1
\
![image05](https://raw.githubusercontent.com/GuilhermeGatto/salvando-e-compartilhando-imagens-customizadas/master/imagens/02.jpg)
\
1.2
\
![image06](https://raw.githubusercontent.com/GuilhermeGatto/salvando-e-compartilhando-imagens-customizadas/master/imagens/07.jpg)
\
1.3
\
![image03](https://raw.githubusercontent.com/GuilhermeGatto/salvando-e-compartilhando-imagens-customizadas/master/imagens/03.jpg)

Após criada a storyboard, é hora de criarmos uma *Cocoa Touch Class* subclasse de *UIViewController* na qual chamamos de **SegundaViewController.swift**. Agora é hora de associarmos essa nova view controller com a nova storyboard, depois disso precisamos criar o outlet da UIImageView e action para o UIButton, que no exemplo chamamos de *compartilhar()*. Vamos também criar uma variavel *image* do tipo *UIImage*, que será responsavel por armazenar a imagem capturada.

```swift
import UIKit

class SegundaViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func compartilhar(_ sender: Any) {
    }
  

}
```

Dentro da função **viewDidLoad** vamos definir que a imagem que será mostrada em nossa imageView será a imagem armazenada na variavel image, para isso: 

```swift
import UIKit

class SegundaViewController: UIViewController {

    ...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image

    }

    ...
  

}
```

Após essa implementeção feita, a *SegundaViewController* já está preparada para poder receber a imagem capturada, para isso voltaremos para a classe **ViewController.swift** e adicionaremos implementações e funções novas. Antes de começarmos a implementação devemos adcionar mais uma variavel do tipo *UIImage*, que armazenara a imagem capturada.

Na funcão capture, logo abaixo de onde imprimimos o tamanho da imagem, devemos incluir duas linhas de codigo: 

```swift
import UIKit
import AVFounadation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    var image: UIImage? 
    ...
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(UIImage(data: dataImage)?.size ?? "?")
            
            //1
            image = UIImage(data: dataImage)
            //2
            performSegue(withIdentifier: "toSegundaTela", sender: self)
            
            
        }
    }
    
    ...
  

}
```

>Vamos entender a implementação:
>1. Estamos salvando a imagem capturada da camera e armazenando na variavel image.
>2. Estamos chamando a proxima tela.

Para que a proxima tela receba a imagem capturada, é necessario sobrescrevermos e implementarmos ainda na **ViewController.swift** uma função chamada **prepare()**.


```swift
import UIKit
import AVFounadation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    ...
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSegundaTela"{
            if let destination = segue.destination as? SegundaViewController{
                destination.image = image
            }
        }
    }
  

}
```

> Nessa Função estamos veirifanco se a segue acionada é a *toSegundaTela*, caso seja, criamos uma referencia a view controller destino, no caso a *SegundaViewController*. A partir desse passo, conseguimos acessar as variaveis da classe referencia e assim conseguimos atribuir na variavel *image* da classe referencia, a nossa imagem capturada.

Rodando o aplicativo, irá notar que a imagem está sendo capturada, porem ainda sem o overlay. Nessa passo iremos juntar as duas imagens, e para isso vamos criar uma nova função, ainda na **ViewController.Swift**.


```swift
import UIKit
import AVFounadation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    ...
    
    func mixImages(overlay: UIImage, inImage: UIImage) -> UIImage{
        
        let minSize = (inImage.size.width > inImage.size.height) ? inImage.size.height : inImage.size.width
        let maxSize = (inImage.size.width < inImage.size.height) ? inImage.size.height : inImage.size.width
        let size = CGSize(width: minSize, height: minSize)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        if inImage.size.width == minSize {
            inImage.draw(in: CGRect(x: 0, y: -(maxSize-minSize)/2, width: inImage.size.width, height: inImage.size.height))
        } else {
            inImage.draw(in: CGRect(x: -(maxSize-minSize)/2, y: 0, width: inImage.size.width, height: inImage.size.height))
        }
        overlay.draw(in: CGRect(x: Double(inImage.size.width / 2 - inImage.size.width / 4 ), y: Double(inImage.size.height / 2 - inImage.size.height / 4 ), width: Double(inImage.size.width / 2), height: Double(inImage.size.height / 8)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return newImage!
    }


}
```

>Essa função é responsavel por adequar o tamanho do overlay de acordo com o tamanho da imagem gerada.

Após contruir essa função, basta chamar ela na função capture, onde armazenamos a imagem capturada na variavel local.

```swift
import UIKit
import AVFounadation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    ...
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(UIImage(data: dataImage)?.size ?? "?")
            
            //AQUI
            image = mixImages(overlay: img , inImage: UIImage(data: dataImage)!)
            performSegue(withIdentifier: "toSegundaTela", sender: self)
            
            
        }
    }

  ...

}
```
>Executando o aplicativo novamente, ao capturar a imagem, ela já é salva com o overlay.

![image01](https://raw.githubusercontent.com/GuilhermeGatto/salvando-e-compartilhando-imagens-customizadas/master/imagens/06.jpg)

Vamos agora implementar a função capturar, para isso devemos voltar a classe **SegundaViewController.swift**.


```swift
import UIKit

class SegundaViewController: UIViewController {

    ...
    
    @IBAction func compartilhar(_ sender: Any) {
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view 
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)

    
    }
  
    ...

}
```


Esse tutorial fica por aqui, caso tenha alguma duvida entre em contato conosco.

Obrigado!

### Tutorial criado por:
#### Bruno Cruz - [Linkedin](https://www.linkedin.com/in/bruno-cruz-939a0ab8/) | [Github](https://github.com/brunocruzz)
#### Guilherme Gatto - [Linkedin](https://www.linkedin.com/in/guilhermegatto/) | [Github](https://github.com/GuilhermeGatto)
