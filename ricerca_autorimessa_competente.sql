create or replace procedure ricercaAutorimessa(id_Sessione varchar2, nome varchar2, ruolo varchar2) is
tmp integer;
idses integer;
begin
    if(ruolo='C') then
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
        modgui.apriForm('competentGarageSearch2');
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

        select distinct count(*) into tmp from veicoli vec, veicoliclienti clive, clienti cli, persone pers, sessioni ses where vec.idveicolo=clive.idveicolo and clive.idcliente= cli.idcliente and cli.idpersona=pers.idpersona and pers.idpersona=ses.idpersona and ses.idsessione=idses; /*vec  where exists (select* from sessioni ses, persone pers, clienti cli, veicoliclienti clive where idSessione=ses.idsessione and ses.idpersona=pers.idpersona and cli.idpersona=pers.idpersona and clive.idveicolo=vec.idveicolo and clive.idcliente=cli.idcliente);*/
        if(tmp=0) then 
                        modGUI.inserisciOpzioneSelect('','Nessun veicolo disponibile',false);
        else
            for veicolo in (select distinct vec.* from veicoli vec, veicoliclienti clive, clienti cli, persone pers, sessioni ses where vec.idveicolo=clive.idveicolo and clive.idcliente= cli.idcliente and cli.idpersona=pers.idpersona and pers.idpersona=ses.idpersona and ses.idsessione=idses)
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
     modGUI.esitoOperazione('KO', 'Questa operazione è disponibile soltanto per i clienti');
    end if;

    modGUI.chiudiPagina;
end ricercaAutorimessa;