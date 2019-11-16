create or replace procedure visualizzaBox(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int) is
    -- Parametri del box corrente
    var_box Box%ROWTYPE;
    -- Parametri di un eventuale veicolo
    veicolo Veicoli%ROWTYPE;
    -- ID e indirizzo dell'autorimessa di riferimento
    id_autorimessa Autorimesse.idAutorimessa%TYPE;
    indirizzo_autorimessa Autorimesse.Indirizzo%TYPE;
    begin
        -- Trova la sede
        select * into var_box
        from Box
        where Box.idBox = idRiga;
        -- Trova ID della sede e indirizzo dell'autorimessa
        select Autorimesse.idSede, Autorimesse.Indirizzo into id_autorimessa, indirizzo_autorimessa
        from Autorimesse
        join Aree on Aree.idAutorimessa = Autorimesse.idAutorimessa
        where Aree.idArea = var_box.idArea;
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina('HoC | Box ' || idRiga || ' area ' || var_box.idArea || ' di ' || indirizzo_autorimessa, id_sessione, nome, ruolo);
            modGUI.aCapo;

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
                        modGUI.ElementoTabella(var_box.idArea);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
                modGUI.ApriRigaTabella;
                    modGUI.IntestazioneTabella('Autorimessa');
                    modGUI.ApriElementoTabella;
                        modGUI.ElementoTabella(indirizzo_autorimessa);
                    modGUI.ChiudiElementoTabella;
                modGUI.ChiudiRigaTabella;
            modGUI.ChiudiTabella;

            modGUI.ApriTabella;
                modGUI.ApriRigaTabella;
                    modGUI.ApriElementoTabella;
                        modGUI.InserisciPenna('modificaBox', id_sessione, nome, ruolo, idRiga);
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
                    and IngressiOrari.OraUscita = NULL;
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
                        modGUI.InserisciLente('visualizzaVeicolo', id_sessione, nome, ruolo, veicolo.idVeicolo);
                    modGUI.chiudiElementoTabella;
                modGUI.chiudiTabella;
            end if;
        modGUI.ChiudiPagina;
    end visualizzaBox;