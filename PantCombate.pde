//Modulo PantCombate  
//elaborado por: Rubén Dario Hernandez Mendo
//fecha de creación: 17 de septiembre de 2021
//fecha de ultima modificación: 28 de noviembre de 2021
//comentario:

class PantCombate{
  PImage pasto;
  PImage desrt;
  PImage woods;
  Boton btnback;
  Boton btnatk;
  Boton btndef;
  Boton btnitem;
  Boton btnteam;
  TxtBatalla txt;
  TxtBatalla txte;
  TxtBatalla txtweak;
  TxtBatalla txtpoison;
  TxtBatalla txtice;
  TxtBatalla txtfire;
  TxtBatalla txtresist;
  TxtBatalla txtresiste;
  TxtBatalla txtdefup;
  TxtBatalla txtdefup2;

  ClickItem citpotn;
  ClickItem citfptn;
  ClickItem cittonic;
  ClickItem citalldef;
  int fasebatalla;
  boolean battleactive;
  boolean actionactive;
  boolean combatactive;
  boolean playrlocked;
  boolean enemylocked;
  Enemigo enemy;
  CoolDownTimer cdt;
  CoolDownTimer cdte;
  CoolDownTimer cdtp;
  boolean turn;
  boolean result;
  boolean intro;
  int action;
    
  PantCombate(){
    pasto=loadImage("sprite/backgr/pasto_ok.png");
    desrt=loadImage("sprite/backgr/desierto_ok.png");
    woods=loadImage("sprite/backgr/bosque_ok.png");
    btnback=new Boton(400,700,200,100,23);
    btnatk=new Boton(150,550,150,80,30);
    txt=new TxtBatalla(550,250,158,80,34);
    txte=new TxtBatalla(300,250,158,80,34);
    txtweak=new TxtBatalla(300,250,158,80,35);
    txtpoison=new TxtBatalla(550,250,158,80,37);
    txtice=new TxtBatalla(550,250,158,80,38);
    txtfire=new TxtBatalla(550,250,158,80,39);
    txtresist=new TxtBatalla(300,250,158,80,36);
    txtresiste=new TxtBatalla(550,250,158,80,36);
    txtdefup=new TxtBatalla(550,270,158,80,40);
    txtdefup2=new TxtBatalla(550,250,158,80,40);
    btndef=new Boton(400,550,150,80,31);
    btnitem=new Boton(650,550,150,80,32);
    btnteam = new Boton(150,700,165,140,41);
    btnback.activate();
    citpotn=new ClickItem(600,625,cf.sp,cf.sp,ITPTN);
    citfptn=new ClickItem(640,625,cf.sp,cf.sp,ITFPT);
    cittonic=new ClickItem(680,625,cf.sp,cf.sp,ITTNC);
    citalldef=new ClickItem(720,625,cf.sp,cf.sp,ITALLDEF);
    battleactive=BATTLEOFF;
    actionactive=ACTOFF;
    combatactive=false;
    intro=false;
    cdt=new CoolDownTimer(180);
    cdte=new CoolDownTimer(120);
    cdtp=new CoolDownTimer(120);
  }
  
  
  
  void display(){
    
    music();
    startBattle();
    selectBackgr(pers.terr);
    fill(255);
    text(lf.showString(7),400,100);
    controlCombate();
    displayPlanoControl();
    displayPlanoBatalla();
    displayPlanoHUD();
    if(actionactive && turn){
      cdtp.coolingDown();
    }
    if(actionactive && cdtp.isOff()){
      cdtp.deactivate();
      endAction();
    }
    if(actionactive && !turn){
      cdte.coolingDown();
    }
    if(actionactive && cdte.isOff()){
      cdte.deactivate();
      enemyEndAction();
    }
  }
  
  void selectBackgr(int t){
    switch(t){
      case CLBSQ: background(woods);
                  break;
      case CLPST: background(pasto);
                  break;
      case CLTRR: background(desrt);
                  break;            
    }
  }
 
  
  void startBattle(){

    if(!battleactive){
      fasebatalla=FBINTRO;
      battleactive=BATTLEON;
      createEnemies();
    }
    
  }
  
