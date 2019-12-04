create or replace function queryRicercaArea(id_Sessione int, nome varchar2, ruolo varchar2, autorimessa varchar2, veicolo varchar2) 
    return list_idaree is


    altezza_veicolo Veicoli.Altezza%TYPE;
    larghezza_veicolo Veicoli.Larghezza%TYPE;
    lunghezza_veicolo Veicoli.Lunghezza%TYPE;
    peso_veicolo Veicoli.Peso%TYPE;
    alimentazione_veicolo Veicoli.Alimentazione%TYPE;
    checkAlimentazione varchar2(1);
    produttore_veicolo Veicoli.Produttore%TYPE;
    modello_veicolo Veicoli.Modello%TYPE;
    headertab boolean := true;
    p list_idaree := list_idaree();
    total integer;
  begin
    
    --Ottengo dimensioni del veicolo--
    select Altezza, Larghezza, Lunghezza, Peso, Alimentazione, Modello, Produttore
    into altezza_veicolo, larghezza_veicolo, lunghezza_veicolo, peso_veicolo, alimentazione_veicolo, modello_veicolo, produttore_veicolo
    from Veicoli
    where Veicoli.idVeicolo = veicolo;

    if(alimentazione_veicolo = 'GPL') then
        checkAlimentazione := 'T';
    else
        checkAlimentazione := 'F';
    end if;
    
    --Ottengo le aree--
    for cur in (
        select idarea, lunghezzamax, larghezzamax, pesomax, altezzamax, gas
        from aree
        where aree.idautorimessa = autorimessa AND
          aree.lunghezzamax >= lunghezza_veicolo AND
          aree.altezzamax >= altezza_veicolo AND
          aree.larghezzamax >= larghezza_veicolo AND
          aree.pesomax >= peso_veicolo AND
          aree.gas = checkAlimentazione
    ) loop 
        p.extend;
        p(p.count) := cur.idarea;
    end loop;

    return p;



  end queryRicercaArea;
