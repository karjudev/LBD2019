create or replace package gruppo2 as
    groupname constant varchar2(8) := 'gruppo2.';
    TYPE list_idaree is varray(2) of number(1);
    procedure gruppo2.autorimessanontrovata(id_sessione int default 0, nome varchar2, ruolo varchar2);
    procedure gruppo2.competentGarageSearch2 (id_Sessione varchar2, nome varchar2, ruolo varchar2, idSedeCorrente integer, idVeicoloCorrente integer);
    procedure gruppo2.formRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2);
    procedure gruppo2.introitiparziali(id_Sessione varchar2, nome varchar2, ruolo varchar2, idsedecorrente varchar2, periodo varchar2, datainiziale varchar2, datafinale varchar2);
    procedure gruppo2.graphicResultRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2, autorimessa number, veicolo varchar2);
    procedure gruppo2.introiti(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure gruppo2.modificaArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure gruppo2.modificaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure gruppo2.modificaSede(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    function gruppo2.queryRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2, autorimessa varchar2, veicolo varchar2) return list_idaree;
    procedure gruppo2.resSediSovrappopolate(id_Sessione varchar2, nome varchar2, ruolo varchar2, var_giorno varchar2, var_soglia number);
    procedure gruppo2.ricercaAutorimessa(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure gruppo2.classificaSediPiuRedditizie(id_sessione int default 0, nome varchar2, ruolo varchar2);
    procedure gruppo2.statisticaalimentazione(id_sessione varchar2,nome varchar2, ruolo varchar2);
    procedure gruppo2.updateArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int, var_posti_totali Aree.PostiTotali%TYPE, var_posti_liberi Aree.PostiLiberi%TYPE, var_stato Aree.Stato%TYPE, var_gas Aree.Gas%TYPE, var_lunghezza_max Aree.LunghezzaMax%TYPE, var_larghezza_max Aree.LarghezzaMax%TYPE, var_peso_max Aree.PesoMax%TYPE, var_costo_abbonamento Aree.CostoAbbonamento%TYPE);
    procedure gruppo2.updateAutorimessa(
        id_sessione int default 0,
        nome varchar2,
        ruolo varchar2,
        idRiga int,
        var_indirizzo Autorimesse.Indirizzo%TYPE,
        var_telefono Autorimesse.Telefono%TYPE,
        var_coordinate Autorimesse.Coordinate%TYPE
    );
    procedure gruppo2.updateSede(
        id_sessione int default 0,
        nome varchar2,
        ruolo varchar2,
        idRiga int,
        var_indirizzo Sedi.Indirizzo%TYPE,
        var_telefono Sedi.Telefono%TYPE,
        var_coordinate Sedi.Coordinate%TYPE
    );
    procedure gruppo2.visualizzaArea(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure gruppo2.visualizzaAutorimessa(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure gruppo2.visualizzaBox(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure gruppo2.visualizzaintroitiparzialiabb(id_Sessione varchar2, nome varchar2, ruolo varchar2, idriga varchar2, periodo varchar2, datainiziale varchar2 default null, datafinale varchar2 default null);
    procedure gruppo2.visualizzaSede(id_sessione int default 0, nome varchar2, ruolo varchar2, idRiga int);
    procedure gruppo2.ricercaAuto(id_Sessione int, nome varchar2, ruolo varchar2);
    procedure gruppo2.resRicercaAuto(id_Sessione int, nome varchar2, ruolo varchar2, var_idCliente int);
    
    
    procedure gruppo2.AlimentazioneVeicolo(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure gruppo2.AlimentazioneVeicolo2(id_Sessione varchar2, nome varchar2, ruolo varchar2, autorimessaScelta varchar2);
    procedure gruppo2.PercentualiPostiLiberi (id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure gruppo2.PercentualePostiLiberi2(id_Sessione varchar2, nome varchar2, ruolo varchar2, modalita varchar2, areaScelta varchar2);
    procedure gruppo2.MaxTipoVeicolo(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure gruppo2.MaggiorPostiRiservati(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    procedure gruppo2.ClientiSenzaAbbonamentoRinnovato(id_Sessione varchar2, nome varchar2, ruolo varchar2);
    function gruppo2.RicercaPosto( idveicoloScelto veicoli.idveicolo%type, idautorimessaScelta autorimesse.idautorimessa%type);

    procedure gruppo2.secondaComune(id_Sessione int, nome varchar2, ruolo varchar2);
    procedure gruppo2.resSecondaComune(id_Sessione int, nome varchar2, ruolo varchar2, var_idCliente int, var_autorimessa int, var_inizio varchar2, var_fine varchar2);
    procedure gruppo2.dettagliVeicoloSecondaComune(id_Sessione int, nome varchar2, ruolo varchar2, idRiga int);

    procedure gruppo2.veicoloMenoParcheggiato(id_sessione int, nome varchar2, ruolo varchar2);
end gruppo2;
