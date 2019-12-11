create or replace package body gruppo2 as
    procedure autorimessanontrovata(id_sessione int default 0, nome varchar2, ruolo varchar2) is
    -- Parametri della sede corrente
    begin

        modGUI.apriPagina('HoC | ', id_sessione, nome, ruolo);
            modGUI.aCapo;

            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('IL VEICOLO SELEZIONATO NON PUO'' ESSERE PARCHEGGIATO NELLA SEDE SELEZIONATA');
            modGUI.chiudiIntestazione(2);


        modGUI.ChiudiPagina;
    end autorimessanontrovata;

    procedure competentGarageSearch2 (
        id_Sessione varchar2, 
        nome varchar2, 
        ruolo varchar2,
        idSedeCorrente integer,
        idVeicoloCorrente integer
    )   /*RETURN AREE%ROWTYPE*/
        AS

        tmp Aree%ROWTYPE;
        veicoloCorrente VEICOLI%ROWTYPE;
        SedeCorrente SEDI%ROWTYPE;
        p list_idaree := list_idaree();
        contatore integer :=0;
        vlunghezzamax integer   :=2147483648;
        vlarghezzamax integer   :=2147483648;
        valtezzamax integer     :=2147483648;
        vpesomax integer        :=2147483648;
        vid integer :=0;
        arid integer :=0;

        BEGIN
        if(idveicolocorrente=0) then
        modGUI.apriPagina('HoC | Veicolo non selezionato', id_Sessione, nome, ruolo);
            modGUI.aCapo;
            modGUI.apriDiv;
            modGUI.apriIntestazione(2);
            modGUI.inserisciTesto(' VEICOLO NON SELEZIONATO, SI PREGA DI AGGIUNGERE UN VEICOLO ');
            modGUI.chiudiIntestazione(2);
        else
                select * into veicoloCorrente from Veicoli where Veicoli.idVeicolo=idVeicoloCorrente;
                select * into sedeCorrente from Sedi sed where sed.idSede=idSedeCorrente;
            
                for autorimessa in (select * from Autorimesse)
                loop
                    if(autorimessa.idSede = SedeCorrente.idsede )
                        then
                        p:=queryricercaArea(id_Sessione, nome, ruolo, autorimessa.idautorimessa,VeicoloCorrente.idveicolo); 
                        contatore:=p.count;
                        for i in 1 ..   contatore
                        loop
                            select * into tmp from Aree where idArea=p(i) and 
                                    (
                                    (lunghezzamax<vlunghezzamax or larghezzamax<=vlarghezzamax or altezzamax<=valtezzamax or pesomax<=vpesomax) or
                                    (lunghezzamax<=vlunghezzamax or larghezzamax<vlarghezzamax or altezzamax<=valtezzamax or pesomax<=vpesomax) or
                                    (lunghezzamax<=vlunghezzamax or larghezzamax<=vlarghezzamax or altezzamax<valtezzamax or pesomax<=vpesomax) or
                                    (lunghezzamax<=vlunghezzamax or larghezzamax<=vlarghezzamax or altezzamax<=valtezzamax or pesomax<vpesomax)
                                    );
                            if tmp.idarea is not null then
                            valtezzamax:=tmp.altezzamax;
                            vlunghezzamax:=tmp.lunghezzamax;
                            vpesomax:=tmp.pesomax;
                            vlarghezzamax:=tmp.larghezzamax;
                            vid:=tmp.idarea;
                                else null; end if;
            
            
            
                        end loop;
                    else null;
                    end if;
            
                end loop; 
                    if(vid=0)then autorimessanontrovata(id_sessione,nome,ruolo);
                    else
                        select aree.idautorimessa into arid from aree where aree.idarea=vid;
            /*                update debug
                            set numero=vid
                            where id=1;*/
            
                                visualizzaAutorimessa(id_Sessione, nome, ruolo,arid);
                    end if;
            end if;

    end competentGarageSearch2;

    procedure formRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2) is
    begin
        modGUI.apriPagina('HoC | Ricerca Area', id_Sessione, nome, ruolo);
        modGUI.aCapo;
        modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('RICERCA AREA');
        modGUI.chiudiIntestazione(2);

        modGUI.apriForm('graphicResultRicercaArea');
            modGUI.inserisciInputHidden('id_Sessione', id_Sessione);
            modGUI.inserisciInputHidden('nome', nome);
            modGUI.inserisciInputHidden('ruolo', ruolo);
            modGUI.apriSelect('autorimessa', 'AUTORIMESSA');
                for cur_autorimesse in (select idAutorimessa, indirizzo from Autorimesse)
                    loop
                        modGUI.inserisciOpzioneSelect(cur_autorimesse.idAutorimessa, cur_autorimesse.indirizzo);
                    end loop;
            modGUI.chiudiSelect;
            modGUI.apriSelect('veicolo', 'VEICOLO', richiesto=>true);
                for cur_veicoli in (
                    select Veicoli.idVeicolo, Veicoli.Modello, Veicoli.Produttore , Veicoli.Targa
                    from Veicoli, VeicoliClienti, Clienti, Sessioni
                    where Sessioni.idSessione = id_Sessione AND
                        Clienti.idPersona = Sessioni.idPersona AND
                        VeicoliClienti.idCliente = Clienti.idCliente AND
                        Veicoli.idVeicolo = VeicoliClienti.idVeicolo

                )
                    loop
                        modGUI.inserisciOpzioneSelect(cur_veicoli.idVeicolo, cur_veicoli.Produttore || ' ' || cur_veicoli.Modello || ' - ' || cur_veicoli.Targa);
                    end loop;
            modGUI.chiudiSelect;
            modGUI.inserisciBottoneReset;
            modGUI.inserisciBottoneForm(testo=>'RICERCA AREA');
        modGUI.chiudiForm;
        modGUI.chiudiPagina;
    end formRicercaArea;

procedure introitiparziali(id_Sessione varchar2, nome varchar2, ruolo varchar2, idsedecorrente varchar2) is 
totaleabb integer :=0;
totalebigl integer :=0;
indirizzo varchar2 (100);
idsededapassare integer :=0;
--datafinevar varchar2(100);
--datafinets timestamp;

begin
    if(ruolo='R') then
    modGUI.apriPagina('HoC | Introiti', id_Sessione, nome, ruolo);
    modgui.acapo;
        modgui.apriintestazione(2);
        modgui.inseriscitesto('INTROITI TOTALI');
        modgui.chiudiintestazione(2);
        if(idsedecorrente=0) 
            then --tutte le sedi senza periodo
                modgui.apritabella;
                modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('SEDE');
                modGUI.intestazioneTabella('INTROITI INGRESSI ORARI');

                modGUI.intestazioneTabella('DETTAGLI');
                modgui.chiudirigatabella;
                for i in (select * from sedi)
                    loop
                        
                        select sum(ingora.costo) into totalebigl from ingressiorari ingora,box, aree, autorimesse aut where ingora.idbox=box.idbox and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=i.idsede and ingora.orauscita is not null; 
                        select sedi.indirizzo,sedi.idsede into indirizzo,idsededapassare from sedi where sedi.idsede=i.idsede;
                        if(totaleabb is null) then totaleabb:=0; end if;
                        if(totalebigl is null) then totalebigl:=0; end if;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(indirizzo);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(totalebigl||'€');
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                        modGUI.InserisciLente('gruppo2.visualizzaintroitiparzialiabb', id_sessione, nome, ruolo, idsededapassare);
                        modgui.chiudielementotabella;
                        modgui.chiudirigatabella;---------
                    end loop;         
                modgui.chiuditabella;
                
                select sum(abb.costoeffettivo) into totaleabb from abbonamenti abb;
                modgui.apritabella;
                modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('INTROITI TOTALI ABBONAMENTI');
                modGUI.ApriElementoTabella;
                modGUI.ElementoTabella(totaleabb);
                modGUI.ChiudiElementoTabella;
                modgui.chiudirigatabella();
                modgui.chiuditabella;
                
            else --sede specifica senza periodo
                select sum(ingora.costo) into totalebigl from ingressiorari ingora,box, aree, autorimesse aut where ingora.idbox=box.idbox and box.idarea=aree.idarea and aree.idautorimessa=aut.idautorimessa and aut.idsede=idsedecorrente and ingora.orauscita is not null; 
                select sedi.indirizzo,sedi.idsede into indirizzo,idsededapassare from sedi where sedi.idsede=idsedecorrente;
                if(totaleabb is null) then totaleabb:=0; end if;
                if(totalebigl is null) then totalebigl:=0; end if;
                modGUI.apriTabella;
                modGUI.ApriRigaTabella;
                modGUI.intestazioneTabella('SEDE');
                modGUI.intestazioneTabella('INTROITI BIGLIETTI');
                modGUI.intestazioneTabella('DETTAGLI');
                modgui.chiudirigatabella;
                modGUI.ApriElementoTabella; 
                modGUI.ElementoTabella(indirizzo);
                modGUI.ChiudiElementoTabella;
                modGUI.ApriElementoTabella;
                modGUI.ElementoTabella(totalebigl||'€');
                modGUI.ChiudiElementoTabella;
                modGUI.ApriElementoTabella;
                modGUI.InserisciLente('gruppo2.visualizzaintroitiparzialiabb', id_sessione, nome, ruolo, idsededapassare);
                modgui.chiudielementotabella;
                modgui.chiudirigatabella;        
                modgui.chiuditabella;
            end if;
            
            else 
    modGUI.apriPagina('HoC | Introiti', id_Sessione, nome, ruolo);
     modGUI.esitoOperazione('KO', 'Questa operazione è disponibile soltanto per il responsabile');
    end if; 
    modgui.apriintestazione(3);
            modgui.inseriscitesto('ALTRE OPERAZIONI');
            modgui.chiudiintestazione(3);
            modgui.apridiv(true);
            modgui.inseriscibottone(id_sessione,nome,ruolo,'TORNA INDIETRO','gruppo2.introiti');
            modgui.chiudidiv;
            modgui.chiudipagina;
end introitiparziali;

        procedure graphicResultRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2, autorimessa number, veicolo varchar2) is
            altezza_veicolo Veicoli.Altezza%TYPE;
            larghezza_veicolo Veicoli.Larghezza%TYPE;
            lunghezza_veicolo Veicoli.Lunghezza%TYPE;
            peso_veicolo Veicoli.Peso%TYPE;
            alimentazione_veicolo Veicoli.Alimentazione%TYPE;
            checkAlimentazione varchar2(1);
            produttore_veicolo Veicoli.Produttore%TYPE;
            modello_veicolo Veicoli.Modello%TYPE;
            headertab boolean := true;
        begin

            --Ottengo dimensioni del veicolo--
            select Altezza, Larghezza, Lunghezza, Peso, Alimentazione, Modello, Produttore
            into altezza_veicolo, larghezza_veicolo, lunghezza_veicolo, peso_veicolo, alimentazione_veicolo, modello_veicolo, produttore_veicolo
            from Veicoli
            where Veicoli.idVeicolo = veicolo;

            if(alimentazione_veicolo = 'GPL') then
                checkAlimentazione := 'T';
            else
                checkAlimentazione := 'F';
            end if;

            modGUI.apriPagina('HoC | Aree disponibili', id_Sessione, nome, ruolo);

                modGUI.aCapo;
                modGUI.apriIntestazione(2);
                    modGUI.inserisciTesto('AREE DISPONIBILI PER: ' || produttore_veicolo || ' ' || modello_veicolo);
                modGUI.chiudiIntestazione(2);
                    for cur_aree in (
                        select idarea, lunghezzamax, larghezzamax, pesomax, altezzamax, gas
                        from aree
                        where aree.idautorimessa = autorimessa AND
                            aree.lunghezzamax >= lunghezza_veicolo AND
                            aree.altezzamax >= altezza_veicolo AND
                            aree.larghezzamax >= larghezza_veicolo AND
                            aree.pesomax >= peso_veicolo AND
                            aree.gas = checkAlimentazione
                    )
                        loop
                    if(headertab) then
                    modGUI.apriDiv;
                        modGUI.apriTabella;
                        modGUI.apriRigaTabella;
                            modGUI.IntestazioneTabella('AREA');
                            modGUI.IntestazioneTabella('LUNGHEZZA MAX');
                            modGUI.IntestazioneTabella('LARGHEZZA MAX');
                            modGUI.IntestazioneTabella('ALTEZZA MAX');
                            modGUI.IntestazioneTabella('PESO MAX');
                            modGUI.IntestazioneTabella('GAS');
                        modGUI.chiudiRigaTabella;
                        headertab := false;
                    end if;
                    modGUI.apriRigaTabella;
                        modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(cur_aree.idArea);
                        modGUI.chiudiElementoTabella;modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(cur_aree.LunghezzaMax);
                        modGUI.chiudiElementoTabella;modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(cur_aree.LarghezzaMax);
                        modGUI.chiudiElementoTabella;modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(cur_aree.AltezzaMax);
                        modGUI.chiudiElementoTabella;modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(cur_aree.PesoMax);
                        modGUI.chiudiElementoTabella;modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(cur_aree.Gas);
                        modGUI.chiudiElementoTabella;
                    modGUI.chiudiRigaTabella;
                end loop;
                modGUI.chiudiTabella;
                if(headertab) then
                    modGUI.esitoOperazione('KO', 'Non Ã¨ stata trovata nessun''area disponibile per il tuo veicolo!');
                else
                    modGUI.chiudiDiv;
                end if;
            modGUI.chiudiPagina;
        end graphicResultRicercaArea;

procedure introiti(id_Sessione varchar2, nome varchar2, ruolo varchar2) is 

begin
    if (ruolo='R') then
    modGUI.apriPagina('HoC | Visualizza Introiti', id_Sessione, nome, ruolo);

    modgui.acapo;

        modgui.apriintestazione(2);
        modgui.inseriscitesto('VISUALIZZA INTROITI');
        modgui.chiudiintestazione(2);
modgui.apriForm('gruppo2.introitiparziali');

        modgui.inserisciinputhidden('id_Sessione',id_Sessione);
        modgui.inserisciinputhidden('nome',nome);
        modgui.inserisciinputhidden('ruolo',ruolo);

                modGUI.apriSelect('idSedeCorrente', 'Seleziona Sede: ', false, 'defSelect');
        modGUI.inserisciOpzioneSelect('0','Tutte le Sedi',false);

        for sede in (select * from sedi)
        loop
        modGUI.inserisciOpzioneSelect(sede.idsede,sede.indirizzo,false);
        end loop;

        modGUI.chiudiSelect;
    
    



        modGUI.inserisciBottoneReset('RESET');
        modGUI.inserisciBottoneForm('Submit','defFormButton');

        modgui.chiudiForm;

        modGUI.chiudiPagina;

    else 
    modGUI.apriPagina('HoC | Inserisci dati', id_Sessione, nome, ruolo);
     modGUI.esitoOperazione('KO', 'Questa operazione è disponibile soltanto per il responsabile');
    modGUI.chiudiPagina;
    end if; 
