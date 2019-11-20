create or replace procedure updateAutorimessa(
    id_sessione int default 0,
    nome varchar2,
    ruolo varchar2,
    idRiga int,
    var_indirizzo Autorimesse.Indirizzo%TYPE,
    var_telefono Autorimesse.Telefono%TYPE,
    var_coordinate Autorimesse.Coordinate%TYPE
) AS 
BEGIN
    -- Aggiorna la sede
    update Autorimesse set
        Autorimesse.Indirizzo = var_indirizzo,
        Autorimesse.Telefono = var_telefono,
        Autorimesse.Coordinate = var_coordinate
    where Autorimesse.idAutorimessa = idRiga;
    commit;
    -- Richiama la visualizzazione
    visualizzaAutorimessa(id_sessione, nome, ruolo, idRiga);
end updateAutorimessa;