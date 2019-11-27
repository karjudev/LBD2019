create or replace procedure updateAutorimessa(
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