end introiti;
    procedure modificaArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) AS
        area Aree%ROWTYPE;
        indirizzo_autorimessa Autorimesse.Indirizzo%TYPE;
        id_responsabile Dipendenti.idDipendente%TYPE;
        id_dipendente Dipendenti.idDipendente%TYPE;
    BEGIN

        begin
            select * into area
            from Aree
            where Aree.idArea = idRiga;
        exception
            when no_data_found then
                area := null;
        end;
        
        modGUI.apriPagina('HoC | Modifica Area ' || area.idArea || ' di ' || indirizzo_autorimessa, id_Sessione, nome, ruolo);
            modGUI.apriDiv;
            if (ruolo <> 'A' or ruolo <> 'R' or ruolo <> 'O') then
                modGUI.esitoOperazione('KO', 'Non sei autorizzato');
            elsif (area.idArea is null) then
                modGUI.esitoOperazione('KO', 'Nessuna area trovata');
            else
                modGUI.apriIntestazione(2);
                    modGUI.inserisciTesto('Modifica Area ' || area.idArea || ' di ' || indirizzo_autorimessa);
                modGUI.chiudiIntestazione(2);

                modGUI.apriForm('updateArea');
                    modGUI.inserisciInputHidden('id_sessione', id_sessione);
                    modGUI.inserisciInputHidden('nome', nome);
                    modGUI.inserisciInputHidden('ruolo', ruolo);
                    modGUI.inserisciInputHidden('idRiga', idRiga);

                    /* esempi di input testo del form*/
                    modGUI.inserisciTesto('Posti Totali');
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Posti Totali',
                        nome => 'var_posti_totali',
                        valore => area.PostiTotali,
                        richiesto => true
                    );
                    modGUI.inserisciTesto('Posti Liberi');
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Posti Liberi',
                        nome => 'var_posti_liberi',
                        valore => area.PostiLiberi,
                        richiesto => true
                    );
                    modGUI.inserisciTesto('Stato');
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Stato',
                        nome => 'var_stato',
                        valore => area.Stato,
                        richiesto => true
                    );
                    modGUI.inserisciTesto('Gas');
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Gas',
                        nome => 'var_gas',
                        valore => area.Gas,
                        richiesto => true
                    );
                    modGUI.inserisciTesto('Larghezza Massima');
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Larghezza Massima',
                        nome => 'var_larghezza_max',
                        valore => area.LarghezzaMax,
                        richiesto => true
                    );
                    modGUI.inserisciTesto('Lunghezza Massima');
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Lunghezza Massima',
                        nome => 'var_lunghezza_max',
                        valore => area.LunghezzaMax,
                        richiesto => true
                    );
                    modGUI.inserisciTesto('Altezza Massima');
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Altezza Massima',
                        nome => 'var_altezza_max',
                        valore => area.AltezzaMax,
                        richiesto => true
                    );
                    modGUI.inserisciTesto('Peso Massimo');
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Peso Massimo',
                        nome => 'var_peso_max',
                        valore => area.PesoMax,
                        richiesto => true
                    );
                    modGUI.inserisciTesto('Costo Abbonamento');
                    modGUI.inserisciInput(
                        tipo => 'number',
                        etichetta => 'Costo Abbonamento',
                        nome => 'var_costo_abbonamento',
                        valore => area.CostoAbbonamento,
                        richiesto => true
                    );

                    modGUI.inserisciBottoneReset('RESET');
                    modGUI.inserisciBottoneForm();
                modgui.chiudiForm;
            end if;
            modGUI.ChiudiDiv;
        modGUI.chiudiPagina;
    end modificaArea;

    procedure modificaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) AS
        autorimessa Autorimesse%ROWTYPE;
        id_dipendente_sede Dipendenti.idDipendente%TYPE;
        id_dipendente_corrente Dipendenti.idDipendente%TYPE;
    BEGIN

        begin
            select * into autorimessa
            from Autorimesse
            where Autorimesse.idAutorimessa = idRiga;
        exception
            when no_data_found then
                autorimessa := null;
        end;

        modGUI.apriPagina('HoC | Modifica Autorimessa di ' || autorimessa.indirizzo, id_Sessione, nome, ruolo);
            modGUI.aCapo;
            modGUI.apriDiv;
                if (ruolo <> 'A' and ruolo <> 'R') then
                    modGUI.esitoOperazione('KO', 'Non sei autorizzato a svolgere questa operazione');
                elsif (autorimessa.idAutorimessa is null) then
                    modGUI.esitoOperazione('KO', 'Nessuna autorimessa trovata');
                else
                    modGUI.apriIntestazione(2);
                        modGUI.inserisciTesto('Modifica Autorimessa di ' || autorimessa.indirizzo);
                    modGUI.chiudiIntestazione(2);

                    modGUI.apriForm('updateAutorimessa');
                        modGUI.inserisciInputHidden('id_sessione', id_sessione);
                        modGUI.inserisciInputHidden('nome', nome);
                        modGUI.inserisciInputHidden('ruolo', ruolo);
                        modGUI.inserisciInputHidden('idRiga', idRiga);

                        modGUI.inserisciTesto('Indirizzo');
                        modGUI.inserisciInput(
                            etichetta => 'Indirizzo',
                            nome => 'var_indirizzo',
                            valore => autorimessa.indirizzo,
                            richiesto => true
                        );
                        modGUI.inserisciTesto('Telefono');
                        modGUI.inserisciInput(
                            tipo => 'number',
                            etichetta => 'Telefono',
                            nome => 'var_telefono',
                            valore => autorimessa.telefono,
                            richiesto => true
                        );
                        modGUI.inserisciTesto('Coordinate');
                        modGUI.inserisciInput(
                            etichetta => 'Coordinate',
                            nome => 'var_coordinate',
                            valore => autorimessa.coordinate,
                            richiesto => true
                        );

                        modGUI.inserisciBottoneReset();
                        modGUI.inserisciBottoneForm();
                    modgui.chiudiForm;
                end if;
            modGUI.ChiudiDiv;
        modGUI.chiudiPagina;
    end modificaAutorimessa;

    procedure modificaSede(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) AS
        sede Sedi%ROWTYPE;
    BEGIN
        begin
            select * into sede
            from Sedi
            where Sedi.idSede = idRiga;
        exception
          when no_data_found then
            sede := null;
        end;
        
        
        modGUI.apriPagina('HoC | Modifica Sede di ' || sede.indirizzo, id_Sessione, nome, ruolo);
            modGUI.aCapo;
                modGUI.apriDiv;
                -- Se il ruolo dell'utente non Ã¨ amministratore esce
                if (ruolo <> 'A') then
                    modGUI.esitoOperazione('KO', 'Non sei un amministratore');
                elsif (sede.idSede is null) then
                    modGUI.esitoOperazione('KO', 'Autorimessa non trovata');
                else
                    modGUI.apriIntestazione(2);
                        modGUI.inserisciTesto('Modifica Sede di ' || sede.indirizzo);
                    modGUI.chiudiIntestazione(2);
                    /* 
                    * Il primo parametro di apriForm indica l'azione da compiere una volta cliccato il tasto di invio
                    * (classico esempio reindirizzamento ad una procedura che si occupa della query di inserimento degli input immessi)
                    */
                    modGUI.apriForm(groupname || 'updateSede');
                        modGUI.inserisciInputHidden('id_sessione', id_sessione);
                        modGUI.inserisciInputHidden('nome', nome);
                        modGUI.inserisciInputHidden('ruolo', ruolo);
                        modGUI.inserisciInputHidden('idRiga', idRiga);

                        modGUI.inserisciTesto('Indirizzo');
                        modGUI.inserisciInput(
                            etichetta => 'Indirizzo',
                            nome => 'var_indirizzo',
                            valore => sede.indirizzo,
                            richiesto => true
                        );
                        modGUI.inserisciTesto('Telefono');
                        modGUI.inserisciInput(
                            tipo => 'number',
                            etichetta => 'Telefono',
                            nome => 'var_telefono',
                            valore => sede.telefono,
                            richiesto => true
                        );
                        modGUI.inserisciTesto('Coordinate');
                        modGUI.inserisciInput(
                            etichetta => 'Coordinate',
                            nome => 'var_coordinate',
                            valore => sede.coordinate,
                            richiesto => true
                        );
                        modGUI.inserisciBottoneReset();
                        modGUI.inserisciBottoneForm();
                    modgui.chiudiForm;
                end if;
            modGUI.ChiudiDiv;
        modGUI.chiudiPagina;
    end modificaSede;

    function queryRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2, autorimessa varchar2, veicolo varchar2) 
        return list_idaree is


        altezza_veicolo Veicoli.Altezza%TYPE;
        larghezza_veicolo Veicoli.Larghezza%TYPE;
        lunghezza_veicolo Veicoli.Lunghezza%TYPE;
        peso_veicolo Veicoli.Peso%TYPE;
        alimentazione_veicolo Veicoli.Alimentazione%TYPE;
        checkAlimentazione varchar2(1);
        produttore_veicolo Veicoli.Produttore%TYPE;
        modello_veicolo Veicoli.Modello%TYPE;
        headertab boolean := true;
        p list_idaree := list_idaree();
        total integer;
    begin
        
        --Ottengo dimensioni del veicolo--
        select Altezza, Larghezza, Lunghezza, Peso, Alimentazione, Modello, Produttore
        into altezza_veicolo, larghezza_veicolo, lunghezza_veicolo, peso_veicolo, alimentazione_veicolo, modello_veicolo, produttore_veicolo
        from Veicoli
        where Veicoli.idVeicolo = veicolo;

        if(alimentazione_veicolo = 'GPL') then
            checkAlimentazione := 'T';
        else
            checkAlimentazione := 'F';
        end if;
        
        --Ottengo le aree--
        for cur in (
            select idarea, lunghezzamax, larghezzamax, pesomax, altezzamax, gas
            from aree
            where aree.idautorimessa = autorimessa AND
            aree.lunghezzamax >= lunghezza_veicolo AND
            aree.altezzamax >= altezza_veicolo AND
            aree.larghezzamax >= larghezza_veicolo AND
            aree.pesomax >= peso_veicolo AND
            aree.gas = checkAlimentazione
        ) loop 
            p.extend;
            p(p.count) := cur.idarea;
        end loop;

        return p;
    end queryRicercaArea;

    procedure resSediSovrappopolate(id_Sessione varchar2, nome varchar2, ruolo varchar2, var_giorno varchar2, var_soglia number) AS
        var_check1 boolean := false;
        Sede number:=0;
        NumeroAttuale number:=0;
        NumeroNuovo number:=0;
        indirizzo varchar2(40);
            begin

                modGUI.apriPagina('HoC | Sedi sovrappopolate', id_Sessione, nome, ruolo);

            modGUI.aCapo;
            modGUI.apriIntestazione(3);
            modGUI.inserisciTesto('SEDI SOVRAPPOPOLATE');
            modGUI.aCapo;
            modGUI.inserisciTesto('Giorno: ' || to_date(var_giorno, 'yyyy/mm/dd'));
            modGUI.chiudiIntestazione(3);

            modGUI.apriTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('SEDE');
                    modGUI.intestazioneTabella('INGRESSI TOTALI');
                modGUI.chiudiRigaTabella;

            for scorriCursoreAbbonamenti in( with
        TotIngressiOrari as (
            select Sedi.idSede, Sedi.Indirizzo, count(IngressiOrari.idIngressoOrario) as NumOrari
            from IngressiOrari
                join Box on Box.idBox = IngressiOrari.idBox
                join Aree on Aree.idArea = Box.idArea
                join Autorimesse on Autorimesse.idAutorimessa = Aree.idAutorimessa
                join Sedi on Sedi.idSede = Autorimesse.idSede
                where IngressiOrari.OraEntrata >= TO_TIMESTAMP(var_giorno, 'yyyy-mm-dd')
                and IngressiOrari.OraUscita <= TO_TIMESTAMP(var_giorno || ' 23:59:00', 'yyyy-mm-dd hh24:mi:ss')
            group by Sedi.idSede, Sedi.Indirizzo
        ),
        TotIngressiAbbonamenti as (
            select Sedi.idSede, Sedi.Indirizzo, count(IngressiAbbonamenti.idIngressoAbbonamento) as NumAbb
            from IngressiAbbonamenti
                join Box on Box.idBox = IngressiAbbonamenti.idBox
                join Aree on Aree.idArea = Box.idArea
                join Autorimesse on Autorimesse.idAutorimessa = Aree.idAutorimessa
                join Sedi on Sedi.idSede = Autorimesse.idSede
                where IngressiAbbonamenti.OraEntrata >= TO_TIMESTAMP(var_giorno, 'yyyy-mm-dd')
                and IngressiAbbonamenti.OraUscita <= TO_TIMESTAMP(var_giorno || ' 23:59:00', 'yyyy-mm-dd hh24:mi:ss')
            group by Sedi.idSede, Sedi.Indirizzo
        )
        select TotIngressiOrari.idSede as IDSede, TotIngressiOrari.Indirizzo as Indirizzo, coalesce(TotIngressiAbbonamenti.NumAbb, 0) + coalesce(TotIngressiOrari.NumOrari, 0) as TotIngressi
        from TotIngressiAbbonamenti
        full outer join TotIngressiOrari on TotIngressiAbbonamenti.idSede = TotIngressiOrari.idSede
        order by TotIngressiOrari.idSede)


            loop
            Sede:=scorriCursoreAbbonamenti.idsede;
            NumeroAttuale:=scorriCursoreAbbonamenti.TotIngressi;
            indirizzo:=scorriCursoreAbbonamenti.indirizzo;
            if(NumeroAttuale>var_soglia)then
                var_check1 := true;
                modGUI.apriRigaTabella;
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(indirizzo);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(scorriCursoreAbbonamenti.TotIngressi);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
            end if;
            end loop;
            modGUI.chiudiTabella;
            if(var_check1 = false) then 
                modGUI.apriDiv(centrato=>true);
                    modGUI.inserisciTesto('NESSUN RISULTATO');
                modGUI.chiudiDiv;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
            end if;
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('ALTRE OPERAZIONI');
            modGUI.chiudiIntestazione(3);
            modGUI.apriDiv(centrato=>true);
                modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'NUOVA RICERCA', groupname || 'sediSovrappopolate');
            modGUI.chiudiDiv;


        END resSediSovrappopolate;
    
    procedure ricercaAutorimessa(id_Sessione varchar2, nome varchar2, ruolo varchar2) is
        tmp integer;
        idses integer;
        begin
            if(ruolo='O' or ruolo='R') then
                modGUI.apriPagina('HoC | Inserisci dati', id_Sessione, nome, ruolo);
                modGUI.aCapo;
                modGUI.apriDiv;
                modGUI.apriIntestazione(2);
                modGUI.inserisciTesto(' RICERCA AUTORIMESSA COMPETENTE ');
                modGUI.chiudiIntestazione(2);
                idses:=to_number(id_Sessione);
            /* 
                * Il primo parametro di apriForm indica l'azione da compiere una volta cliccato il tasto di invio
                * (classico esempio reindirizzamento ad una procedura che si occupa della query di inserimento degli input immessi)
                */
                /*modgui.apriForm(visualizzaautorimessa,idSessione,nome,ruolo,idSessione,nome,ruolo,'sede','veicolo'); */
                modgui.apriForm('gruppo2.competentGarageSearch2');
                modgui.inserisciinputhidden('id_Sessione',id_Sessione);
                modgui.inserisciinputhidden('nome',nome);
                modgui.inserisciinputhidden('ruolo',ruolo);


                /* esempi di input testo del form*/


                /*esempio di input select del form */

                modGUI.aCapo;
                modGUI.apriSelect('idSedeCorrente', 'Seleziona Sede: ', false, 'defSelect');

                for sede in (select * from sedi)
                loop
                modGUI.inserisciOpzioneSelect(sede.idsede,sede.indirizzo,false);
                end loop;

                modGUI.chiudiSelect;


                modGUI.aCapo;
                modGUI.apriSelect('idVeicoloCorrente', 'Seleziona Veicolo: ', true, 'defSelect');

                select distinct count(*) into tmp from veicoli vec;
                if(tmp=0) then 
                                modGUI.inserisciOpzioneSelect('','Nessun veicolo disponibile',false);
                else
                    for veicolo in (select distinct vec.* from veicoli vec)
                    loop
                        modGUI.inserisciOpzioneSelect(veicolo.idveicolo,'Veicolo: ' ||veicolo.produttore ||' '|| veicolo.modello || '     Targa: ' ||veicolo.targa,false);
                    end loop;
            end if;
                modGUI.chiudiSelect;
                modGUI.aCapo;

                /*esempio inserimento del bottone di reset dei campi e bottone invio dei dati*/

                modGUI.inserisciBottoneReset('RESET');
                modGUI.inserisciBottoneForm('Submit','defFormButton');
                modgui.chiudiForm;
            else
            modGUI.apriPagina('HoC | Inserisci dati', id_Sessione, nome, ruolo);
            modGUI.esitoOperazione('KO', 'Questa operazione è disponibile soltanto per gli operatori e i responsabili');
            end if;

            modGUI.chiudiPagina;
        end ricercaAutorimessa;
    
    procedure classificaSediPiuRedditizie(id_sessione int default 0, nome varchar2, ruolo varchar2) is
        -- ID della sede corrente
        id_sede Sedi.idSede%TYPE;
        indirizzo Sedi.Indirizzo%TYPE;
        num_ingressi int;
        -- Cursore che scorre nella query delle sedi ordinate per guadagno
        cursor sediCursor is
            with
                TotOrari as (
                    select S.idSede as idSede, count(*) as NumIngressi
                    from Sedi S
                        join Autorimesse AU on AU.idSede = S.idSede
                        join Aree AR on AR.idAutorimessa = AU.idAutorimessa
                        join Box B on B.idArea = AR.idArea
                        join IngressiOrari IO on IO.idBox = B.idBox
                    group by S.idSede
                ),
                TotAbbonamenti as (
                    select S.idSede as idSede, count(*) as NumIngressi
                    from Sedi S
                        join Autorimesse AU on AU.idSede = S.idSede
                        join Aree AR on AR.idAutorimessa = AU.idAutorimessa
                        join Box B on B.idArea = AR.idArea
                        join IngressiAbbonamenti IA on IA.idBox = B.idBox
                    group by S.idSede
                ),
                Totale as (
                    select idSede, sum(NumIngressi) as NumIngressi
                    from (
                        select * from TotOrari
                        union all
                        select * from TotAbbonamenti
                    )
                    group by idSede
                )
            select S.idSede, S.Indirizzo, T.NumIngressi
            from Sedi S
                join Totale T on T.idSede = S.idSede
            order by T.NumIngressi desc;
        begin
            -- Crea la pagina e l'intestazione
            modGUI.apriPagina(
                'HoC | Sedi piu` Redditizie',
                id_sessione => id_sessione,
                nome => nome,
                ruolo => ruolo
            );
            modGUI.aCapo;

            if (ruolo <> 'A') then
                modGUI.esitoOperazione('KO', 'Non sei autorizzato');
            else
                modGUI.apriIntestazione(3);
                    modGUI.inserisciTesto('SEDI PIU` REDDITIZIE');
                modGUI.chiudiIntestazione(3);

                modGUI.ApriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('ID Sede');
                    modGUI.intestazioneTabella('Indirizzo');
                    modGUI.intestazioneTabella('Numero Ingressi');
                    modGUI.intestazioneTabella('Dettagli');
                modGUI.ChiudiRigaTabella;
                -- Apre il cursore
                open sediCursor;
                -- Scorre il cursore
                loop
                    fetch sediCursor into id_sede, indirizzo, num_ingressi;
                    exit when sediCursor%NOTFOUND;
                    modGUI.ApriRigaTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(id_sede);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(indirizzo);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(num_ingressi);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.inserisciLente(groupname || 'visualizzaSede', id_sessione, nome, ruolo, id_sede);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                end loop;
                -- Chiude il cursore
                close sediCursor;
                modGUI.chiudiPagina;
            end if;
        end classificaSediPiuRedditizie;
    
   procedure statisticaalimentazione(id_sessione varchar2,nome varchar2, ruolo varchar2)is 