  void displayPlanoBatalla(){
    
    if(!perst.teamp){

      pers.battleDisplay();
     
    }
    else{
    
      perst.battleDisplay();
      
    }
    
    //println(perst.teamp);
      displayEnemies();
  }
  
  void displayPlanoHUD(){}
  
  void displayPlanoControl(){
    btnback.display();
    btnatk.display();
    txt.display();
    txtweak.display();
    txtresist.display();
    txte.display();
    txtpoison.display();
    txtice.display();
    txtfire.display();
    txtresiste.display();
    txtdefup.display();
    txtdefup2.display();
    btndef.display();
    btnitem.display();
    btnteam.display();
    citpotn.display();
    citfptn.display();
    cittonic.display();
    citalldef.display();
  }
  
  void displayEnemies(){
    enemy.display();
  }
  
  void mouseProcess(int x,int y,int b){

    if(btnback.isClicked(x,y) && b==LEFT){
      resetBattle();
      battleactive=BATTLEOFF;
      gc.musicManager(MSCOFF,false);
      gc.setPantAct(PNMAP);
      bitacora.agregaDatosLn("Se abandono el combate");
    }
    if(actionactive && btnatk.isClicked(x,y) && b==LEFT){
      btnatk.toggleMarked();
      txt.activate();
      combatAction(ACATK);
      iniciaAccion();
      println("boton de ataque");
    }

    if(actionactive && btndef.isClicked(x,y) && b==LEFT){
      btndef.toggleMarked();
      txtdefup2.activate();
      combatAction(ACDEF);
      iniciaAccion();
      println("boton de defensa");

    }
    
    if(actionactive && btnteam.isClicked(x,y) && b==LEFT){
      sfxteamc.trigger();
      
      if(!perst.teamp){


        btnteam.toggleMarked();
        perst.toggleTeam(); //de false a true
        pers.toggleTeam(); // de true a false
        iniciaAccion();
        bitacora.agregaDatosLn("\nCambio de personaje: ------- Chocobo -------\n");
    }
      else{

        btnteam.toggleMarked();
        perst.toggleTeam(); //de true a false
        pers.toggleTeam(); // de false a true
        iniciaAccion();
        bitacora.agregaDatosLn("\nCambio de personaje: ------- Don Jhon -------\n");
        
      }


    }
    if(actionactive && btnitem.isClicked(x,y) && b==LEFT && pers.hasItems()){
      btnitem.toggleMarked();
      if(pers.potn>0)
        citpotn.toggleActive();
      if(pers.fpot>0)  
        citfptn.toggleActive();
      if(pers.tonic>0)  
        cittonic.toggleActive();
      if(pers.alldef>0)
        citalldef.toggleActive();
      combatAction(ACITM);
    }
    if(actionactive && citpotn.isClicked(x,y) && b==LEFT){

      accionConsumo(ITPTN); 
      accionConsumo(ITPTN);
      iniciaAccion();

    }
    if(actionactive && citfptn.isClicked(x,y) && b==LEFT){
     
      accionConsumo(ITFPT);
      accionConsumo(ITFPT);
      iniciaAccion();

    }

    if(actionactive && cittonic.isClicked(x,y) && b==LEFT){
      
      accionConsumo(ITTNC);
      accionConsumo(ITTNC);
      iniciaAccion();
    }

    if(actionactive && citalldef.isClicked(x,y) && b==LEFT){
      accionConsumo(ITALLDEF);
      accionConsumo(ITALLDEF);
      txtdefup.activate();
      iniciaAccion();
    }
  }

    void accionConsumo(int i){
    pers.consumeItem(i);
    perst.consumeItem(i);
    bitacora.agregaDatosLn(registraConsumoItem(pers,i));
    iniciaAccion();
  }
  
  void controlCombate(){
    switch(fasebatalla){
      case FBINTRO: controlEspera();
                    enemySnd();
                    break;
      case FBCOMBT: iniciaBatalla();
                    controlAcciones();
                    break;
      case FBEND:   controlEspera();
                    break;
      case FBEXIT:  resetBattle();
                    cambiaPantalla();              
    }
  }
  
