create or replace package gruppo2 as
    groupname constant varchar2(8) := 'gruppo2.';
    TYPE list_idaree is varray(2) of number(1);
    procedure autorimessanontrovata(id_sessione int default 0, nome varchar2, ruolo varchar2);
    procedure competentGarageSearch2 (id_Sessione varchar2, nome varchar2, ruolo varchar2, idSedeCorrente integer, idVeicoloCorrente integer);
    procedure formRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2);
    procedure introitiparziali(id_Sessione varchar2, nome varchar2, ruolo varchar2, idsedecorrente varchar2);
    procedure graphicResultRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2, autorimessa number, veicolo varchar2);
    procedure introiti(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure modificaArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure modificaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure modificaSede(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    function queryRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2, autorimessa varchar2, veicolo varchar2) return list_idaree;
    procedure sediSovrappopolate(id_Sessione int, nome varchar2, ruolo varchar2);
    procedure resSediSovrappopolate(id_Sessione varchar2, nome varchar2, ruolo varchar2, var_giorno varchar2, var_soglia number);
    procedure ricercaAutorimessa(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure classificaSediPiuRedditizie(id_sessione int default 0, nome varchar2, ruolo varchar2);
    procedure statisticaGenerale6(id_sessione varchar2,nome varchar2, ruolo varchar2);
    procedure updateArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int, var_posti_totali Aree.PostiTotali%TYPE, var_posti_liberi Aree.PostiLiberi%TYPE, var_stato Aree.Stato%TYPE, var_gas Aree.Gas%TYPE, var_lunghezza_max Aree.LunghezzaMax%TYPE, var_larghezza_max Aree.LarghezzaMax%TYPE, var_peso_max Aree.PesoMax%TYPE, var_costo_abbonamento Aree.CostoAbbonamento%TYPE);
    procedure updateAutorimessa(
        id_sessione int default 0,
        nome varchar2,
        ruolo varchar2,
        idRiga int,
        var_indirizzo Autorimesse.Indirizzo%TYPE,
        var_telefono Autorimesse.Telefono%TYPE,
        var_coordinate Autorimesse.Coordinate%TYPE
    );
    procedure updateSede(
        id_sessione int default 0,
        nome varchar2,
        ruolo varchar2,
        idRiga int,
        var_indirizzo Sedi.Indirizzo%TYPE,
        var_telefono Sedi.Telefono%TYPE,
        var_coordinate Sedi.Coordinate%TYPE
    );
    procedure visualizzaArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure visualizzaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure visualizzaBox(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure visualizzaintroitiparzialiabb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idriga varchar2);
    procedure visualizzaSede(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure ricercaAuto(id_Sessione int, nome varchar2, ruolo varchar2);
    procedure resRicercaAuto(id_Sessione int, nome varchar2, ruolo varchar2, var_idCliente int);
    
    
    procedure AlimentazioneVeicolo(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure AlimentazioneVeicolo2(id_Sessione varchar2, nome varchar2, ruolo varchar2, autorimessaScelta varchar2);
    procedure PercentualiPostiLiberi (id_Sessione varchar2, nome varchar2, ruolo varchar2);
    PROCEDURE PercentualePostiLiberi2(id_Sessione varchar2, nome varchar2, ruolo varchar2, modalita varchar2, areaScelta varchar2);    procedure MaxTipoVeicolo(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure MaggiorPostiRiservati(id_Sessione varchar2, nome varchar2, ruolo varchar2);

    procedure statisticaGenerale2(id_Sessione int, nome varchar2, ruolo varchar2);
    procedure resStatisticaGenerale2(id_Sessione int, nome varchar2, ruolo varchar2, var_idCliente int, var_autorimessa int, var_inizio varchar2, var_fine varchar2);
    procedure dettagliVeicoloStatisticaGenerale2(id_Sessione int, nome varchar2, ruolo varchar2, idRiga int);

    procedure statisticaGenerale4 (id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure resStatisticaGenerale4 (id_Sessione varchar2, nome varchar2, ruolo varchar2, tipoAlimentazione1 veicoli.alimentazione%type, tipoAlimentazione2 veicoli.alimentazione%type, dataInizioInserita varchar2, dataFineInserita varchar2);

    procedure veicoloMenoParcheggiato(id_sessione int, nome varchar2, ruolo varchar2);
    procedure resVeicoloMenoParcheggiato(id_sessione int, nome varchar2, ruolo varchar2, id_cliente int);
    
    procedure ingressiSopraMedia(id_sessione int, nome varchar2, ruolo varchar2);
    procedure resIngressiSopraMedia(id_sessione int, nome varchar2, ruolo varchar2, var_inizio varchar2, var_fine varchar2);
    
    procedure statisticaGenerale3(id_sessione int, nome varchar2, ruolo varchar2);
    procedure resStatisticaGenerale3(id_sessione int, nome varchar2, ruolo varchar2, var_soglia int);

    procedure statisticaGenerale1(id_Sessione int, nome varchar2, ruolo varchar2);
    procedure resStatisticaGenerale1(id_Sessione int, nome varchar2, ruolo varchar2, var_inizio varchar2, var_fine varchar2, soglia int);
    procedure dettagliStatisticaGenerale1(id_Sessione int, nome varchar2, ruolo varchar2, idRiga varchar2, var_ning varchar2, var_nmul varchar2, var_impmul varchar2);
    
    procedure statisticaGenerale5(id_Sessione int, nome varchar2, ruolo varchar2);
    procedure resStatisticaGenerale5(id_Sessione int, nome varchar2, ruolo varchar2, x int);
    procedure dettagliStatisticaGenerale5(id_Sessione int, nome varchar2, ruolo varchar2, idRiga varchar2, id_Autorimessa varchar2);

    procedure formAutorimessaMaxPostiPeriodo(id_sessione varchar2, nome varchar2, ruolo varchar2);
    procedure autorimessaMaxPostiPeriodo(id_sessione varchar2, nome varchar2, ruolo varchar2, x_datainiziale varchar2, y_datafinale varchar2);

end gruppo2;