maxbox integer :=0;
var_indirizzo varchar2(100);
var_gas varchar2(1);
var_risp varchar2(100);
var_1 varchar2 (100);
var_2 varchar2 (100);

begin
    if(ruolo = 'A' or ruolo= 'S') then
    modGUI.apriPagina('HoC |  Statistica alimentazione', id_Sessione, nome, ruolo);
    modgui.acapo;
    modgui.apriintestazione(2);
    modgui.inseriscitesto('STATISTICA ALIMENTAZIONE');
    modgui.chiudiintestazione(2);
select tmp.count_box,tmp.indirizzo,tmp.gas into maxbox,var_indirizzo,var_gas from(
select count(box.idbox) as count_box,ar.indirizzo,aree.gas from box, aree,autorimesse ar where box.idarea=aree.idarea and aree.idautorimessa=ar.idautorimessa and box.occupato='T' group by ar.indirizzo,aree.gas order by count_box desc) tmp
where rownum=1;
    --if(var_gas='T') then var_risp:='a gas'; else var_risp:='a benzina'; end if;
    select DECODE(var_gas, 'T','Gas','Benzina')into var_risp from dual;
    

    modgui.apritabella;
    modgui.apririgatabella;
    modgui.intestazionetabella('NUMERO VEICOLI');
    modgui.aprielementotabella;
    modgui.elementotabella(maxbox);
    modgui.chiudielementotabella;
    modgui.chiudirigatabella;
    modgui.apririgatabella;
    modgui.intestazionetabella('ALIMENTAZIONE');
    modgui.aprielementotabella;
    modgui.elementotabella(var_risp);
    modgui.chiudielementotabella;
    modgui.chiudirigatabella;
        modgui.apririgatabella;
    modgui.intestazionetabella('PARCHEGGIO');
    modgui.aprielementotabella;
    modgui.elementotabella(var_indirizzo);
    modgui.chiudielementotabella;
    modgui.chiudirigatabella;
    modgui.chiuditabella;
    
modgui.chiudipagina;

else 
modGUI.apriPagina('HoC | Statistica alimentazione', id_Sessione, nome, ruolo);
     modGUI.esitoOperazione('KO', 'Non hai i permessi necessari.');
     modgui.chiudipagina;
     end if;
exception
when no_data_found then 
        modGUI.apriPagina('HoC | Statistica alimentazione', id_Sessione, nome, ruolo);
     modGUI.esitoOperazione('KO', 'Nessun veicolo parcheggiato');



end statisticaalimentazione;

    procedure updateArea(
        id_sessione int default 0,
        nome varchar2,
        ruolo varchar2,
        idRiga int,
        var_posti_totali Aree.PostiTotali%TYPE,
        var_posti_liberi Aree.PostiLiberi%TYPE,
        var_stato Aree.Stato%TYPE,
        var_gas Aree.Gas%TYPE,
        var_lunghezza_max Aree.LunghezzaMax%TYPE,
        var_larghezza_max Aree.LarghezzaMax%TYPE,
        var_peso_max Aree.PesoMax%TYPE,
        var_costo_abbonamento Aree.CostoAbbonamento%TYPE
    ) AS 
    BEGIN
        -- Aggiorna la sede
        update Aree set
            Aree.PostiTotali = var_posti_totali,
            Aree.PostiLiberi = var_posti_liberi,
            Aree.Stato = var_stato,
            Aree.Gas = var_gas,
            Aree.LunghezzaMax = var_lunghezza_max,
            Aree.LarghezzaMax = var_larghezza_max,
            Aree.PesoMax = var_peso_max,
            Aree.CostoAbbonamento = var_costo_abbonamento
        where Aree.idArea = idRiga;
        commit;
        -- Richiama la visualizzazione
        visualizzaArea(id_sessione, nome, ruolo, idRiga);
    end updateArea;
    
    procedure updateAutorimessa(
        id_sessione int default 0,
        nome varchar2,
        ruolo varchar2,
        idRiga int,
        var_indirizzo Autorimesse.Indirizzo%TYPE,
        var_telefono Autorimesse.Telefono%TYPE,
        var_coordinate Autorimesse.Coordinate%TYPE
    ) AS
        id_dipendente_sede Dipendenti.idDipendente%TYPE;
        id_dipendente_corrente Dipendenti.idDipendente%TYPE;
    BEGIN
        -- ID del dipendente corrente
        begin
            select Dipendenti.idDipendente
            into id_dipendente_corrente
            from Dipendenti
                join PersoneL on PersoneL.idPersona = Dipendenti.idPersona
                join Sessioni on Sessioni.idPersona = PersoneL.idPersona
            where Sessioni.idSessione = id_sessione;
        exception
            when NO_DATA_FOUND then
                id_dipendente_corrente := null;
        end;

        -- ID del dipendente responsabile della sede
        begin
            select Sedi.idDipendente
            into id_dipendente_sede
            from Sedi
                join Autorimesse on Autorimesse.idSede = Sedi.idSede
            where Autorimesse.idAutorimessa = idRiga;
        exception
            when NO_DATA_FOUND then
                id_dipendente_sede := null;
        end;

        if ((ruolo = 'A') or ((ruolo = 'R') and (id_dipendente_corrente = id_dipendente_sede))) then
            -- Aggiorna la sede
            update Autorimesse set
                Autorimesse.Indirizzo = var_indirizzo,
                Autorimesse.Telefono = var_telefono,
                Autorimesse.Coordinate = var_coordinate
            where Autorimesse.idAutorimessa = idRiga;
            commit;
        else
            modGUI.esitoOperazione('KO', 'Non sei autorizzato ad eseguire questa operazione');
        end if;

        -- Richiama la visualizzazione
        visualizzaAutorimessa(id_sessione, nome, ruolo, idRiga);
    end updateAutorimessa;

    procedure updateSede(
        id_sessione int default 0,
        nome varchar2,
        ruolo varchar2,
        idRiga int,
        var_indirizzo Sedi.Indirizzo%TYPE,
        var_telefono Sedi.Telefono%TYPE,
        var_coordinate Sedi.Coordinate%TYPE
    ) AS 
    BEGIN
        if (ruolo <> 'A') then
            modGUI.apriPagina('HoC | Update Sede', id_sessione, nome, ruolo);
                modGUI.apriDiv;
                    modGUI.esitoOperazione('KO', 'Non sei un amministratore');
                modGUI.chiudiDiv;
            modGUI.chiudiPagina;
        else
            -- Aggiorna la sede
            begin
                update Sedi set
                    Sedi.Indirizzo = var_indirizzo,
                    Sedi.Telefono = var_telefono,
                    Sedi.Coordinate = var_coordinate
                where Sedi.idSede = idRiga;
                commit;
                visualizzaSede(id_sessione, nome, ruolo, idRiga);
            exception
                when others then
                    modGUI.esitoOperazione('KO', 'Impossibile aggiornare la sede');
            end;
            -- Richiama la visualizzazione
        end if;
    end updateSede;

    procedure visualizzaArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) is
        -- Parametri dell'autorimessa corrente
        area Aree%ROWTYPE;
        -- Indirizzo dell'autorimessa di riferimento
        indirizzo_autorimessa Autorimesse.Indirizzo%TYPE;
        -- ID e indirizzo della sede di riferimento
        id_sede Sedi.idSede%TYPE;
        indirizzo_sede Sedi.Indirizzo%TYPE;
    begin
        begin
            -- Trova la sede
            select * into area
            from Aree
            where Aree.idArea = idRiga;
            -- Trova ID della sede e indirizzo dell'autorimessa
            select Autorimesse.idSede, Autorimesse.Indirizzo into id_sede, indirizzo_autorimessa
            from Autorimesse
            where Autorimesse.idAutorimessa = area.idAutorimessa;
            -- Trova l'indirizzo dell'autorimessa
            select Sedi.Indirizzo into indirizzo_sede
            from Sedi
            where Sedi.idSede = id_sede;
        exception
          when no_data_found then
            area := null;
        end;
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina('HoC | Area ' || area.idArea || ' di ' || indirizzo_autorimessa, id_sessione, nome, ruolo);
            modGUI.aCapo;

            if (area.idArea is null) then
                modGUI.esitoOperazione('KO', 'Nessuna area trovata');
            else

                modGUI.apriIntestazione(2);
                    modGUI.inserisciTesto('Area ' || area.idArea || ' di ' || indirizzo_autorimessa);
                modGUI.chiudiIntestazione(2);

                modGUI.ApriTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('ID Area');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.idArea);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Posti Totali');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.PostiTotali);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Posti Liberi');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.PostiLiberi);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Stato');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.Stato);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Gas');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.Gas);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Lunghezza Massima');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.LunghezzaMax);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Larghezza Massima');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.LarghezzaMax);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Altezza Massima');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.AltezzaMax);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Peso Massimo');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.PesoMax);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Costo Abbonamento');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(area.CostoAbbonamento);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Autorimessa');
                        modGUI.ApriElementoTabella;
                            modGUI.Collegamento(indirizzo_autorimessa, 'visualizzaAutorimessa?id_sessione=' || id_sessione || '&nome=' || nome || '&ruolo=' || ruolo || '&idRiga=' || area.idAutorimessa);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    if (ruolo <> 'O' and ruolo <> 'C') then
                        modGUI.ApriRigaTabella;
                            modGUI.IntestazioneTabella('Dettagli');
                            modGUI.ApriElementoTabella;
                                modGUI.InserisciPenna('modificaArea', id_sessione, nome, ruolo, idRiga);
                            modGUI.ChiudiElementoTabella;
                        modGUI.ChiudiRigaTabella;
                    end if;
                modGUI.ChiudiTabella;

                
                    modGUI.ApriTabella;
                        
                    modGUI.ChiudiTabella;
                

                -- Tabella delle autorimesse collegate
                modGUI.apriIntestazione(3);
                    modGUI.inserisciTesto('Box');
                modGUI.chiudiIntestazione(3);

                modGUI.apriTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.intestazioneTabella('ID Box');
                        modGUI.intestazioneTabella('Numero');
                        modGUI.intestazioneTabella('Piano');
                        modGUI.intestazioneTabella('Colonna');
                        modGUI.intestazioneTabella('Dettaglio');
                    for box in (select * from Box where Box.idArea = idRiga)
                    loop
                        modGUI.ApriRigaTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(box.idBox);
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(box.Numero);
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(box.Piano);
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(box.NumeroColonna);
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.inserisciLente(groupname || 'visualizzaBox', id_sessione, nome, ruolo, box.idBox);
                            modGUI.ChiudiElementoTabella;
                        modGUI.ChiudiRigaTabella;
                    end loop;
                modGUI.chiudiTabella;
            end if;
        modGUI.ChiudiPagina;
    end visualizzaArea;

    procedure visualizzaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) is
        -- Parametri dell'autorimessa corrente
        autorimessa Autorimesse%ROWTYPE;
        -- Indirizzo della sede di riferimento
        indirizzo_sede Sedi.Indirizzo%TYPE;
    begin
        begin
            -- Trova la sede
            select * into autorimessa
            from Autorimesse
            where Autorimesse.idAutorimessa = idRiga;
            -- Trova l'indirizzo della sede
            select Sedi.Indirizzo into indirizzo_sede
            from Sedi
            where Sedi.idSede = autorimessa.idSede;
        exception
          when no_data_found then
            autorimessa := null;
        end;
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina('HoC | Autorimessa di ' || autorimessa.indirizzo, id_sessione, nome, ruolo);
            modGUI.aCapo;

            if (autorimessa.idAutorimessa is null) then
                modGUI.esitoOperazione('KO', 'Nessuna autorimessa trovata');
            else
                modGUI.apriIntestazione(2);
                    modGUI.inserisciTesto('Autorimessa di ' || autorimessa.indirizzo);
                modGUI.chiudiIntestazione(2);

                modGUI.ApriTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('ID Autorimessa');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(autorimessa.idAutorimessa);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Indirizzo');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(autorimessa.Indirizzo);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Telefono');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(autorimessa.Telefono);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Coordinate');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(autorimessa.Coordinate);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Sede');
                        modGUI.ApriElementoTabella;
                            modGUI.Collegamento(indirizzo_sede, groupname || 'visualizzaSede?id_sessione=' || id_sessione || '&nome=' || nome || '&ruolo=' || ruolo || '&idRiga=' || autorimessa.idSede);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    if (ruolo <> 'O' and ruolo <> 'C') then
                        modGUI.apriRigaTabella;
                            modGUI.intestazioneTabella('Dettagli');
                            modGUI.apriElementoTabella;
                                modGUI.InserisciPenna(groupname || 'modificaAutorimessa', id_sessione, nome, ruolo, autorimessa.idAutorimessa);
                            modGUI.chiudiElementoTabella;
                        modGUI.chiudiRigaTabella;
                    end if;
                modGUI.ChiudiTabella;

                -- Tabella delle autorimesse collegate
                modGUI.apriIntestazione(3);
                    modGUI.inserisciTesto('Aree');
                modGUI.chiudiIntestazione(3);

                modGUI.apriTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.intestazioneTabella('ID Area');
                        modGUI.intestazioneTabella('Larghezza Massima');
                        modGUI.intestazioneTabella('Lunghezza Massima');
                        modGUI.intestazioneTabella('Altezza Massima');
                        modGUI.intestazioneTabella('Peso Massimo');
                        modGUI.intestazioneTabella('Dettaglio');
                    for area in (select * from Aree where Aree.idAutorimessa = idRiga)
                    loop
                        modGUI.ApriRigaTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(area.idArea);
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(area.LarghezzaMax || ' mm');
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(area.LunghezzaMax || ' mm');
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(area.AltezzaMax || ' mm');
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(area.PesoMax || ' kg');
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.inserisciLente(groupname || 'visualizzaArea', id_sessione, nome, ruolo, area.idArea);
                            modGUI.ChiudiElementoTabella;
                        modGUI.ChiudiRigaTabella;
                    end loop;
                modGUI.chiudiTabella;
            end if;
        modGUI.ChiudiPagina;
    end visualizzaAutorimessa;
    
    procedure visualizzaBox(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) is
        -- Parametri del box corrente
        var_box Box%ROWTYPE;
        -- Parametri di un eventuale veicolo
        veicolo Veicoli%ROWTYPE;
        -- ID e indirizzo dell'autorimessa di riferimento
        id_autorimessa Autorimesse.idAutorimessa%TYPE;
        indirizzo_autorimessa Autorimesse.Indirizzo%TYPE;
        -- ID dell'area di riferimento
        id_area Aree.idArea%TYPE;
    begin
        begin
            -- Trova la sede
            select * into var_box
            from Box
            where Box.idBox = idRiga;
            -- Trova ID della sede e indirizzo dell'autorimessa
            select Autorimesse.idSede, Autorimesse.Indirizzo, Aree.idArea into id_autorimessa, indirizzo_autorimessa, id_area
            from Autorimesse
            join Aree on Aree.idAutorimessa = Autorimesse.idAutorimessa
            where Aree.idArea = var_box.idArea;
        exception
          when no_data_found then
            var_box := null;
        end;
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina('HoC | Box ' || idRiga || ' area ' || var_box.idArea || ' di ' || indirizzo_autorimessa, id_sessione, nome, ruolo);
            modGUI.aCapo;
            if (var_box.idBox is null) then
                modGUI.esitoOperazione('KO', 'Nessun box trovato');
            else
                modGUI.apriIntestazione(2);
                    modGUI.inserisciTesto('Box ' || idRiga || ' - Area ' || var_box.idArea || ' di ' || indirizzo_autorimessa);
                modGUI.chiudiIntestazione(2);

                modGUI.ApriTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('ID Box');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(var_box.idBox);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Numero');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(var_box.Numero);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Piano');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(var_box.Piano);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Colonna');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(var_box.NumeroColonna);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Occupato');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(var_box.Occupato);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Riservato');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(var_box.Riservato);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Area');
                        modGUI.ApriElementoTabella;
                            modGUI.Collegamento(var_box.idArea, groupname || 'visualizzaArea?id_sessione=' || id_sessione || '&nome=' || nome || '&ruolo=' || ruolo || '&idRiga=' || id_area);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Autorimessa');
                        modGUI.ApriElementoTabella;
                            modGUI.Collegamento(indirizzo_autorimessa, groupname || 'visualizzaAutorimessa?id_sessione=' || id_sessione || '&nome=' || nome || '&ruolo=' || ruolo || '&idRiga=' || id_autorimessa);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;          
                modGUI.ChiudiTabella;

                -- Eventuale auto contenuta nel box
                if (var_box.Occupato = 'T') then
                    -- Trova il veicolo
                    select Veicoli.* into veicolo
                    from Veicoli
                        join EffettuaIngressiOrari on EffettuaIngressiOrari.idVeicolo = Veicoli.idVeicolo
                        join IngressiOrari on IngressiOrari.idIngressoOrario = EffettuaIngressiOrari.idIngressoOrario
                    where IngressiOrari.idBox = idRiga
                        and IngressiOrari.OraUscita is NULL;
                    -- Stampa le informazioni del veicolo
                    modGUI.apriIntestazione(3);
                        modGUI.inserisciTesto('Veicolo in sosta');
                    modGUI.chiudiIntestazione(3);
                    
                    modGUI.apriTabella;
                        modGUI.apriRigaTabella;
                            modGUI.apriIntestazione('ID Veicolo');
                            modGUI.apriIntestazione('Targa');
                            modGUI.apriIntestazione('Produttore');
                            modGUI.apriIntestazione('Modello');
                            modGUI.apriIntestazione('Colore');
                            modGUI.apriIntestazione('Dettaglio');
                        modGUI.chiudiRigaTabella;
                        modGUI.apriRigaTabella;
                            modGUI.apriElementoTabella;
                                modGUI.ElementoTabella(veicolo.idVeicolo);
                            modGUI.chiudiElementoTabella;
                        modGUI.ChiudiRigaTabella;
                        modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(veicolo.Targa);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(veicolo.Produttore);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(veicolo.Modello);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.ElementoTabella(veicolo.Colore);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.InserisciLente(groupname || 'visualizzaVeicolo', id_sessione, nome, ruolo, veicolo.idVeicolo);
                        modGUI.chiudiElementoTabella;
                    modGUI.chiudiTabella;
                end if;
            end if;
        modGUI.ChiudiPagina;
    end visualizzaBox;

 procedure visualizzaintroitiparzialiabb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idriga varchar2) as 
