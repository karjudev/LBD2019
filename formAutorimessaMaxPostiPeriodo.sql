create or replace procedure formAutorimessaMaxPostiPeriodo(id_sessione varchar2, nome varchar2, ruolo varchar2) is
begin
        modGUI.apriPagina('HoC | Inserisci dati', id_Sessione, nome, ruolo);
        modgui.acapo;
        modgui.apriForm('autorimessaMaxPostiPeriodo');
         modgui.inserisciinputhidden('id_Sessione',id_Sessione);
        modgui.inserisciinputhidden('nome',nome);
        modgui.inserisciinputhidden('ruolo',ruolo);

        modGUI.inserisciinput('Data inizio', 'date','x_datainiziale',true,'','defInput');
        modGUI.inserisciinput('Data fine', 'date','y_datafinale',true,'','defInput');

        modGUI.inserisciBottoneReset('RESET');
        modGUI.inserisciBottoneForm('Submit','defFormButton');
        modgui.chiudiform;
end formAutorimessaMaxPostiPeriodo;