  void combatAction(int a){
    int atkp;
    int defe;
    int tirada;
    action=a;
    
    switch(action){
      case ACATK: tirada=td.tira2D6();
                  atkp= (!perst.teamp) ? pers.getAtkDamage()+td.tira2D6() : perst.getAtkDamage()+td.tira2D6(); 
                  defe=enemy.getDefDamage();
                  if(atkp>defe){
                    enemy.herida(atkp-defe);
                    txtweak.activate();
                    sfxsword.trigger();
                    if(!enemy.isAlive()){
                      enemy.playSfx(ENFXDED);
                      resultVictory();
                      bitacora.agregaDatosLn(generaDatosVictory());
                                            
                    }
                    bitacora.agregaDatosLn(registrodeCombate(enemy,pers,tirada,TURNP));
                  }
                  if(atkp<defe){
                     txtresist.activate();
                  }
                  break;
      case ACDEF: if(!perst.teamp)
                  pers.toggleDefense();
                  else
                  perst.toggleDefense();
    }
    cdt.activate();
  }
  String generaDatosVictory(){
    String s="";
    s="Enemigo derrotado";
    return s;
  }
  
  void createEnemies(){
    enemy=new Enemigo(pers.terr,dcbt);  
  }
  
  void toggleAction(){
    actionactive=!actionactive;
  }
  
  void iniciaAccion(){
    if(!cdtp.isActive()){
      cdtp.activate();
      setTurn(TURNP);
    }  
  }

  void controlEspera(){
    if(!cdt.isActive())
      cdt.activate();
    if(cdt.isActive())
      cdt.coolingDown();
    if(cdt.isOff()){
      cdt.deactivate();
      fasebatalla=nextFB();
    }  
  }
  
  void iniciaBatalla(){
    if(!combatactive){
      combatactive=true;
      turn=TURNP;
      if(!perst.teamp) 
        pers.activateCombat();
      else
        perst.activateCombat();
      enemy.activateCombat();
      playrlocked=false;
      enemylocked=false;
      bitacora.agregaDatosLn(registraInicioCombate(enemy,pers));

      
    }
  }
  
  void controlAcciones(){
    if(pers.cdtturn.isActive()){

      pers.cdtturn.coolingDown();
      
    }
    if(perst.cdtturn.isActive()){

      perst.cdtturn.coolingDown();
      
    }  
    if(pers.cdtturn.isOff() && !enemylocked){
      if(pers.alldefd>0){
      txtdefup.activate();
      }
      enemy.cdtturn.togglePause();
      pers.cdtturn.deactivate();
      toggleEnemyLocked();
      btnatk.activate();
      btndef.activate();
      btnitem.activate();
      btnteam.activate();
      toggleAction();
    }
    if(perst.cdtturn.isOff() && !enemylocked){
      if(pers.alldefd>0){
      txtdefup.activate();
      }
      enemy.cdtturn.togglePause();
      perst.cdtturn.deactivate();
      toggleEnemyLocked();
      btnatk.activate();
      btndef.activate();
      btnitem.activate();
      btnteam.activate();
      toggleAction();
    }
    if(enemy.cdtturn.isActive()){
      enemy.cdtturn.coolingDown();
    }  
    if(enemy.cdtturn.isOff() && !playrlocked){
      pers.cdtturn.togglePause();
      perst.cdtturn.togglePause();
      enemy.cdtturn.deactivate();
      togglePlayrLocked();
      toggleAction();
      iniciaEnemyAction();
    }
  }
  
  int nextFB(){
    return fasebatalla==FBINTRO?FBCOMBT:fasebatalla==FBCOMBT?FBEND:FBEXIT;
  }
  
  void cambiaPantalla(){
    gc.musicManager(MSCOFF,result);
    gc.setPantAct(result?(pers.exp>=pers.explimit?PNLVL:PNMAP):PNFIN);
  }
  
  void toggleEnemyLocked(){
    enemylocked=!enemylocked;
  }
  
  void togglePlayrLocked(){
    playrlocked=!playrlocked;
  }
  
  void iniciaEnemyAction(){
    if(!cdte.isActive()){
      cdte.activate();
      setTurn(TURNE);
      enemyAction();
    }
  }
  