begin 
    if(ruolo='R') then
    modGUI.apriPagina('HoC | Introiti ', id_Sessione, nome, ruolo);

    for i in (select * from autorimesse aut where aut.idsede=idriga)
    loop
    modGUI.apriIntestazione(2);
        modGUI.inserisciTesto('Autorimessa ' || i.indirizzo);
    modGUI.chiudiIntestazione(2);

   
    
    modGUI.apriTabella;

                modGUI.ApriRigaTabella;
                    modGUI.intestazioneTabella('ID INGRESSO ORARIO');
                    modGUI.intestazioneTabella('COSTO EFFETTIVO');
                    modGUI.intestazioneTabella('DATA INIZIO');
                    modGUI.intestazioneTabella('DATA FINE');
                    modGUI.ChiudiRigaTabella;

    for n in (select io.* from box, ingressiorari io, aree where box.idbox=io.idbox and box.idarea=aree.idarea and aree.idautorimessa=i.idautorimessa and (io.oraentrata is not null or io.orauscita is not null) and io.costo is not null order by io.idingressoorario)
    --for n in (select io.* from box, ingressiorari io, aree where box.idbox=io.idbox and box.idarea=aree.idarea and aree.idautorimessa=i.idautorimessa and io.oraentrata is not null order by io.idingressoorario)
    loop
                        modGUI.ApriRigaTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(n.idingressoorario);
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(n.costo||'€');
                        modGUI.ChiudiElementoTabella;
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(to_char(n.oraentrata,'dd-MON-yy hh24:mi:ss'));
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(to_char(n.orauscita,'dd-MON-yy hh24:mi:ss'));
                        modGUI.ChiudiElementoTabella;
                        modGUI.ChiudiRigaTabella;           
    end loop;
    modGUI.ChiudiTabella;

    end loop;

 
    else 
    modGUI.apriPagina('HoC | Introiti', id_Sessione, nome, ruolo);
     modGUI.esitoOperazione('KO', 'Questa operazione è disponibile soltanto per il responsabile');
    modGUI.chiudiPagina;
    end if; 
       modgui.apriintestazione(3);
            modgui.inseriscitesto('ALTRE OPERAZIONI');
            modgui.chiudiintestazione(3);
            modgui.apridiv(true);
            modgui.inseriscibottone(id_sessione,nome,ruolo,'Torna indietro','gruppo2.introiti');
            modgui.chiudidiv;
    modgui.chiudipagina;
     
end visualizzaintroitiparzialiabb;

    procedure visualizzaSede(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) is
        -- Parametri della sede corrente
        sede Sedi%ROWTYPE;
        -- Nome del dipendente dirigente
        nome_dirigente Persone.Nome%TYPE;
        cognome_dirigente Persone.Cognome%TYPE;
    begin
        begin
            -- Trova la sede
            select * into sede
            from Sedi
            where Sedi.idSede = idRiga;
            -- Trova il nome del dirigente
            select nome, cognome into nome_dirigente, cognome_dirigente
            from Persone P
                join Dipendenti D on D.idPersona = P.idPersona
                where D.idDipendente = sede.idDipendente;
        exception
          when no_data_found then
            sede := null;
        end;
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina('HoC | Sede di ' || sede.indirizzo, id_sessione, nome, ruolo);
            modGUI.aCapo;
            if (sede.idSede is null) then
                modGUI.esitoOperazione('KO', 'Nessuna sede trovata');
            else
                modGUI.apriIntestazione(2);
                    modGUI.inserisciTesto('Sede di ' || sede.indirizzo);
                modGUI.chiudiIntestazione(2);

                modGUI.ApriTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('ID Sede');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(sede.idSede);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Indirizzo');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(sede.indirizzo);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Telefono');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(sede.telefono);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Coordinate');
                        modGUI.ApriElementoTabella;
                            modGUI.ElementoTabella(sede.coordinate);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.IntestazioneTabella('Dirigente');
                        modGUI.ApriElementoTabella;
                            modGUI.Collegamento(nome_dirigente || ' ' || cognome_dirigente, 'visualizzaDipendente?id_sessione=' || id_sessione || '&nome=' || nome || '&ruolo=' || ruolo || '&idRiga=' || sede.idDipendente);
                        modGUI.ChiudiElementoTabella;
                    modGUI.ChiudiRigaTabella;
                    modGUI.ApriRigaTabella;
                    if (ruolo <> 'O' and ruolo <> 'C') then
                        modGUI.IntestazioneTabella('Dettagli');
                        modGUI.ApriElementoTabella;
                            modGUI.InserisciPenna(groupname || 'modificaSede', id_sessione, nome, ruolo, sede.idSede);
                        modGUi.ChiudiElementoTabella;
                    end if;
                    modGUI.chiudiRigaTabella;
                modGUI.ChiudiTabella;

                -- Tabella delle autorimesse collegate
                modGUI.apriIntestazione(3);
                    modGUI.inserisciTesto('Autorimesse');
                modGUI.chiudiIntestazione(3);

                modGUI.apriTabella;
                    modGUI.ApriRigaTabella;
                        modGUI.intestazioneTabella('ID Autorimessa');
                        modGUI.intestazioneTabella('Indirizzo');
                        modGUI.intestazioneTabella('Telefono');
                        modGUI.intestazioneTabella('Coordinate');
                        modGUI.intestazioneTabella('Dettaglio');
                    for autorimessa in (select * from Autorimesse where Autorimesse.idSede = sede.idSede)
                    loop
                        modGUI.ApriRigaTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(autorimessa.idAutorimessa);
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(autorimessa.indirizzo);
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(autorimessa.telefono);
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.ElementoTabella(autorimessa.coordinate);
                            modGUI.ChiudiElementoTabella;
                            modGUI.ApriElementoTabella;
                                modGUI.inserisciLente(groupname || 'visualizzaAutorimessa', id_sessione, nome, ruolo, autorimessa.idAutorimessa);
                            modGUI.ChiudiElementoTabella;
                        modGUI.ChiudiRigaTabella;
                    end loop;
                modGUI.chiudiTabella;

            end if;
        modGUI.ChiudiPagina;
    end visualizzaSede;

    procedure ricercaAuto(id_Sessione int, nome varchar2, ruolo varchar2) is
    begin
        modGUI.apriPagina('HoC | Ricerca auto', id_Sessione, nome, ruolo);
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('RICERCA AUTO');
            modGUI.chiudiIntestazione(2);
            modGUI.apriForm('resRicercaAuto');
                modGUI.inserisciInputHidden('id_Sessione', id_Sessione);
                modGUI.inserisciInputHidden('nome', nome);
                modGUI.inserisciInputHidden('ruolo', ruolo);
                modGUI.apriSelect('var_idCliente', 'CLIENTE', true);
                for cur in (
                    select Clienti.idCliente CIDC, Persone.Nome PN, Persone.Cognome PC
                    from Clienti, Persone
                    where Persone.idPersona = Clienti.idPersona
                ) loop
                    modGUI.inserisciOpzioneSelect(cur.CIDC, cur.CIDC || ' ' || cur.PN || ' ' || cur.PC);
                end loop;
                modGUI.chiudiSelect;
                modGUI.inserisciBottoneReset;
                modGUI.inserisciBottoneForm(testo=>'RICERCA AUTO');
            modGUI.chiudiForm;
        modGUI.chiudiPagina;
    end ricercaAuto;
    
    procedure resRicercaAuto(id_Sessione int, nome varchar2, ruolo varchar2, var_idCliente int) is
    var_check1 boolean := false;
    var_check2 boolean := false;
    begin
        modGUI.apriPagina('HoC | Ricerca auto', id_Sessione, nome, ruolo);
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('RICERCA AUTO');
            modGUI.chiudiIntestazione(2);
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('PARCHEGGIO/I EFFETTUATO/I CON TICKET');
            modGUI.chiudiIntestazione(3);
            modGUI.apriTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('TARGA');
                    modGUI.intestazioneTabella('AUTO');
                    modGUI.intestazioneTabella('SEDE');
                    modGUI.intestazioneTabella('AUTORIMESSA');
                    modGUI.intestazioneTabella('AREA');
                    modGUI.intestazioneTabella('BOX');
                modGUI.chiudiRigaTabella;
                for curr_or in (
                    select distinct Veicoli.Targa VT, Veicoli.Produttore VP, Veicoli.Modello VM, AR.Indirizzo ARI, S.Indirizzo SI, A.idArea AIA, B.idBox BIB
                    from Veicoli
                        join VeicoliClienti VC on VC.idCliente = var_idCliente
                        join EffettuaIngressiOrari EIO on EIO.idVeicolo = Veicoli.idVeicolo
                        join IngressiOrari IO on IO.idIngressoOrario = EIO.idIngressoOrario
                        join Box B on B.idBox = IO.idBox
                        join Aree A on A.idArea = B.idArea
                        join Autorimesse AR on AR.idAutorimessa = A.idAutorimessa
                        join Sedi S on S.idSede = AR.idSede
                    where Veicoli.idVeicolo = VC.idVeicolo and
                        IO.OraEntrata is not null and
                        IO.OraUscita is null
                ) loop
                    var_check1 := true;
                    modGUI.apriRigaTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_or.VT);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_or.VP || ' ' || curr_or.VM);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_or.SI);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_or.ARI);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_or.AIA);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_or.BIB);
                        modGUI.chiudiElementoTabella;
                    modGUI.chiudiRigaTabella;
                end loop;
            modGUI.chiudiTabella;
            if(var_check1 = false) then
                modGUI.apriDiv(centrato=>true);
                    modGUI.inserisciTesto('NON CI SONO AUTO ANCORA PARCHEGGIATE');
                modGUI.chiudiDiv;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
            end if;
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('PARCHEGGIO/I EFFETTUATO/I CON ABBONAMENTO/I');
            modGUI.chiudiIntestazione(3);
            modGUI.apriTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('TARGA');
                    modGUI.intestazioneTabella('AUTO');
                    modGUI.intestazioneTabella('SEDE');
                    modGUI.intestazioneTabella('AUTORIMESSA');
                    modGUI.intestazioneTabella('AREA');
                    modGUI.intestazioneTabella('BOX');
                modGUI.chiudiRigaTabella;
                for curr_abb in (
                    select distinct Veicoli.Targa VT, Veicoli.Produttore VP, Veicoli.Modello VM, AR.Indirizzo ARI, S.Indirizzo SI, A.idArea AIA, B.idBox BIB
                    from Veicoli
                        join VeicoliClienti VC on VC.idCliente = var_idCliente
                        join EffettuaIngressiAbbonamenti EIA on EIA.idVeicolo = Veicoli.idVeicolo
                        join IngressiAbbonamenti IA on IA.idIngressoAbbonamento = EIA.idIngressoAbbonamento
                        join Box B on B.idBox = IA.idBox
                        join Aree A on A.idArea = B.idArea
                        join Autorimesse AR on AR.idAutorimessa = A.idAutorimessa
                        join Sedi S on S.idSede = AR.idSede
                    where Veicoli.idVeicolo = VC.idVeicolo and
                        IA.OraEntrata is not null and
                        IA.OraUscita is null
                ) loop
                    modGUI.apriRigaTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_abb.VT);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_abb.VP || ' ' || curr_abb.VM);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_abb.SI);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_abb.ARI);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_abb.AIA);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(curr_abb.BIB);
                        modGUI.chiudiElementoTabella;
                    modGUI.chiudiRigaTabella;
                end loop;
            modGUI.chiudiTabella;
            if(var_check2 = false) then
                modGUI.apriDiv(centrato=>true);
                    modGUI.inserisciTesto('NON CI SONO AUTO ANCORA PARCHEGGIATE');
                modGUI.chiudiDiv;
            end if;
        modGUI.chiudiPagina;
    end resRicercaAuto;
                                                               
                                                               
                                                               
    procedure MaggiorPostiRiservati(id_Sessione varchar2, nome varchar2, ruolo varchar2) is 
--suppongo che l'oprazione sia "con il maggior numero di posti liberi", visto che per ora 
--non esistono box riservati

