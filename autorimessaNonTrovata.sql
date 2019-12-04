create or replace PROCEDURE autorimessanontrovata(id_sessione int default 0, nome varchar2, ruolo varchar2) is
    -- Parametri della sede corrente

    begin

        modGUI.apriPagina('HoC | ', id_sessione, nome, ruolo);
            modGUI.aCapo;

            modGUI.apriIntestazione(2);
                modGUI.inserisciTesto('IL VEICOLO SELEZIONATO NON PUO'' ESSERE PARCHEGGIATO NELLA SEDE SELEZIONATA');
            modGUI.chiudiIntestazione(2);


        modGUI.ChiudiPagina;
    end autorimessanontrovata;