  void enemyAction(){
    int atke=enemy.getAtkDamage()+td.tira2D6();
    int defp= (!perst.teamp) ? pers.getDefDamage() : perst.getDefDamage();

    txte.activate();

    if(atke>defp ){

      switch(pers.terr){

          case CLBSQ: txtpoison.activate();
                      bitacora.agregaDatosLn(typeGetDamege(pers));
                      break;
          case CLPST: txtice.activate();
                      bitacora.agregaDatosLn(typeGetDamege(pers));

                      break;
          case CLTRR: txtfire.activate();
                      bitacora.agregaDatosLn(typeGetDamege(pers));
                      break;            
      }
     
      if(!perst.teamp)
        pers.herida(atke-defp);
      else
        perst.herida(atke-defp);
        
      enemy.playSfx(ENFXATK);
      if(!pers.isAlive() && !perst.isAlive()){
        resultDefeat();
        sfxdeath.trigger();
      }
    }
    if(atke<defp){
      txtresiste.activate();
    }
    else
      sfxshild.trigger();
    
    if(pers.defactive)
      pers.toggleDefense();

    if(perst.defactive)
      perst.toggleDefense();
  }
  
  
  void endAction(){
    btnatk.deactive();
    btndef.deactive();
    txt.deactive();
    txtweak.deactive();
    txtresist.deactive();
    if(pers.alldefd==0){
    txtdefup.deactive();
    }
    if(perst.alldefd==0){
    txtdefup.deactive();
    }
    txtdefup2.deactive();
    btnitem.deactive();
    btnteam.deactive();
    toggleMarks();
  if(!perst.teamp){

    pers.cdtturn.deactivate();
    pers.cdtturn.activate();
  }
  else{

    perst.cdtturn.deactivate(); 
    perst.cdtturn.activate(); 
  } 
    toggleAction();
    enemy.cdtturn.togglePause();
    toggleEnemyLocked();
    if(pers.tonicd>0)
      pers.coolTonic();
      perst.coolTonic();
    if(pers.alldefd>0)
      pers.coolAlldef();
      perst.coolAlldef();
  }
  
  void enemyEndAction(){
    enemy.cdtturn.activate();
    pers.cdtturn.togglePause();
    perst.cdtturn.togglePause();
    txte.deactive();
    txtpoison.deactive();
    txtice.deactive();
    txtfire.deactive();
    txtresiste.deactive();
    togglePlayrLocked();
    toggleAction();
  }
  
  void setTurn(boolean t){
    turn=t;
  }
  
  void toggleMarks(){
    switch(action){
      case ACATK: btnatk.toggleMarked(); break;
      case ACDEF: btndef.toggleMarked(); break;
      case ACITM: btnitem.toggleMarked();
                  if(citpotn.active) citpotn.toggleActive();
                  if(citfptn.active) citfptn.toggleActive();
                  if(cittonic.active) cittonic.toggleActive();
                  if(citalldef.active) citalldef.toggleActive();
    }
  }
   
  void resetBattle(){
    pers.cdtturn.deactivate();
    perst.cdtturn.deactivate();
    enemy.cdtturn.deactivate();
    pers.tonicd=0;
    perst.tonicd=0;
    cdt.deactivate();
    cdtp.deactivate();
    cdte.deactivate();
    btnatk.deactive();
    btndef.deactive();
    txt.deactive();
    txte.deactive();
    txtpoison.deactive();
    txtice.deactive();
    txtfire.deactive();
    txtresiste.deactive();
    txtweak.deactive();
    txtresist.deactive();
    txtdefup.deactive();
    txtdefup2.deactive();
    btnitem.deactive();
    btnteam.deactive();
    battleactive=BATTLEOFF;
    combatactive=false;
    playrlocked=false;
    enemylocked=false;
    actionactive=ACTOFF;
    fasebatalla=FBINTRO;
    setTurn(TURNP);
    intro=false;
  }
  
  void resultVictory(){
    fasebatalla=FBEND;
    getLoot();
    result=RSVCT;
    gc.musicManager(MSCOFF,false);
    gc.musicManager(MSCON,true);
    bitacora.agregaDatosLn(registraFinCombate(enemy,pers,result));
    nextFB();
  }
  