--CONTO QUANTI POSTI RISERVATI CI SONO PER OGNI AUTORIMESSA
cursor MioCursore is select autorimesse.indirizzo,count(box.riservato) as PostiRiservati
from autorimesse,aree,box
where autorimesse.idautorimessa=aree.idautorimessa and aree.idarea=box.idarea and box.riservato='F'
group by autorimesse.indirizzo;

--VARIABILI 
scorriCursore MioCursore%ROWTYPE;
nomeSede autorimesse.indirizzo%TYPE;
posti number:=0;

    
  begin   
  
    open MioCursore;
    loop
    fetch MioCursore into scorriCursore;
    --SCORRO E TROVO AUTORIMESSA CON MAGGIOR POSTI RISERVATI
    if(scorriCursore.postiriservati>posti) then
        posti:=scorriCursore.postiriservati;
        nomeSede:=scorriCursore.indirizzo;
    end if;
    exit when MioCursore%NOTFOUND;
    
    end loop;
    close MioCursore;
    
--STAMPO
 modGUI.apriPagina('HoC | Visualizza dati', id_Sessione, nome, ruolo);

    modGUI.aCapo;
    modGUI.apriIntestazione(3);
    modGUI.inserisciTesto('AUTORIMESSA CON MAGGIOR NUMERO DI POSTI RISERVATI');
    modGUI.chiudiIntestazione(3);
    modGUI.apriDiv;
    modGUI.ApriTabella;

    modGUI.ApriRigaTabella;
    modGUI.intestazioneTabella('NomeSede');
    modGUI.intestazioneTabella('NumPostiRiservati');
    modGUI.ChiudiRigaTabella;
    
        modGUI.ApriRigaTabella;
        
    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(nomeSede);
    modGUI.ChiudiElementoTabella;

    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(posti);
    modGUI.ChiudiElementoTabella;


    modGUI.ChiudiRigaTabella;
    
    

    modGUI.ChiudiTabella;
    modGUI.chiudiDiv;

    modGUI.chiudiPagina;


    END MaggiorPostiRiservati;
                                                               
                                                               
    
                                                               
    PROCEDURE AlimentazioneVeicolo(id_Sessione varchar2, nome varchar2, ruolo varchar2) AS 

    --variabile che conterra l'autorimessa scelta per la visualizzazione
    codiceAutorimessa autorimesse.idautorimessa%TYPE:=0;


begin
 modGUI.apriPagina('HoC | Visualizza dati', id_Sessione, nome, ruolo);

    modGUI.aCapo;
    modGUI.apriIntestazione(3);
    modGUI.inserisciTesto('VISUALIZZAZIONE ALIMENTAZIONE VEICOLO PIU PRESENTE');
    modGUI.chiudiIntestazione(3);
    
    
    modGui.apriForm('AlimentazioneVeicolo2');
    modGui.inserisciInputHidden('id_Sessione',id_sessione);
    modGui.inserisciInputHidden('nome',nome);
    modGui.inserisciInputHidden('ruolo',ruolo);
    
    
    modgui.apriSelect('autorimessaScelta', 'Scegli autorimessa di riferimento');
    --estraggo le autorimesse e le inserisco nella select
    for scorriCursore in (select autorimesse.idautorimessa from autorimesse)
    loop
            codiceAutorimessa:=scorriCursore.idautorimessa;
                modgui.inserisciOpzioneSelect(TO_CHAR(codiceAutorimessa), TO_CHAR(codiceAutorimessa),true);
    end loop;
    --inserisco la possibilita di cercare il veicolo piu presente in tutte le autorimesse
    modgui.inserisciOpzioneSelect('Tutte','Tutte',true);
    modgui.chiudiSelect;
    
    modGUI.apriDiv;
    modGui.inserisciBottoneForm('SUBMIT');
    modGUI.chiudiDiv;
    modGui.chiudiForm();

    END AlimentazioneVeicolo;                                                              
                        
                                                               
                                                               
     PROCEDURE AlimentazioneVeicolo2(id_Sessione varchar2, nome varchar2, ruolo varchar2, autorimessaScelta varchar2) AS 
    --variabili usate per controllare i veicoli acceduti in ingressi orari
   IdveicoloMaxIO number;
   PresenzeIO number:=0;
   AlimentazioneIO varchar2(10);
 
   --variabili usate per controllare i veicoli acceduti in ingressi abbonamenti
   IdveicoloMaxIA number;
   PresenzeIA number:=0;
   AlimentazioneIA varchar2(10); 
    
   ----variabili globali, conterranno il massimo dei valori ottenuti, quindi stampati 
   IdveicoloMax number;
   PresenzeMax number;
   Alimentazione varchar2(10);
   
   BEGIN 

    modGUI.apriPagina('HoC | Visualizza dati', id_Sessione, nome, ruolo);
    modGUI.aCapo;
    modGUI.apriIntestazione(3);
    
    if(autorimessaScelta='Tutte')then
        modGUI.inserisciTesto('Visualizzazione alimentazione del veicolo piu presente in tutte le autorimesse ');
    else
        modGUI.inserisciTesto('Visualizzazione alimentazione del veicolo piu presente in autorimessa: '||autorimessaScelta);
    end if;
    modGUI.chiudiIntestazione(3);
    
      
      if(autorimessaScelta='Tutte')then
          --ANALIZZO INGRESSI ORARI SU TUTTE LE AUTORIMESSE
          for scorriCursore in (
          select  count(ingressiorari.idingressoorario)as conta, veicoli.idveicolo, veicoli.ALIMENTAZIONE
          from ingressiorari, veicoli, effettuaingressiorari
          where ingressiorari.idingressoorario=effettuaingressiorari.idingressoorario and
                effettuaingressiorari.idveicolo=veicoli.idveicolo
          group by veicoli.idveicolo, veicoli.ALIMENTAZIONE
          order by veicoli.idveicolo, veicoli.ALIMENTAZIONE
          )
          
           loop
          
          if(scorriCursore.conta>PresenzeIO)then
            IdveicoloMaxIO:=scorriCursore.idveicolo;
            PresenzeIO:=scorriCursore.conta;
            AlimentazioneIO:=scorriCursore.alimentazione;
          end if;
          end loop;
          
          
          
          
          --ANALIZZO INGRESSI ABBONAMENTI SU TUTTE LE AUTORIMESSE
          for scorriCursore in (
            select  count(ingressiabbonamenti.idingressoabbonamento)as conta, veicoli.idveicolo, veicoli.ALIMENTAZIONE
            from ingressiabbonamenti, veicoli, effettuaingressiabbonamenti
            where ingressiabbonamenti.idingressoabbonamento=effettuaingressiabbonamenti.idingressoabbonamento and
            effettuaingressiabbonamenti.idveicolo=veicoli.idveicolo 
            group by veicoli.idveicolo, veicoli.ALIMENTAZIONE
            order by veicoli.idveicolo, veicoli.ALIMENTAZIONE
          )
          
           loop
          --CALCOLO VALORI MASSIMI
          if(scorriCursore.conta>PresenzeIA)then
            IdveicoloMaxIA:=scorriCursore.idveicolo;
            PresenzeIA:=scorriCursore.conta;
            AlimentazioneIA:=scorriCursore.alimentazione;
          end if;
          end loop;
          

      else ----CASO IN CUI VOGLIO SINGOLA AUTORIMESSA
      
     --ANALIZZO INGRESSI ORARI SU SINGOLA AUTORIMESSA
        for scorriCursore in (
          select  count(ingressiorari.idingressoorario)as conta, veicoli.idveicolo, veicoli.ALIMENTAZIONE
          from ingressiorari, veicoli, effettuaingressiorari,box,aree,autorimesse
          where ingressiorari.idingressoorario=effettuaingressiorari.idingressoorario and
               effettuaingressiorari.idveicolo=veicoli.idveicolo and
               ingressiorari.IDBOX=box.idbox and
               box.idarea=aree.idarea and
               aree.idautorimessa=autorimesse.idautorimessa and
               autorimesse.idautorimessa=TO_NUMBER(autorimessaScelta)
         group by veicoli.idveicolo,veicoli.ALIMENTAZIONE
        )
          
           loop
          --DETERMINO VALORI MASSIMI
          if(scorriCursore.conta>PresenzeIO)then
            IdveicoloMaxIO:=scorriCursore.idveicolo;
            PresenzeIO:=scorriCursore.conta;
            AlimentazioneIO:=scorriCursore.alimentazione;
          end if;
          end loop;
          
          
          
          --ANALIZZO INGRESSI ABBONAMENTI SU SINGOLA AUTORIMESSA
          for scorriCursore in (
            select  count(ingressiabbonamenti.idingressoabbonamento)as conta, veicoli.idveicolo, veicoli.ALIMENTAZIONE
            from ingressiabbonamenti, veicoli, effettuaingressiabbonamenti, box,aree,autorimesse
            where   ingressiabbonamenti.idingressoabbonamento=effettuaingressiabbonamenti.idingressoabbonamento and
                    effettuaingressiabbonamenti.idveicolo=veicoli.idveicolo and
                    ingressiabbonamenti.IDBOX=box.idbox and
                    box.idarea=aree.idarea and
                    aree.idautorimessa=autorimesse.idautorimessa and
                    autorimesse.idautorimessa=TO_NUMBER(autorimessaScelta)
            group by veicoli.idveicolo,veicoli.ALIMENTAZIONE
          )
          
           loop
          --DETERMINO MASSIMI
          if(scorriCursore.conta>PresenzeIA)then
            IdveicoloMaxIA:=scorriCursore.idveicolo;
            PresenzeIA:=scorriCursore.conta;
            AlimentazioneIA:=scorriCursore.alimentazione;
          end if;
          end loop;


      end if; --DISCRIMINANTE AUTORIMESSE SCELTE
      
      --CONFRONTO VALORI FINALI E CALCOLO MASSIMO
        if(PresenzeIA>PresenzeIO)then
            PresenzeMax:=PresenzeIA;
            IdveicoloMax:=IdveicoloMaxIA;
            Alimentazione:=AlimentazioneIA;
        else
            PresenzeMax:=PresenzeIO;
            IdveicoloMax:=IdveicoloMaxIO;
            Alimentazione:=AlimentazioneIO;
        end if;

    --STAMPO VALORI CALCOLATI
    modGUI.apriDiv;
    modGUI.ApriTabella;

    modGUI.ApriRigaTabella;
    modGUI.intestazioneTabella('Identificativo veicolo');
    modGUI.intestazioneTabella('Alimentazione');
    modGUI.intestazioneTabella('Presenze');
    modGUI.ChiudiRigaTabella;
    
    modGUI.ApriRigaTabella;
    
    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(IdveicoloMax);
    modGUI.ChiudiElementoTabella;
    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(Alimentazione);
    modGUI.ChiudiElementoTabella;
    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(PresenzeMax);
    modGUI.ChiudiElementoTabella;
      modGui.acapo;
    modGUI.ChiudiElementoTabella;
    
    modGUI.ChiudiRigaTabella;  

    modGUI.ChiudiTabella;
    modGUI.chiudiDiv;

    modGUI.chiudiPagina;



    END AlimentazioneVeicolo2;                                                           
                                                               
                                                               
                                                               
                                                               
    PROCEDURE PercentualePostiLiberi2(id_Sessione varchar2, nome varchar2, ruolo varchar2, modalita varchar2, areaScelta varchar2) AS 
      
      
--DICHIARO VARIABILI PER STAMPARE
fasciaOraria fasceorarie.nome%TYPE;
giorno fasceorarie.giorno%TYPE;
--DICHIARO VARIABILI PER CALCOLARE
postiRiservati number;
postiTotali number;
percentuale number;

BEGIN
    --CALCOLO POSTI TOTALI PER L'AREA SCELTA
    select aree.postitotali into postiTotali from aree where aree.idarea=areaScelta ;

    modGUI.apriPagina('HoC | Visualizza dati', id_Sessione, nome, ruolo);

    modGUI.aCapo;
    modGUI.apriIntestazione(3);
    modGUI.inserisciTesto('Visualizzazione posti liberi per '||modalita||', riguardo area: '||areaScelta);
    modGUI.chiudiIntestazione(3);
    
    modGUI.apriDiv;
    modGUI.ApriTabella;
    modGUI.ApriRigaTabella;
    
    
    if(modalita='fascia-oraria')then
      modGUI.intestazioneTabella('Fascia oraria');
    else
      modGUI.intestazioneTabella('Giorno');
    end if;
    modGUI.intestazioneTabella('Posti liberi');
    modGUI.ChiudiRigaTabella;
    
  --CASO IN CUI SCELTA VISUALIZZAZIONE PER FASCIA ORARIA
  if(modalita='fascia-oraria')then

    --CONTO QUANTI POSTI OCCUPATI CI SONO PER OGNI FASCIA ORARIA
    for scorriCursoreFasceOrarie in (
        select distinct fasceorarie.nome, count(ingressiorari.idingressoorario)as postiRiservati, aree.idarea 
        from ingressiorari,box,aree,areefasceorarie,fasceorarie
        where ingressiorari.idbox=box.idbox and 
          box.idarea=aree.idarea and 
          aree.idarea=areefasceorarie.idarea and
          areefasceorarie.idfasciaoraria=fasceorarie.idfasciaoraria and
          aree.idarea=areaScelta 
          group by aree.idarea, fasceorarie.nome
          order by fasceorarie.nome,aree.idarea
    )
    loop 
    
    modGUI.ApriRigaTabella;
                
        fasciaOraria:=scorriCursoreFasceOrarie.nome;
        modGUI.ApriElementoTabella;
        modGUI.ElementoTabella(fasciaOraria);
        modGUI.ChiudiElementoTabella;

        --DOPO AVER CONTATO I POSTI TOTALI PER L'AREA(SOPRA)
        --OTTENGO POSTI LIBERI
        postiRiservati:=scorriCursoreFasceOrarie.postiRiservati;
        --CALCOLO QUANTO SONO IN PERCENTUALE
        percentuale:=((postiTotali-postiRiservati)*100)/postiTotali;
        modGUI.ApriElementoTabella;
        
        if(percentuale<0)then --CASO IN CUI NEL COMPLESSO, TRA MATTINA E SERA, NON CI SONO MAI POSTI LIBERI
            modGUI.ElementoTabella(0||'%');
        else
            modGUI.ElementoTabella(TO_CHAR(percentuale,'fm90.00')||'%');
        end if;
        modGUI.ChiudiElementoTabella;
        
        modGUI.ChiudiRigaTabella;
    
    
    end loop;
   
  else --CASO IN CUI SCELTA VISUALIZZAZIONE PER GIORNO 
    for scorriCursoreGiorni in (
        select distinct aree.idarea, fasceorarie.giorno , count(ingressiorari.idingressoorario) as postiRiservati  
        from ingressiorari,box,aree,areefasceorarie,fasceorarie
        where ingressiorari.idbox=box.idbox and 
          box.idarea=aree.idarea and 
          aree.idarea=areefasceorarie.idarea and
          areefasceorarie.idfasciaoraria=fasceorarie.idfasciaoraria and
          aree.idarea=areaScelta
          group by fasceorarie.giorno, aree.idarea 
          order by fasceorarie.giorno,aree.idarea
    
    )
    loop
        modGUI.ApriRigaTabella;
        
        
        giorno:=scorriCursoreGiorni.giorno;
        modGUI.ApriElementoTabella;
        modGUI.ElementoTabella(giorno);
        modGUI.ChiudiElementoTabella;

        postiRiservati:=scorriCursoreGiorni.postiRiservati;
        percentuale:=((postiTotali-postiRiservati)*100)/postiTotali;
        modGUI.ApriElementoTabella;
        if(percentuale<0)then
            modGUI.ElementoTabella(0||'%');
        else
            modGUI.ElementoTabella(TO_CHAR(percentuale,'fm90.00')||'%');
        end if;
        modGUI.ChiudiElementoTabella;
        
        modGUI.ChiudiRigaTabella;
    
    end loop;
    end if;
    

    END PercentualePostiLiberi2;                                                           
                                                               
                                                               
                                                               
                                                               
     procedure PercentualiPostiLiberi (id_Sessione varchar2, nome varchar2, ruolo varchar2) is 

    --VARIABILE CONTENENTE AREA SCELTA
    codiceArea aree.idarea%TYPE;


