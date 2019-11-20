create or replace procedure updateArea(
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