  void resultDefeat(){
    fasebatalla=FBEND;
    result=RSDFT;
        bitacora.agregaDatosLn(registraFinCombate(enemy,pers,result));

    nextFB();
  }
  
  void enemySnd(){
    if(!intro){
      enemy.playSfx(ENFXINT);
      intro=true;
    }  
  }
  
  void getLoot(){
    
    pers.cash+=enemy.cash;
    getExp();
    pers.updateInv(enemy.item,TMBUY);
    perst.updateInv(enemy.item,TMBUY);
  }

  void getExp(){

    pers.exp+=enemy.exp;
    perst.exp+=enemy.exp;

  }

  void changeTeam(int p){

  }

  String registraInicioCombate(Enemigo e, Personaje p){
    String s="\n------------------------ Inicia nuevo combate ---------------------------\n";
    s=s+"Terreno de combate: "+((e.terr==1)?"Desierto":(e.terr==2)?"Bosque":"Praderas")+"\n";
    s=s+"Oponente:   -------------------------------- "+e.name+"\n";
    s=s+"Nivel actual del enemigo: "+e.lvl+"   -------- Nivel actual de personaje: "+p.lvl+"\n";
    s=s+"Nivel de ataque de enemigo: "+e.atk+"   ----- Nivel de ataque de personaje "+p.atk+"\n";
    s=s+"Nivel de defensa de enemigo: "+e.def+"   ---- Nivel de defensa de personaje: "+p.def+"\n";
    s=s+"Nivel de vida de enemigo: "+e.def+"   ------- Nivel de vida de personaje: "+p.hp+"\n";
    return s;
  }

  String typeGetDamege(Personaje p){
    String s="\n";
    if(!perst.teamp) s=s+"Don Jhon recibio daño elemental por: ";
    if(perst.teamp) s=s+"Chocobo recibio daño elemental por: ";
    s=s+(p.terr==CLBSQ?"Veneno":(p.terr==CLPST?"Hielo":"Fuego"));
    return s;
  }

  String registrodeCombate(Enemigo e, Personaje p,int ti,boolean t){
    int a;
    int d;
    String s="Acción\n";
    s=s+"Daño causado: "+ti+"\n";
    s=s+"Vida restante de "+e.name+": "+e.hp+"\n";
    if(t){
      a=p.getAtkDamage()+ti;
      d=e.getDefDamage();
      s=s+"Base de ataque: "+p.getAtkDamage()+" ------ Defensa de Enemigo: "+d+"\n";
      s=s+"Resultado: "+((a>d)?"Ataque exitoso":"Ataque fallido")+"\n";
    }
    else{
      a=e.getAtkDamage()+ti;
      d=p.getDefDamage();
      s=s+"Base de ataque: "+p.getAtkDamage()+" ------ Defensa de Enemigo: "+d+"\n";
      s=s+"Resultado: "+((a>d)?"Ataque exitoso":"Ataque fallido")+"\n";
    }
    s=s+"Fin de registro\n";
    return s;
  }

    String registraConsumoItem(Personaje p,int i){
    String s="------------------------ Cosumo de item ------------------------\n";
    s=s+(i==ITPTN?"Poción normal":(i==ITFPT?"Poción llena":i==ITTNC?"Tonico de poder":"Poción de defensa"))+" utilizado"+"\n";
    s=s+"Efecto: "+(i==ITPTN?"Curación":(i==ITFPT?"Curación total":i==ITTNC?"Tonico de poder":"Aumento de defensa"))+"\n"; 
    s=s+"Fin de registro\n";
    return s;
  }
  
  String registraFinCombate(Enemigo e, Personaje p,boolean v){
    String s="\n";
    if(v){
      s=s+"Puntos de vida actuales: "+p.hp+"\n";
      s=s+"----- Victoria -----"+"\n";
    }
    else{
      s=s+"----- Derrota, fin del juego -----\n";
    }
    s=s+"Fin del combate\n";
    s=s+"-------------------------------------------------------------------\n";
    return s;
  }

}