begin
 modGUI.apriPagina('HoC | Visualizza dati', id_Sessione, nome, ruolo);

    modGUI.aCapo;
    modGUI.apriIntestazione(3);
    modGUI.inserisciTesto('VISUALIZZAZIONE POSTI LIBERI');
    modGUI.chiudiIntestazione(3);
    
    
    modGui.apriForm('PERCENTUALIPOSTILIBERI2');
    modGui.inserisciInputHidden('id_Sessione',id_sessione);
    modGui.inserisciInputHidden('nome',nome);
    modGui.inserisciInputHidden('ruolo',ruolo);
    
    --RADIO1
    modGUI.apriDiv;
    modGui.inserisciRadioButton('Per fascia oraria', 'modalita', 'fascia-oraria', true);
    modGUI.chiudiDiv;
    
    modgui.acapo;
    
    --RADIO2
    modGUI.apriDiv;
    modGui.inserisciRadioButton('Per giorno', 'modalita', 'giorno');
    modGUI.chiudiDiv;
    modgui.acapo;
    
    --SELECT
    modgui.apriSelect('areaScelta', 'Scegli area riferimento');
    --ESTRAGGO AREE DA QUERY E LE METTO NELLA SELECT
    for scorriCursore in(select aree.idarea from aree)
    loop
            codiceArea:=scorriCursore.idarea;
            modgui.inserisciOpzioneSelect(TO_CHAR(codiceArea), TO_CHAR(codiceArea),true);
    end loop;

    modgui.chiudiSelect;
    
    modGUI.apriDiv;
    modGui.inserisciBottoneForm('SUBMIT');
    modGUI.chiudiDiv;
    modGui.chiudiForm();
  
    end PercentualiPostiLiberi;                                                          
                                                               
                                                               
                                                               
    procedure MaxTipoVeicolo(id_Sessione varchar2, nome varchar2, ruolo varchar2) is 

    --VARIABILI STAMPATE
    Lunghezza aree.lunghezzaMax%type;
    Altezza aree.AltezzaMax%type;
    Larghezza aree.LarghezzaMax%type;
    Peso aree.PesoMax%type;
    Area aree.idarea%type;
    --VARIABILI PER CALCOLO
    media number:=0;
    
  begin   
  --CALCOLO LA MEDIA DEI VALORI DI OGNI AREA
  for scorriCursore in (
    select (aree.lunghezzaMax+aree.larghezzaMax+aree.altezzaMax+aree.pesoMax)/4 as media,
        aree.lunghezzaMax, aree.larghezzaMax ,aree.altezzaMax,aree.pesoMax, aree.idarea
    from aree
  )
  -- TROVO LA MAGGIORE
  loop
    if(scorriCursore.media>media)then
        media:=scorriCursore.media;
        Area:=scorriCursore.idarea;
        Lunghezza:=scorriCursore.lunghezzaMax;
        Altezza:=scorriCursore.altezzaMax;
        Larghezza:=scorriCursore.larghezzaMax;
        Peso:=scorriCursore.pesoMax;
    end if;
  
  end loop;
   
