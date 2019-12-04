create or replace PROCEDURE competentGarageSearch2 (
    id_Sessione varchar2, 
    nome varchar2, 
    ruolo varchar2,
	idSedeCorrente integer,
	idVeicoloCorrente integer
)   /*RETURN AREE%ROWTYPE*/
    AS

	tmp Aree%ROWTYPE;
    veicoloCorrente VEICOLI%ROWTYPE;
	SedeCorrente SEDI%ROWTYPE;
    p list_idaree := list_idaree();
    contatore integer :=0;
    vlunghezzamax integer   :=2147483648;
    vlarghezzamax integer   :=2147483648;
    valtezzamax integer     :=2147483648;
    vpesomax integer        :=2147483648;
    vid integer :=0;
    arid integer :=0;

	BEGIN
    if(idveicolocorrente=0) then
     modGUI.apriPagina('HoC | Veicolo non selezionato', id_Sessione, nome, ruolo);
        modGUI.aCapo;
        modGUI.apriDiv;
        modGUI.apriIntestazione(2);
        modGUI.inserisciTesto(' VEICOLO NON SELEZIONATO, SI PREGA DI AGGIUNGERE UN VEICOLO ');
        modGUI.chiudiIntestazione(2);
    else
            select * into veicoloCorrente from Veicoli where Veicoli.idVeicolo=idVeicoloCorrente;
            select * into sedeCorrente from Sedi sed where sed.idSede=idSedeCorrente;
        
            for autorimessa in (select * from Autorimesse)
            loop
                if(autorimessa.idSede = SedeCorrente.idsede )
                    then
                    p:=queryricercaArea(id_Sessione, nome, ruolo, autorimessa.idautorimessa,VeicoloCorrente.idveicolo); 
                    contatore:=p.count;
                    for i in 1 ..   contatore
                    loop
                        select * into tmp from Aree where idArea=p(i) and 
                                (
                                (lunghezzamax<vlunghezzamax or larghezzamax<=vlarghezzamax or altezzamax<=valtezzamax or pesomax<=vpesomax) or
                                (lunghezzamax<=vlunghezzamax or larghezzamax<vlarghezzamax or altezzamax<=valtezzamax or pesomax<=vpesomax) or
                                (lunghezzamax<=vlunghezzamax or larghezzamax<=vlarghezzamax or altezzamax<valtezzamax or pesomax<=vpesomax) or
                                (lunghezzamax<=vlunghezzamax or larghezzamax<=vlarghezzamax or altezzamax<=valtezzamax or pesomax<vpesomax)
                                );
                        if tmp.idarea is not null then
                        valtezzamax:=tmp.altezzamax;
                        vlunghezzamax:=tmp.lunghezzamax;
                        vpesomax:=tmp.pesomax;
                        vlarghezzamax:=tmp.larghezzamax;
                        vid:=tmp.idarea;
                            else null; end if;
        
        
        
                    end loop;
                else null;
                end if;
        
            end loop; 
                if(vid=0)then autorimessanontrovata(id_sessione,nome,ruolo);
                else
                    select aree.idautorimessa into arid from aree where aree.idarea=vid;
                        update debug
                        set numero=vid
                        where id=1;
        
                            visualizzaAutorimessa(id_Sessione, nome, ruolo,arid);
                end if;
        end if;

end competentGarageSearch2;