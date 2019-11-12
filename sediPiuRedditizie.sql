create or replace procedure classificaSediPiuRedditizie(idSessione int default 0, nome varchar2, ruolo varchar2) is
    -- ID della sede corrente
    idSede number;
    indirizzo varchar2(100);
    totale number;
    -- Cursore che scorre nella query delle sedi ordinate per guadagno
    cursor sediCursor is
        select sedi.idsede, sedi.indirizzo, (sum(ingressiorari.costo) + sum(abbonamenti.costoeffettivo)) as totale
        from sedi
            join autorimesse on sedi.idsede = autorimesse.idsede
            join aree on autorimesse.idautorimessa = aree.idautorimessa
            join box on aree.idarea = box.idarea
            join ingressiorari on box.idbox = ingressiorari.idbox
            join ingressiabbonamenti on box.idbox = ingressiabbonamenti.idbox
            join abbonamenti on ingressiabbonamenti.idabbonamento = abbonamenti.idabbonamento
        group by sedi.idsede, sedi.indirizzo
        order by totale;
    begin
        -- Crea la pagina e l'intestazione
        modGUI.apriPagina(
            'HoC | Sedi più Redditizie',
            idSessione => idSessione,
            nome => nome,
            ruolo => ruolo
        );
        modGUI.aCapo;
        modGUI.apriIntestazione(3);
            modGUI.inserisciTesto('SEDI PIÙ REDDITIZIE');
        modGUI.chiudiIntestazione(3);

    modGUI.ApriTabella;
        modGUI.ApriRigaTabella;
            modGUI.intestazioneTabella('ID Sede');
            modGUI.intestazioneTabella('Indirizzo');
            modGUI.intestazioneTabella('Totale');
            /*Viene aggiunta una nuova colonna per i bottoni che permetteranno l'eliminazione della riga*/
            modGUI.intestazioneTabella('');
        modGUI.ChiudiRigaTabella;
        -- Apre il cursore
        open sediCursor;
        -- Scorre il cursore
        loop
            fetch sediCursor into idSede, indirizzo, totale;
            exit when sediCursor%NOTFOUND;
            modGUI.ApriRigaTabella;
                modGUI.ApriElementoTabella;
                    modGUI.ElementoTabella(idSede);
                modGUI.ChiudiElementoTabella;
                modGUI.ApriElementoTabella;
                    modGUI.ElementoTabella(indirizzo);
                modGUI.ChiudiElementoTabella;
                modGUI.ApriElementoTabella;
                    modGUI.ElementoTabella(totale);
                modGUI.ChiudiElementoTabella;
            modGUI.ChiudiRigaTabella;
        end loop;
        -- Chiude il cursore
        close sediCursor;
        modGUI.chiudiPagina;
    end classificaSediPiuRedditizie;