--STAMPO
 modGUI.apriPagina('HoC | Visualizza dati', id_Sessione, nome, ruolo);

    modGUI.aCapo;
    modGUI.apriIntestazione(3);
    modGUI.inserisciTesto('IL MAGGIOR TIPO VEICOLO E OSPITATO DALLA SEGUENTE AREA:');
    modGUI.chiudiIntestazione(3);
    modGUI.apriDiv;
    modGUI.ApriTabella;

    modGUI.ApriRigaTabella;
    modGUI.intestazioneTabella('Area');
    modGUI.intestazioneTabella('lunghezzaMax');
    modGUI.intestazioneTabella('larghezzaMax');
    modGUI.intestazioneTabella('pesoMax');
    modGUI.intestazioneTabella('altezzaMax');
    modGUI.ChiudiRigaTabella;
    
        modGUI.ApriRigaTabella;
    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(Area);
    modGUI.ChiudiElementoTabella;
    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(Lunghezza);
    modGUI.ElementoTabella(' cm');
    modGUI.ChiudiElementoTabella;
    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(Altezza);
    modGUI.ElementoTabella(' cm');
    modGUI.ChiudiElementoTabella;
    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(Peso);
    modGUI.ElementoTabella('kg');
    modGUI.ChiudiElementoTabella;
    modGUI.ApriElementoTabella;
    modGUI.ElementoTabella(Larghezza);
    modGUI.ElementoTabella(' cm');
    modGUI.ChiudiElementoTabella;
    modGUI.ChiudiRigaTabella;
    
    

    modGUI.ChiudiTabella;
    modGUI.chiudiDiv;

    modGUI.chiudiPagina;

    end MaxTipoVeicolo;
    
    procedure secondaComune(id_Sessione int, nome varchar2, ruolo varchar2) is
    begin
        modGUI.apriPagina('HoC | Dettagli veicoli cliente', id_Sessione, nome, ruolo);
        modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('DETTAGLI VEICOLI DI UN CLIENTE');
        modGUI.chiudiIntestazione(2);
        modGUI.apriForm('resSecondaComune');
            modGUI.inserisciInputHidden('id_Sessione', id_Sessione);
            modGUI.inserisciInputHidden('nome', nome);
            modGUI.inserisciInputHidden('ruolo', ruolo);
            modGUI.apriSelect('var_idCliente', 'CLIENTE', true);
            for cur_cli in (
                select Clienti.idCliente CIDC, Persone.Nome PN, Persone.Cognome PC
                from Clienti, Persone
                where Persone.idPersona = Clienti.idPersona
            ) loop
                modGUI.inserisciOpzioneSelect(cur_cli.CIDC, cur_cli.PN || ' ' || cur_cli.PC);
            end loop;
            modGUI.chiudiSelect;
            modGUI.apriSelect('var_autorimessa', 'AUTORIMESSA', true);
            for cur_aut in (
                select Autorimesse.idAutorimessa AIA, Autorimesse.Indirizzo AI
                from Autorimesse
            ) loop
                modGUI.inserisciOpzioneSelect(cur_aut.AIA, cur_aut.AI);
            end loop;
            modGUI.chiudiSelect;
            modGUI.inserisciInput('var_inizio', 'INIZIO PERIODO', 'date', true);
            modGUI.inserisciInput('var_fine', 'FINE PERIODO', 'date', true);
            modGUI.inserisciBottoneReset;
            modGUI.inserisciBottoneForm(testo=>'RICERCA DETTAGLI');
        modGUI.chiudiForm;
        modGUI.chiudiPagina;
    end secondaComune;

    procedure resSecondaComune(id_Sessione int, nome varchar2, ruolo varchar2, var_idCliente int, var_autorimessa int, var_inizio varchar2, var_fine varchar2) is
        var_nomePersona Persone.Nome%TYPE;
        var_cognomePersona Persone.Cognome%TYPE;
        var_nomeAutorimessa Autorimesse.Indirizzo%TYPE;
        var_check1 boolean := false;
        var_check2 boolean := false;
    begin
        select Persone.Nome, Persone.Cognome
        into var_nomePersona, var_cognomePersona
        from Clienti, Persone
        where Clienti.idCliente = var_idCliente and
            Persone.idPersona = Clienti.idPersona;
        select Autorimesse.Indirizzo
        into var_nomeAutorimessa
        from Autorimesse
        where Autorimesse.idAutorimessa = var_autorimessa;
        
        modGUI.apriPagina('HoC | Visualizza dettagli cliente', id_Sessione, nome, ruolo);
        modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('DETTAGLI VEICOLI DI: ' || var_nomePersona || ' ' || var_cognomePersona);
            modGUI.aCapo;
            modGUI.inserisciTesto('PERIODO DA: ' || to_date(var_inizio, 'yyyy-mm-dd') || ' A ' || to_date(var_fine, 'yyyy-mm-dd'));
            modGUI.aCapo;
            modGUI.inserisciTesto('NELL''AUTORIMESSA DI: ' || var_nomeAutorimessa);
        modGUI.chiudiIntestazione(2);
        modGUI.apriIntestazione(3);
            modGUI.inserisciTesto('AUTO PARCHEGGIATA/E CON TIKET');
        modGUI.chiudiIntestazione(3);
        modGUI.apriTabella;
            modGUI.apriRigaTabella;
                modGUI.intestazioneTabella('TARGA');
                modGUI.intestazioneTabella('PRODUTTORE');
                modGUI.intestazioneTabella('MODELLO');
                modGUI.intestazioneTabella('DETTAGLI');
            modGUI.chiudiRigaTabella;
            for cur_or in (
                select distinct Veicoli.Targa VT, Veicoli.Produttore VP, Veicoli.Modello VM, Veicoli.idVeicolo VIV
                    from Veicoli
                        join VeicoliClienti VC on VC.idCliente = var_idCliente
                        join EffettuaIngressiOrari EIO on EIO.idVeicolo = Veicoli.idVeicolo
                        join IngressiOrari IO on IO.idIngressoOrario = EIO.idIngressoOrario
                        join Autorimesse AR on AR.idAutorimessa = var_autorimessa
                    where Veicoli.idVeicolo = VC.idVeicolo and
                        IO.OraEntrata between to_timestamp(var_inizio, 'yyyy-mm-dd') and to_timestamp(var_fine, 'yyyy-mm-dd')
            ) loop
                var_check1 := true;
                modGUI.apriRigaTabella;
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(cur_or.VT);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(cur_or.VP);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(cur_or.VM);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                        modGUI.inserisciLente(groupname || 'dettagliVeicoloSecondaComune', id_Sessione, nome, ruolo, cur_or.VIV);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
            end loop;
        modGUI.chiudiTabella;
        if(var_check1 = false) then
            modGUI.apriDiv(centrato=>true);
                modGUI.inserisciTesto('NESSUN RISULTATO');
            modGUI.chiudiDiv;
            modGUI.aCapo;
            modGUI.aCapo;
            modGUI.aCapo;
            modGUI.aCapo;
        end if;
        modGUI.apriIntestazione(3);
            modGUI.inserisciTesto('AUTO PARCHEGGIATA/E CON ABBONAMENTO/I');
        modGUI.chiudiIntestazione(3);
        modGUI.apriTabella;
            modGUI.apriRigaTabella;
                modGUI.intestazioneTabella('TARGA');
                modGUI.intestazioneTabella('PRODUTTORE');
                modGUI.intestazioneTabella('MODELLO');
                modGUI.intestazioneTabella('DETTAGLI');
            modGUI.chiudiRigaTabella;
            for cur_abb in (
                select distinct Veicoli.Targa VT, Veicoli.Produttore VP, Veicoli.Modello VM, Veicoli.idVeicolo VIV
                    from Veicoli
                        join VeicoliClienti VC on VC.idCliente = var_idCliente
                        join EffettuaIngressiAbbonamenti EIA on EIA.idVeicolo = Veicoli.idVeicolo
                        join IngressiAbbonamenti IA on IA.idIngressoAbbonamento = EIA.idIngressoAbbonamento
                        join Autorimesse AR on AR.idAutorimessa = var_autorimessa
                    where Veicoli.idVeicolo = VC.idVeicolo and
                        IA.OraEntrata between to_timestamp(var_inizio, 'yyyy-mm-dd') and to_timestamp(var_fine, 'yyyy-mm-dd')
            ) loop
                var_check2 := true;
                modGUI.apriRigaTabella;
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(cur_abb.VT);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(cur_abb.VP);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(cur_abb.VM);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                        modGUI.inserisciLente(groupname || 'dettagliVeicoloSecondaComune', id_Sessione, nome, ruolo, cur_abb.VIV);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
            end loop;
        modGUI.chiudiTabella;
        if(var_checK2 = false) then
            modGUI.apriDiv(centrato=>true);
                modGUI.inserisciTesto('NESSUN RISULTATO');
            modGUI.chiudiDiv;
        end if;
        modGUI.chiudiPagina;
    end resSecondaComune;

    procedure dettagliVeicoloSecondaComune(id_Sessione int, nome varchar2, ruolo varchar2, idRiga int) is
    var_idVeicolo Veicoli.idVeicolo%TYPE;
    var_targa Veicoli.Targa%TYPE;
    var_produttore Veicoli.Produttore%TYPE;
    var_modello Veicoli.Modello%TYPE;
    var_colore Veicoli.Colore%TYPE;
    var_altezza Veicoli.Altezza%TYPE;
    var_larghezza Veicoli.Larghezza%TYPE;
    var_lunghezza Veicoli.Lunghezza%TYPE;
    var_peso Veicoli.Peso%TYPE;
    var_alimentazione Veicoli.Alimentazione%TYPE;
    var_annotazione Veicoli.Annotazione%TYPE;
    begin
        modGUI.apriPagina('HoC | Dettagli veicolo', id_Sessione, nome, ruolo);
        modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('DETTAGLI VEICOLO');
        modGUI.chiudiIntestazione(2);

        select Veicoli.idVeicolo, Veicoli.Targa, Veicoli.Produttore, Veicoli.Modello, Veicoli.Colore, Veicoli.Altezza, Veicoli.Larghezza, Veicoli.Lunghezza, Veicoli.Peso, Veicoli.Alimentazione, Veicoli.Annotazione
        into var_idVeicolo, var_targa, var_produttore, var_modello, var_colore, var_altezza, var_larghezza, var_lunghezza, var_peso, var_alimentazione, var_annotazione
        from Veicoli
        where Veicoli.idVeicolo = idRiga;
        modGUI.apriTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('ID VEICOLO');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_idVeicolo);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('TARGA');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_targa);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('PRODUTTORE');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_produttore);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('MODELLO');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_modello);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('COLORE');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_colore);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('ALTEZZA');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_altezza);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('LARGHEZZA');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_larghezza);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('LUNGHEZZA');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_lunghezza);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('PESO');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_peso);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('ALIMENTAZIONE');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_alimentazione);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

            modGUI.apriRigaTabella;
            modGUI.intestazioneTabella('ANNOTAZIONE');
            modGUI.apriElementoTabella;
                modGUI.elementoTabella(var_annotazione);
            modGUI.chiudiElementoTabella;
            modGUI.chiudiRigaTabella;

        modGUI.chiudiTabella;
        modGUI.chiudiPagina;
    end dettagliVeicoloSecondaComune;

    procedure veicoloMenoParcheggiato(id_sessione int, nome varchar2, ruolo varchar2) is
    begin
        modGUI.apriPagina('HoC | Veicolo meno parcheggiato', id_sessione, nome, ruolo);
            modGUI.aCapo;
            modGUI.apriDiv;
                if (ruolo <> 'A') then
                    modGUI.esitoOperazione('KO', 'Non sei autorizzato');
                else
                    modGUI.apriForm(groupname || 'resVeicoloMenoParcheggiato');
                        modGUI.inserisciInputHidden('id_sessione', id_sessione);
                        modGUI.inserisciInputHidden('nome', nome);
                        modGUI.inserisciInputHidden('ruolo', ruolo);

                        modGUI.apriSelect('id_cliente', 'Cliente');
                            for cursore in (
                                select C.idCliente, P.Nome || ' ' || P.Cognome as Nome
                                from Clienti C
                                    join Persone P on P.idPersona = C.idPersona
                            )
                            loop
                                modGUI.inserisciOpzioneSelect(cursore.idCliente, cursore.Nome);
                            end loop;
                        modGUI.chiudiSelect;

                        modGUI.inserisciBottoneReset;
                        modGUI.inserisciBottoneForm;
                    modGUI.chiudiForm;
                end if;
            modGUI.chiudiDiv;
        modGUI.chiudiPagina;
    end veicoloMenoParcheggiato;

    procedure resVeicoloMenoParcheggiato(id_sessione int, nome varchar2, ruolo varchar2, id_cliente int) is
        cursor cursore is
            with
                TotOrari as (
                    select AU.idAutorimessa as idAutorimessa, V.Alimentazione as Alimentazione, count(*) as Ingressi
                    from Autorimesse AU
                        join Aree AR on AR.idAutorimessa = AU.idAutorimessa
                        join Box B on B.idArea = AR.idArea
                        join IngressiOrari IO on IO.idBox = B.idBox
                        join EffettuaIngressiOrari EIO on EIO.idIngressoOrario = IO.idIngressoOrario
                        join Veicoli V on V.idVeicolo = EIO.idVeicolo
                    where EIO.idCliente = id_cliente
                    group by AU.idAutorimessa, V.Alimentazione
                ),
                TotAbbonamenti as (
                    select AU.idAutorimessa as idAutorimessa, V.Alimentazione as Alimentazione, count(*) as Ingressi
                    from Autorimesse AU
                        join Aree AR on AR.idAutorimessa = AU.idAutorimessa
                        join Box B on B.idArea = AR.idArea
                        join IngressiAbbonamenti IA on IA.idBox = B.idBox
                        join EffettuaIngressiAbbonamenti EIA on EIA.idIngressoAbbonamento = IA.idIngressoAbbonamento
                        join Veicoli V on V.idVeicolo = EIA.idVeicolo
                    where EIA.idCliente = id_cliente
                    group by AU.idAutorimessa, V.Alimentazione
                ),
                Totale as (
                    select
                        coalesce(TotOrari.idAutorimessa, TotAbbonamenti.idAutorimessa) as idAutorimessa,
                        coalesce(TotOrari.Alimentazione, TotAbbonamenti.Alimentazione) as Alimentazione,
                        coalesce(TotOrari.Ingressi, 0) + coalesce(TotAbbonamenti.Ingressi, 0) as Ingressi
                    from TotOrari
                        full outer join TotAbbonamenti on TotAbbonamenti.idAutorimessa = TotOrari.idAutorimessa
                )
            select T.idAutorimessa, A.Indirizzo, T.Alimentazione, T.Ingressi
            from Totale T
                join Autorimesse A on A.idAutorimessa = T.idAutorimessa
            where T.Ingressi = (
                select min(Ingressi)
                from Totale
                where Totale.idAutorimessa = T.idAutorimessa
        );

        id_autorimessa Autorimesse.idAutorimessa%TYPE;
        indirizzo Autorimesse.Indirizzo%TYPE;
        alimentazione Veicoli.Alimentazione%TYPE;
        ingressi number;
        nome_cliente Persone.Nome%TYPE;
        cognome_cliente Persone.Cognome%TYPE;
    begin
        modGUI.apriPagina('HoC | Veicolo meno parcheggiato', id_sessione, nome, ruolo);
            modGUI.apriDiv;
                if (ruolo <> 'A') then
                    modGUI.esitoOperazione('KO', 'Non sei autorizzato');
                else
                    
                    select P.Nome, P.Cognome
                    into nome_cliente, cognome_cliente
                    from Clienti C
                        join Persone P on P.idPersona = C.idPersona
                    where C.idCliente = id_cliente;
                
                    modGUI.apriIntestazione(2);
                        modGUI.inserisciTesto('Carburante del veicolo meno parcheggiato da ' || nome_cliente || ' ' || cognome_cliente || ' per ogni autorimessa');
                    modGUI.chiudiIntestazione(2);

                    modGUI.apriTabella;
                        modGUI.apriRigaTabella;
                            modGUI.intestazioneTabella('ID Autorimessa');
                            modGUI.intestazioneTabella('Indirizzo');
                            modGUI.intestazioneTabella('Alimentazione');
                            modGUI.intestazioneTabella('Ingressi');
                            modGUI.intestazioneTabella('Dettagli');
                        modGUI.chiudiRigaTabella;
                        open cursore;
                        loop
                            fetch cursore into id_autorimessa, indirizzo, alimentazione, ingressi;
                            exit when cursore%NOTFOUND;
                            modGUI.apriRigaTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(id_autorimessa);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(indirizzo);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(alimentazione);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(ingressi);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciLente(groupname || 'visualizzaAutorimessa', id_sessione, nome, ruolo, id_autorimessa);
                                modGUI.chiudiElementoTabella;
                            modGUI.chiudiRigaTabella;
                        end loop;
                        close cursore;
                    modGUI.chiudiTabella;
                end if;
            modGUI.chiudiDiv;
        modGUI.chiudiPagina;
    end resVeicoloMenoParcheggiato;

    procedure ingressiSopraMedia(id_sessione int, nome varchar2, ruolo varchar2) is
    begin
        modGUI.apriPagina('HoC | Ingressi sopra media', id_sessione, nome, ruolo);
            modGUI.apriDiv;
                if (ruolo <> 'A') then
                    modGUI.esitoOperazione('KO', 'Non sei autorizzato');
                else
                    modGUI.apriIntestazione(2);
                        modGUI.inserisciTesto('Ingressi con costo sopra la media');
                    modGUI.chiudiIntestazione(2);
                    
                    modGUI.apriForm(groupname || 'resIngressiSopraMedia');
                        modGUI.inserisciInputHidden('id_Sessione', id_Sessione);
                        modGUI.inserisciInputHidden('nome', nome);
                        modGUI.inserisciInputHidden('ruolo', ruolo);
                        
                        modGUI.inserisciInput('Data inizio', 'date', 'var_inizio', true);
                        modGUI.inserisciInput('Data fine', 'date', 'var_fine', false);
                        
                        modGUI.inserisciBottoneReset;
                        modGUI.inserisciBottoneForm;
                    modGUI.chiudiForm;
                end if;
            modGUI.chiudiDiv;
        modGUI.chiudiPagina;
    end ingressiSopraMedia;

    procedure resIngressiSopraMedia(id_sessione int, nome varchar2, ruolo varchar2, var_inizio varchar2, var_fine varchar2) is
        
        entrata_prevista IngressiOrari.EntrataPrevista%TYPE;
        ora_entrata IngressiOrari.OraEntrata%TYPE;
        ora_uscita IngressiOrari.OraUscita%TYPE;
        var_costo IngressiOrari.Costo%TYPE;
        id_sede Sedi.idSede%TYPE;
        cursor cursore is
            with
                IngressiPerSede as (
                    select IO.EntrataPrevista as EntrataPrevista, IO.OraEntrata as OraEntrata, IO.OraUscita as OraUscita, IO.Costo as Costo, S.idSede as idSede
                    from Sedi S
                        join Autorimesse AU on AU.idSede = S.idSede
                        join Aree AR on AR.idAutorimessa = AU.idAutorimessa
                        join Box B on B.idArea = AR.idArea
                        join IngressiOrari IO on IO.idBox = B.idBox
                    where least(IO.OraUscita, to_date(var_fine, 'yyyy-mm-dd')) >= greatest(IO.OraEntrata, to_date(var_inizio, 'yyyy-mm-dd'))
                ),
                MediaPerSede as (
                    select S.idSede as idSede, avg(IO.Costo) as MediaCosto
                    from Sedi S
                        join Autorimesse AU on AU.idSede = S.idSede
                        join Aree AR on AR.idAutorimessa = AU.idAutorimessa
                        join Box B on B.idArea = AR.idArea
                        join IngressiOrari IO on IO.idBox = B.idBox
                    where least(IO.OraUscita, to_date(var_fine, 'yyyy-mm-dd')) >= greatest(IO.OraEntrata, to_date(var_inizio, 'yyyy-mm-dd'))
                    group by S.idSede
                )
            select IPS.*
            from IngressiPerSede IPS
                join MediaPerSede MPS on MPS.idSede = IPS.idSede
            where IPS.Costo > MPS.MediaCosto;
    begin
        modGUI.apriPagina('HoC | Ingressi sopra la media', id_sessione, nome, ruolo);
            modGUI.apriDiv;
                if (ruolo <> 'A') then
                    modGUI.esitoOperazione('KO', 'Non sei autorizzato');
                else
                    modGUI.apriIntestazione(2);
                        modGUI.inserisciTesto('Ingressi con costo sopra alla media del periodo ' || var_inizio || ' - ' || var_fine);
                    modGUI.chiudiIntestazione(2);

                    modGUI.apriTabella;
                        modGUI.apriRigaTabella;
                            modGUI.intestazioneTabella('Entrata Prevista');
                            modGUI.intestazioneTabella('Ora Entrata');
                            modGUI.intestazioneTabella('Ora Uscita');
                            modGUI.intestazioneTabella('Costo');
                            modGUI.intestazioneTabella('Sede');
                        modGUI.chiudiRigaTabella;

                        open cursore;
                        loop
                            fetch cursore into entrata_prevista, ora_entrata, ora_uscita, var_costo, id_sede;
                            exit when cursore%NOTFOUND;
                            modGUI.apriRigaTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(entrata_prevista);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(ora_entrata);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(ora_uscita);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(var_costo);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(id_sede);
                                modGUI.chiudiElementoTabella;
                            modGUI.chiudiRigaTabella;
                        end loop;
                        close cursore;
                    modGUI.chiudiTabella;
                end if;
            modGUI.chiudiDiv;
        modGUI.chiudiPagina;
    end resIngressiSopraMedia;

    procedure classificaMediaPermanenza(id_sessione int, nome varchar2, ruolo varchar2) is
    begin
        modGUI.apriPagina('HoC | Classifica Clienti per Tempo Medio di Permanenza', id_sessione, nome, ruolo);
            modGUI.apriDiv;
                if (ruolo <> 'A') then
                    modGUI.esitoOperazione('KO', 'Non sei autorizzato');
                else
                    modGUI.apriIntestazione(2);
                        modGUI.inserisciTesto('Classifica Clienti per Tempo Medio di Permanenza');
                    modGUI.chiudiIntestazione(2);
                    
                    modGUI.apriForm(groupname || 'resClassificaMediaPermanenza');
                        modGUI.inserisciInputHidden('id_sessione', id_sessione);
                        modGUI.inserisciInputHidden('nome', nome);
                        modGUI.inserisciInputHidden('ruolo', ruolo);
                        modGUI.inserisciInput(
                          tipo => 'number',
                          etichetta => 'Soglia',
                          nome => 'var_soglia',
                          richiesto => true
                        );
                        modGUI.inserisciBottoneReset;
                        modGUI.inserisciBottoneForm;
                    modGUI.chiudiForm;
                end if;
            modGUI.chiudiDiv;
        modGUI.chiudiPagina;
    end classificaMediaPermanenza;

    procedure resClassificaMediaPermanenza(id_sessione int, nome varchar2, ruolo varchar2, var_soglia int) is
        cursor riga is
            with
                TotOrari as (
                    select C.idCliente as idCliente, sum(trunc((cast(IO.OraUscita as date) - cast(IO.OraEntrata as date)) * 24)) as Somma, count(*) as NumIngressi
                        from Clienti C
                        join EffettuaIngressiOrari EIO on EIO.idCliente = C.idCliente
                        join IngressiOrari IO on IO.idIngressoOrario = EIO.idIngressoOrario
                    where IO.OraEntrata is not null
                    and IO.OraUscita is not null
                    group by C.idCliente
                ),
                TotAbbonamenti as (
                    select C.idCliente as idCliente, sum(trunc((cast(IA.OraUscita as date) - cast(IA.OraEntrata as date)) * 24)) as Somma, count(*) as NumIngressi
                        from Clienti C
                        join EffettuaIngressiAbbonamenti EIA on EIA.idCliente = C.idCliente
                        join IngressiAbbonamenti IA on IA.idIngressoAbbonamento = EIA.idIngressoAbbonamento
                    where IA.OraEntrata is not null
                    and IA.OraUscita is not null
                    group by C.idCliente
                ),
                Total as (
                    select idCliente, sum(Somma) as Somma, sum(NumIngressi) as NumIngressi
                    from (
                        select * from TotOrari
                        union all
                        select * from TotAbbonamenti
                    )
                    group by idCliente
                )
            select C.idCliente as idCliente, P.Nome as Nome, P.Cognome as Cognome, (T.Somma / T.NumIngressi) as Media
            from Total T
                join Clienti C on C.idCliente = T.idCliente
                join Persone P on P.idPersona = C.idPersona
            order by Media desc;
        id_cliente Clienti.idCliente%TYPE;
        nome_cliente Persone.Nome%TYPE;
        cognome_cliente Persone.Cognome%TYPE;
        media number;
    begin
        modGUI.apriPagina('HoC | Classifica Clienti per Tempo Medio di Permanenza', id_sessione, nome, ruolo);
            modGUI.apriDiv;
                if (ruolo <> 'A') then
                    modGUI.esitoOperazione('KO', 'Non sei autorizzato');
                else

                    modGUI.apriIntestazione(2);
                        modGUI.inserisciTesto('Classifica Clienti per Tempo Medio di Permanenza');
                    modGUI.chiudiIntestazione(2);

                    modGUI.apriTabella;
                        modGUI.apriRigaTabella;
                            modGUI.intestazioneTabella('ID Cliente');
                            modGUI.intestazioneTabella('Nome');
                            modGUI.intestazioneTabella('Tempo Medio');
                            modGUI.intestazioneTabella('Dettagli');
                        modGUI.chiudiRigaTabella;
                        open riga;
                        loop
                            fetch riga into id_cliente, nome_cliente, cognome_cliente, media;
                            exit when riga%NOTFOUND;
                            modGUI.apriRigaTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(id_cliente);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(nome_cliente || ' ' || cognome_cliente);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciTesto(media);
                                modGUI.chiudiElementoTabella;
                                modGUI.apriElementoTabella;
                                    modGUI.inserisciLente('visualizzaCliente', id_sessione, nome, ruolo, id_cliente);
                                modGUI.chiudiElementoTabella;
                            modGUI.chiudiRigaTabella;
                        end loop;
                        close riga;
                    modGUI.chiudiTabella;
                end if;
            modGUI.chiudiDiv;
        modGUI.chiudiPagina;
    end resClassificaMediaPermanenza;

    procedure sediSovrappopolate(id_Sessione int, nome varchar2, ruolo varchar2) is
    begin
        modGUI.apriPagina('HoC | Sedi sovrappopolate', id_sessione, nome, ruolo);
        modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('SEDI SOVRAPPOPOLATE');
        modGUI.chiudiIntestazione(2);
        modGUI.apriForm(groupname || 'resSediSovrappopolate');
            modGUI.inserisciInputHidden('id_Sessione', id_Sessione);
            modGUI.inserisciInputHidden('nome', nome);
            modGUI.inserisciInputHidden('ruolo', ruolo);
            modGUI.inserisciInput('var_giorno', 'GIORNO', 'date', true);
            modGUI.inserisciInput('var_soglia', 'SOGLIA POSTI OCCUPATI', 'number', true);
            modGUI.inserisciBottoneReset;
            modGUI.inserisciBottoneForm(testo=>'RICERCA SEDI');
        modGUI.chiudiForm;
        modGUI.chiudiPagina;
    end sediSovrappopolate;

    procedure primaComune(id_Sessione int, nome varchar2, ruolo varchar2) is
    begin
        modGUI.apriPagina('HoC | Prima comune', id_Sessione, nome, ruolo);
        modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('PRIMA COMUNE');
        modGUI.chiudiIntestazione(2);
        modGUI.apriForm(groupname || 'resPrimaComune');
            modGUI.inserisciInputHidden('id_Sessione', id_Sessione);
            modGUI.inserisciInputHidden('nome', nome);
            modGUI.inserisciInputHidden('ruolo', ruolo);
            modGUI.inserisciInput('var_inizio', 'INIZIO PERIODO', 'date', true);
            modGUI.inserisciInput('var_fine', 'FINE PERIODO', 'date', true);
            modGUI.inserisciInput('soglia', 'IMPORTO SOGLIA', 'number', true);
            modGUI.inserisciBottoneReset;
            modGUI.inserisciBottoneForm(testo=>'RICERCA');
        modGUI.chiudiForm;
        modGUI.chiudiPagina;
    end primaComune;

    procedure resPrimaComune(id_Sessione int, nome varchar2, ruolo varchar2, var_inizio varchar2, var_fine varchar2, soglia int) is
        var_check1 boolean := false;
        begin
        modGUI.apriPagina('HoC | Prima comune', id_Sessione, nome, ruolo);
            modGUI.apriIntestazione(2);
            modGUI.inserisciTesto('PRIMA COMUNE');
            modGUI.chiudiIntestazione(2);
            modGUI.apriTabella;
            modGUI.apriRigaTabella;
                modGUI.intestazioneTabella('NOME');
                modGUI.intestazioneTabella('COGNOME');
                modGUI.intestazioneTabella('NUMERO INGRESSO');
                modGUI.intestazioneTabella('NUMERO MULTE');
                modGUI.intestazioneTabella('IMPORTO MULTE');
                modGUI.intestazioneTabella('DETTAGLI');
            modGUI.chiudiRigaTabella;
            for cur in (
                with
            TotIngressiOrari as (
                select
                    C.idCliente as idCliente,
                    count(*) as TotIngressi
                from Clienti C
                    join EffettuaIngressiOrari EIO on EIO.idCliente = C.idCliente
                    join IngressiOrari IO on IO.idIngressoOrario = EIO.idIngressoOrario
                where IO.OraUscita between TO_DATE(var_inizio, 'yyyy-mm-dd') and TO_DATE(var_fine, 'yyyy-mm-dd')
                group by C.idCliente
            ),
            MulteOrarie as (
                select
                    C.idCliente as idCliente,
                    count(*) as TotMulte,
                    sum(M.Importo) as Importo
                from Clienti C
                    join EffettuaIngressiOrari EIO on EIO.idCliente = C.idCliente
                    join IngressiOrari IO on IO.idIngressoOrario = EIO.idIngressoOrario
                    join Multe M on M.idMulta = IO.idMulta
                where IO.OraUscita between TO_DATE(var_inizio, 'yyyy-mm-dd') and TO_DATE(var_fine, 'yyyy-mm-dd')
                group by C.idCliente
            ),
            TotIngressiAbbonamenti as (
                select
                    C.idCliente as idCliente,
                    count(*) as TotIngressi
                from Clienti C
                    join EffettuaIngressiAbbonamenti EIA on EIA.idCliente = C.idCliente
                    join IngressiAbbonamenti IA on IA.idIngressoAbbonamento = EIA.idIngressoAbbonamento
                where IA.OraUscita between TO_DATE(var_inizio, 'yyyy-mm-dd') and TO_DATE(var_fine, 'yyyy-mm-dd')
                group by C.idCliente
            ),
            MulteAbbonamenti as (
                select
                    C.idCliente as idCliente,
                    count(*) as TotMulte,
                    sum(M.Importo) as Importo
                from Clienti C
                    join EffettuaIngressiAbbonamenti EIA on EIA.idCliente = C.idCliente
                    join IngressiAbbonamenti IA on IA.idIngressoAbbonamento = EIA.idIngressoAbbonamento
                    join Multe M on M.idMulta = IA.idMulta
                where IA.OraUscita between TO_DATE(var_inizio, 'yyyy-mm-dd') and TO_DATE(var_fine, 'yyyy-mm-dd')
                group by C.idCliente
            ),
            TotOrari as (
                select
                    TIO.idCliente as idCliente,
                    TIO.TotIngressi as TotIngressi,
                    coalesce(MO.TotMulte, 0) as TotMulte,
                    coalesce(MO.Importo, 0) as Importo
                from TotIngressiOrari TIO
                    full outer join MulteOrarie MO on MO.idCliente = TIO.idCliente
            ),
            TotAbbonamenti as (
                select
                    TIA.idCliente as idCliente,
                    TIA.TotIngressi as TotIngressi,
                    coalesce(MA.TotMulte, 0) as TotMulte,
                    coalesce(MA.Importo, 0) as Importo
                from TotIngressiAbbonamenti TIA
                    full outer join MulteAbbonamenti MA on MA.idCliente = TIA.idCliente
            ),
            TotIngressi as (
                select
                    coalesce(TotOrari.idCliente, TotAbbonamenti.idCliente) as idCliente,
                    coalesce(TotOrari.TotIngressi, 0) + coalesce(TotAbbonamenti.TotIngressi, 0) as TotIngressi,
                    coalesce(TotOrari.TotMulte, 0) + coalesce(TotAbbonamenti.TotMulte, 0) as TotMulte,
                    coalesce(TotOrari.Importo, 0) + coalesce(TotAbbonamenti.Importo, 0) as Importo
                from TotOrari
                    full outer join TotAbbonamenti on TotAbbonamenti.idCliente = TotOrari.idCliente 
            )
        select P.idPersona PIP, C.idCliente CIC, P.Nome PN, P.Cognome PC, P.Indirizzo PI, TI.TotIngressi TITI, TI.TotMulte TITM, TI.Importo TII
        from Persone P
            join Clienti C on C.idPersona = P.idPersona
            join TotIngressi TI on TI.idCliente = C.idCliente
        where
            TI.Importo > 1
            and TI.TotMulte > ((TI.TotIngressi / 2) + 1)
                ) loop
                var_check1 := true;
                modGUI.apriRigaTabella;
                    modGUI.apriElementoTabella;
                    modGUI.elementoTabella(cur.PN);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                    modGUI.elementoTabella(cur.PC);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                    modGUI.elementoTabella(cur.TITI);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                    modGUI.elementoTabella(cur.TITM);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                    modGUI.elementoTabella(cur.TII);
                    modGUI.chiudiElementoTabella;
                    modGUI.apriElementoTabella;
                    modGUI.inserisciLente(groupname || 'dettagliPrimaComune', id_Sessione, nome, ruolo, cur.PIP, '&' || 'var_ning=' || cur.TITI || '&' || 'var_nmul=' || cur.TITM || '&' || 'var_impmul=' || cur.TII);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                end loop;
            modGUI.chiudiTabella;
            if(var_check1 = false) then
                modGUI.apriDiv(centrato=>true);
                    modGUI.inserisciTesto('NESSUN RISULTATO');
                modGUI.chiudiDiv;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
            end if;
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('ALTRE OPERAZIONI');
            modGUI.chiudiIntestazione(3);
            modGUI.apriDiv(centrato=>true);
                modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'NUOVA RICERCA', 'primaComune');
            modGUI.chiudiDiv;
            modGUI.chiudiPagina;
        end resPrimaComune;

    procedure dettagliPrimaComune(id_Sessione int, nome varchar2, ruolo varchar2, idRiga varchar2, var_ning varchar2, var_nmul varchar2, var_impmul varchar2) is
        var_IndirizzoAutorimessa Autorimesse.Indirizzo%TYPE;
        var_TelefonoAutorimessa Autorimesse.Telefono%TYPE;
        var_Coordinate Autorimesse.Coordinate%TYPE;
        var_CF Persone.CodiceFiscale%TYPE;
        var_Cognome Persone.Cognome%TYPE;
        var_Nome Persone.Nome%TYPE;
        var_IndirizzoCliente Persone.Indirizzo%TYPE;
        var_Sesso Persone.Sesso%TYPE;
        var_Email Persone.Email%TYPE;
        var_TelefonoCliente Persone.Telefono%TYPE;
        var_DataNascita Persone.DataNascita%TYPE;
    begin
        modGUI.apriPagina('HoC | Dettagli prima comune', id_Sessione, nome, ruolo);
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('DETTAGLI PRIMA COMUNE');
            modGUI.chiudiIntestazione(2);

            select CodiceFiscale, Cognome, Nome, Indirizzo, Sesso, Email, Telefono, DataNascita
            into var_CF, var_Cognome, var_Nome, var_IndirizzoCliente, var_Sesso, var_Email, var_TelefonoCliente, var_DataNascita
            from Persone
            where idPersona = idRiga;

            modGUI.apriTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('ID CLIENTE');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(idRiga);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('CODICE FISCALE');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_CF);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('COGNOME');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_Cognome);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('NOME');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_Nome);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('INDIRIZZO');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_IndirizzoCliente);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('SESSO');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_Sesso);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('EMAIL');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_Email);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('TELEFONO');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_TelefonoCliente);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('DATA DI NASCITA');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_DataNascita);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
            modGUI.chiudiTabella;
            modGUI.apriTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('NUMERO TOTALE INGRESSI');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_ning);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                modGUI.intestazioneTabella('NUMERO TOTALE MULTE');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_nmul);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                modGUI.intestazioneTabella('IMPORTO TOTALE MULTE');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_impmul);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
            modGUI.chiudiTabella;
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('ALTRE OPERAZIONI');
            modGUI.chiudiIntestazione(2);
            modGUI.apriDiv(centrato=>true);
                modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'NUOVA RICERCA', groupname || 'primaComune');
            modGUI.chiudiDiv;
        modGUI.chiudiPagina;
    end dettagliPrimaComune;

    procedure quintaComune(id_Sessione int, nome varchar2, ruolo varchar2) is
    begin
        modGUI.apriPagina('HoC | Quinta comune', id_Sessione, nome, ruolo);
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('QUINTA COMUNE');
            modGUI.chiudiIntestazione(2);
            modGUI.apriForm(groupname || 'resQuintaComune');
                modGUI.inserisciInputHidden('id_Sessione', id_Sessione);
                modGUI.inserisciInputHidden('nome', nome);
                modGUI.inserisciInputHidden('ruolo', ruolo);
                modGUI.inserisciInput('x', 'DURATA DEL PARCHEGGIO IN GIORNI', 'number', true);
                modGUI.inserisciBottoneReset;
                modGUI.inserisciBottoneForm(testo=>'RICERCA');
            modGUI.chiudiForm;
        modGUI.chiudiPagina;
    end quintaComune;

    procedure resQuintaComune(id_Sessione int, nome varchar2, ruolo varchar2, x int) is
    var_check1 boolean := false;
    var_check2 boolean := false;
    begin
        modGUI.apriPagina('HoC | Quinta Comune', id_Sessione, nome, ruolo);
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('PARCHEGGI DURATI ALMENO ' || x || ' GIORNI');
            modGUI.chiudiIntestazione(2);
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('PARCHEGGI CON ABBONAMENTI');
            modGUI.chiudiIntestazione(3);
            modGUI.apriTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('NOME');
                    modGUI.intestazioneTabella('COGNOME');
                    modGUI.intestazioneTabella('AUTORIMESSA');
                    modGUI.intestazioneTabella('DETTAGLI');
                modGUI.chiudiRigaTabella;
                for cur_abb in (
                    select distinct Persone.Nome PN, Persone.Cognome PC, Persone.idPersona PIP, AR.Indirizzo ARI, AR.idAutorimessa ARIA
                    from Persone
                        join Clienti C on C.idPersona = Persone.idPersona
                        join EffettuaIngressiAbbonamenti EIA on EIA.idCliente = C.idCliente
                        join IngressiAbbonamenti IA on IA.idIngressoAbbonamento = EIA.idIngressoAbbonamento
                        join Box B on B.idBox = IA.idBox
                        join Aree A on A.idArea = B.idArea
                        join Autorimesse AR on AR.idAutorimessa = A.idAutorimessa
                        join Sedi S on S.idSede = AR.idSede
                        where CAST(IA.OraUscita AS DATE) - CAST(IA.OraEntrata AS DATE) >= x
                ) loop
                    var_check1 := true;
                    modGUI.apriRigaTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(cur_abb.PN);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(cur_abb.PC);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(cur_abb.ARI);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.inserisciLente(groupname || 'dettagliQuintaComune', id_Sessione, nome, ruolo, cur_ABB.PIP, '&' || 'id_Autorimessa=' || cur_ABB.ARIA);
                        modGUI.chiudiElementoTabella;
                    modGUI.chiudiRigaTabella;
                end loop;
            modGUI.chiudiTabella;
            if(var_check1 = false) then
                modGUI.apriDiv(centrato=>true);
                    modGUI.inserisciTesto('NESSUN RISULTATO');
                modGUI.chiudiDiv;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
            end if;
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('PARCHEGGI CON TICKET');
            modGUI.chiudiIntestazione(3);
            modGUI.apriTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('NOME');
                    modGUI.intestazioneTabella('COGNOME');
                    modGUI.intestazioneTabella('AUTORIMESSA');
                    modGUI.intestazioneTabella('DETTAGLI');
                modGUI.chiudiRigaTabella;
                for cur_or in (
                    select distinct Persone.Nome PN, Persone.Cognome PC, Persone.idPersona PIP, AR.Indirizzo ARI, AR.idAutorimessa ARIA
                    from Persone
                        join Clienti C on C.idPersona = Persone.idPersona
                        join EffettuaIngressiOrari EIO on EIO.idCliente = C.idCliente
                        join IngressiOrari IO on IO.idIngressoOrario = EIO.idIngressoOrario
                        join Box B on B.idBox = IO.idBox
                        join Aree A on A.idArea = B.idArea
                        join Autorimesse AR on AR.idAutorimessa = A.idAutorimessa
                        join Sedi S on S.idSede = AR.idSede
                        where CAST(IO.OraUscita AS DATE) - CAST(IO.OraEntrata AS DATE) >= x
                ) loop
                    var_check2 := true;
                    modGUI.apriRigaTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(cur_or.PN);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(cur_or.PC);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.elementoTabella(cur_or.ARI);
                        modGUI.chiudiElementoTabella;
                        modGUI.apriElementoTabella;
                            modGUI.inserisciLente(groupname || 'dettagliQuintaComune', id_Sessione, nome, ruolo, cur_or.PIP, '&' || 'id_Autorimessa=' || cur_or.ARIA);
                        modGUI.chiudiElementoTabella;
                    modGUI.chiudiRigaTabella;
                end loop;
            modGUI.chiudiTabella;
            if(var_check2 = false) then
                modGUI.apriDiv(centrato=>true);
                    modGUI.inserisciTesto('NESSUN RISULTATO');
                modGUI.chiudiDiv;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
                modGUI.aCapo;
            end if;
        modGUI.chiudiPagina;
        modGUI.apriIntestazione(3);
            modGUI.inserisciTesto('ALTRE OPERAZIONI');
        modGUI.chiudiIntestazione(3);
        modGUI.apriDiv(centrato=>true);
            modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'NUOVA RICERCA', 'quintaComune');
        modGUI.chiudiDiv;
    end resQuintaComune;

