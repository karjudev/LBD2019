create or replace procedure updateSede(
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
        update Sedi set
            Sedi.Indirizzo = var_indirizzo,
            Sedi.Telefono = var_telefono,
            Sedi.Coordinate = var_coordinate
        where Sedi.idSede = idRiga;
        commit;
        -- Richiama la visualizzazione
        visualizzaSede(id_sessione, nome, ruolo, idRiga);
    end if;
end updateSede;