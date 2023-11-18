# Inventaire
Gestion d'un inventaire de cimetière de voitures écrit en Turbo Pascal 6

![image](https://github.com/gladir/Inventaire/assets/11842176/37ec0837-2cbf-449a-ae2b-50b9a790f6b8)

C'est un logiciel de gestion de cimetière de voitures que j'ai développé lorsque j'avais 17 ans.  Il est divise en 10 partie principal qui se répartise 92 pièces avec des petits détailles divers. En plus de cela, il y a aussi les pneus, caps de roue et divers pièces banal. Il est capabable d'ajouter, modifier, effacer, consultation et vente des pièces. Toute c'est opération sont accessible a partir d'un menu déroulant.

![image](https://github.com/gladir/Inventaire/assets/11842176/f79da549-1b0d-4148-9555-3d024b53bf0f)

<h3>MOTS DE PASSE</h3>

Il a des mots de passe aux endroits approprié. Lorsqu'il sont sauvegarder sur disque, il est codé de manières a ce que ce ne sois pas évidant en jettant un coup d'yeux avec une commande TYPE afin de connaitre le mots de passe.

<h3>VIDEO</h3>

Bien qu'à la base il était prévu de fonctionner sur une carte monochrome texte, par la suite j'ai du l'adapter a la carte couleur a cause du changement d'idée d'autre que moi. Il manipule directement les cartes vidéo (Mémoire, Controller 6845) dans le but de performer au maximum.

<h3>COMPILATION</h3>

Lors de la compilation l'ordinateur doit disposer d'un minimum de 620Ko de mémoire libre et du Turbo Pascal 6. Le programme a été concu au départ sur un XT 10Mhz, CGA d'ATI, 640Ko, Disque dur 32 Megs et par la suite sur XT 10Mhz, SVGA de IT-VGA2 (Tseng Labs 4000) avec un 1 Meg de mémoire vidéo. Mais la véritable machine sur lequel il a été programmer a été sur un AT 286-12Mhz 1Meg, carte vidéo CGA d'ATI, modèle portable, Disque dur 40 Megs a cause des complications de manque de mémoire. Dut au immense problème de RAM et d'espace disque insuffisant, je conseillerais de le compiler sur un machine disposant de 2 Meg de mémoire (travaillez pour fonctionner efficacement) en plus d'un disque dur disposant de 3 Meg de libre (pour les code source, unité et 
swapping).

Voici la ligne de commande pour effectué la compilation :
<code>
TPC invent.pas /B /$D-
</code>

<h3>DETAIL SUR LES FICHIERS</h3>

<table>
  <tr>
    <th>Nom du fichier</th>
    <td>Description</td>
  </tr>
  <tr>
    <td><b>BIOS_PRN.PAS</b></td>
    <td>Gestionnaire BIOS de l'imprimante.</td>
  </tr>
  <tr>
     <td><b>ECRMONO.PAS</b></td>
     <td>Gestionnaire monochrome de l'‚cran (maintenant adapter au couleur).</td>
  </tr>
  <tr>
    <td><b>ENTETE.INV</b></td>
    <td>Imprime l'entete des factures</td>
  </tr>
  <tr>
    <td><b>EXTRA.INV</b></td>
    <td>Inclassable, c'est divers...</td>
  </tr>
  <tr>
    <td><b>FAC.INV</b></td> 
    <td>Imprime les factures.</td>
  </tr>
  <tr>
    <td><b>FICHIER.PAS</b></td>
    <td>Gestionnaire des fichiers (par Handle).</td>
  </tr>
  <tr>
    <td><b>IAXLE.PAS</b></td>
    <td>Gestionnaire des piŠces de l'axle.</td>
  </tr>
  <tr>
    <td><b>ICHAINE.PAS</b></td> 
    <td>Gestionnaire des chaines de caractères.</td>
  </tr>
  <tr>
    <td><b>ICLAVIER.PAS</b></td>
    <td>Gestionnaire du clavier (bas‚ sur le BIOS, il ‚mule le DOS...)</td>
  </tr>
  <tr>
    <td><b>ICLIENT.PAS</b></td> 
    <td>Gérent tout ce qui a rapport au client...</td>
  </tr>
  <tr>
    <td><b>ICOWL.PAS</b></td>
    <td>Gestionnaire des pièces du cowl.</td>
  </tr>
  <tr>
    <td><b>IDATA.PAS</b></td>
    <td>Gestionnaire des donn‚es du programme inventaire.</td>
  </tr>
  <tr>
    <td><b>IDERR.PAS</b></td>
    <td>Gestionnaire des pièces du derrière du véhicule.</td>
  </tr>
  <tr>
    <td><b>IDESCR.PAS</b></td> 
    <td>Entrée des descriptions</td>
  </tr>
  <tr>
    <td><b>IDESMOD.PAS</b></td>
    <td>Modification des descriptions</td>
  </tr>
  <tr>
    <td><b>IDEVANT.PAS</b></td>
    <td>Gestionnaire des pièces de devant du véhicule.</td>
  </tr>
  <tr>
    <td><b>IEFFACE.PAS</b></td> 
    <td>Efface du fichier se que tu lui demande...</td>
  </tr>
  <tr>
    <td><b>IENREG.PAS</b></td> 
    <td>Traite les enregistrements pour les mettres sur disque.</td>
  </tr>
  <tr>
    <td><b>IFICHIER.PAS</b></td> 
    <td>Complementaire a FICHIER.PAS</td>
  </tr>
  <tr>
    <td><b>IFREINS.PAS</b></td>
    <td>Gestionnaire des piŠces du freins.</td>
  </tr>
  <tr>
      <td><b>IGETFILE.PAS</b></td> 
      <td>Affiche les pieces que vous souhaitez.</td>
  </tr>
  <tr>
    <td><b>IMENU.PAS</b></td>
    <td>Affiche les menus.</td>
  </tr>
  <tr>
    <td><b>IMODIFIE.PAS</b></td> 
    <td>Fait des modifications dans les enregistrements.</td>
  </tr>
  <tr>
    <td><b>IMOTOR.PAS</b></td>
    <td>Gestionnaire des pièces du moteur.</td>
  </tr>
  <tr>
    <td><b>IMPRICLI.INV</b></td>
    <td>Imprime les clients</td>
  </tr>
  <tr>
      <td><b>INTRO.PAS</b></td>
      <td>Présentation pitoresque du programme</td>
  </tr>
  <tr>
    <td><b>INVENT.PAS</b></td> 
    <td>Le coeur du programme (MAIN).</td>
  </tr>
  <tr>
    <td><b>IPASSWOR.PAS</b></td>
    <td>Gérent les mots de passe.</td>
  </tr>
  <tr>  
    <td><b>IPCEMOT.PAS</b></td> 
    <td>Gestionnaire des pièces du moteur.</td>
  </tr>
  <tr>    
    <td><b>IPNEUS.PAS</b></td> 
    <td>Gestionnaire des pneus</td>
  </tr>
  <tr>
      <td><b>IPORTE.PAS</b></td>
      <td>Gestionnaire des portes</td>
  </tr>
  <tr>
    <td><b>IQUEST.PAS</b></td> 
    <td>Gestionnaire des questions en tout genre.</td>
  </tr>
  <tr>
    <td><b>IRAPPORT.PAS</b></td> 
    <td>Donne un bref rapport sur imprimante.</td>
  </tr>
  <tr>
    <td><b>ISLCPCE.PAS</b></td>
    <td>Sélection des pièces.</td>
  </tr>
  <tr>
    <td><b>ISUSPENS.PAS</b></td>
    <td>Gérent les pièces de la suspension.</td>
  </tr>
  <tr>
    <td><b>ITRANS.PAS</b></td>
    <td>Gérent les pièces de la transmission.</td>
  </tr>
  <tr>
    <td><b>IVENTE.PAS</b></td> 
    <td>Gérent les ventes.</td>
  </tr>
  <tr>
    <td><b>IVISUEL.PAS</b></td> 
    <td>Gestionnaire secondaire de l'écran (ou gadget).</td>
  </tr>
  <tr>
    <td><b>LAC.INV</b></td>
    <td>Lecture des anciens clients.</td>
  </tr>
  <tr>
    <td><b>LAF.INV</b></td>
    <td>Lecture des anciens factures.</td>
  </tr>
  <tr>
    <td><b>LTC.INV</b></td>
    <td>Lit tout les clients.</td>
  </tr>
  <tr>
    <td><b>NCLIENT.INV</b></td>
    <td>Nouveau clients.</td>
  </tr>
  <tr>
    <td><b>NOFACT.INV</b></td>
    <td>Pas de facture.</td>
  </tr>
  <tr>
    <td><b>PIECEMOT.INV</b></td>
    <td>Fixe Piece moteur.</td>
  </tr>
  <tr>
      <td><b>SAC.INV</b></td> 
      <td>Sauve ancien client</td>
  </tr>
  <tr>
    <td><b>SAF.INV</b></td>
    <td>Sauve ancien facture</td>
  </tr>
  <tr>
    <td><b>SPEED.PAS</b></td>
    <td>Petit truct pour avoir le contrôle absolute de la machine</td>
  </tr>
  <tr>
    <td><b>TSTPRN.PAS</b></td>
    <td>Teste si l'imprimante est prête</td>
  </tr>
  <tr>
    <td><b>VENTE.INV</b></td>
    <td>Pour les ventes</td>
  </tr>
</table>

<h3>LANCEMENT</h3>

Lors du lancement de l'executable, vous devez disposez d'un minimum de 400 Ko.

Il support les cartes CGA d'ATI, EGA, VGA, SVGA. La machine qui le fait fonctionner doit avoir des cartes vidéo 100% compatible au standard d'IBM.

Coté disque, il doit disposer d'un minimum de 100 Ko, si vous vous amusez avec les enregistrements, il peut alors grimper a des tailles maximal que permet le DOS.