procedure dettagliQuintaComune(id_Sessione int, nome varchar2, ruolo varchar2, idRiga varchar2, id_Autorimessa varchar2) is
    var_IndirizzoAutorimessa Autorimesse.Indirizzo%TYPE;
    var_TelefonoAutorimessa Autorimesse.Telefono%TYPE;
    var_Coordinate Autorimesse.Coordinate%TYPE;
    var_CF Persone.CodiceFiscale%TYPE;
    var_Cognome Persone.Cognome%TYPE;
    var_Nome Persone.Nome%TYPE;
    var_IndirizzoCliente Persone.Indirizzo%TYPE;
    var_Sesso Persone.Sesso%TYPE;
    var_Email Persone.Email%TYPE;
    var_TelefonoCliente Persone.Telefono%TYPE;
    var_DataNascita Persone.DataNascita%TYPE;
    begin
        modGUI.apriPagina('HoC | Dettagli Quinta Comune', id_Sessione, nome, ruolo);
            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('DETTAGLI QUINTA COMUNE');
            modGUI.chiudiIntestazione(2);
            
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('DETTAGLI CLIENTE');
            modGUI.chiudiIntestazione(3);
            
            select CodiceFiscale, Cognome, Nome, Indirizzo, Sesso, Email, Telefono, DataNascita
            into var_CF, var_Cognome, var_Nome, var_IndirizzoCliente, var_Sesso, var_Email, var_TelefonoCliente, var_DataNascita
            from Persone
            where idPersona = idRiga;
            
            modGUI.apriTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('ID CLIENTE');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(idRiga);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('CODICE FISCALE');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_CF);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('COGNOME');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_Cognome);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('NOME');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_Nome);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('INDIRIZZO');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_IndirizzoCliente);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('SESSO');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_Sesso);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('EMAIL');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_Email);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('TELEFONO');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_TelefonoCliente);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('DATA DI NASCITA');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_DataNascita);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
            modGUI.chiudiTabella;
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('DETTAGLI AUTORIMESSA');
            modGUI.chiudiIntestazione(3);
            
            select Indirizzo, Telefono, Coordinate
            into var_IndirizzoAutorimessa, var_TelefonoAutorimessa, var_Coordinate
            from Autorimesse
            where idAutorimessa = id_Autorimessa;
            
            modGUI.apriTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('ID AUTORIMESSA');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(id_Autorimessa);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('INDIRIZZO');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_IndirizzoAutorimessa);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('TELEFONO');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_TelefonoAutorimessa);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
                modGUI.apriRigaTabella;
                    modGUI.intestazioneTabella('COORDINATE');
                    modGUI.apriElementoTabella;
                        modGUI.elementoTabella(var_Coordinate);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiRigaTabella;
            modGUI.chiudiTabella;
            modGUI.apriIntestazione(3);
                modGUI.inserisciTesto('ALRE OPERAZIONI');
            modGUI.chiudiIntestazione(3);
            modGUI.apriDiv(centrato=>true);
                modGUI.inserisciBottone(id_Sessione, nome, ruolo, 'NUOVA RICERCA', groupname || 'quintaComune');
            modGUI.chiudiDiv;
        modGUI.chiudiPagina;
    end dettagliQuintaComune;

end gruppo2;
