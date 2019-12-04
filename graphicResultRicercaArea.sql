create or replace procedure graphicResultRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2, autorimessa number, veicolo varchar2) is
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
            modGUI.esitoOperazione('KO', 'Non è stata trovata nessun''area disponibile per il tuo veicolo!');
        else
            modGUI.chiudiDiv;
        end if;
    modGUI.chiudiPagina;
  end graphicResultRicercaArea;
