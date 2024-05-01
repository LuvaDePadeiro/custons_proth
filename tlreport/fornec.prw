#include "protheus.ch"



User Function fornec()
    Local oReport

    If FindFunction("TRepInUse") .And. TRepInUse() //relatorio personalizavel
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:= ReportDef() //Chama a função para carregar a Classe tReport
		oReport:PrintDialog()
	EndIf

Return

Static Function ReportDef()
    Local oReport := TReport():New("FORN101","Fornecedores mais usados","WMSA550",{|oReport|ReportPrint(oReport)})
    Local oSection1
    Local cPerg := "WMSA550"
    Local cAlias := "SA2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Status da Demanda ?                           ³
//³ mv_par02             // Documento De ?                          ³
//³ mv_par03             // Documento Até ?                      ³
//³ mv_par04             // Data De ?                             ³
//³ mv_par05             // Data Até ?                            ³
//³ mv_par06             // Produto Até ?                            ³
//³ mv_par07             // Fornecedor De ?                            ³
//³ mv_par08             // Fornecedor Até ?                            ³
//³ mv_par09             // Loja De ?                           ³
//³ mv_par10             // Loja Até ?                   ³
//³ mv_par11             // Armazém De ?                ³
//³ mv_par12             // Armazém Até ?  ³
//³ mv_par13             // Origem da Demanda ?              ³
//³ mv_par14             // Atualização Aut. Tela ?                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    Pergunte(cPerg,.f.)

    oReport:SetTitle("Fornecedores mais usados")
    oReport:lHeaderVisible := .T.
    oReport:lFooterVisible := .T.
    oReport:DisableOrientation() 
    oReport:SetLandscape()

    oSection1 := TRSection():New(oReport,"Fornecedores",{"SA2"})
    oSection1:SetTotalInLine(.F.)
    oSection1:SetNoFilter("SA2")

    TRCell():New(oSection1,'A2_FILIAL'	,cAlias	, "FILIAL")
    TRCell():New(oSection1,'A2_COD'	,cAlias	, "COD FORNC.")
    TRCell():New(oSection1,'A2_LOJA'	,cAlias	, "LOJA")
    TRCell():New(oSection1,'A2_NOME'	,cAlias	, "NOME")

    oSection1:SetHeaderPage()

Return (oReport)

Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1)
    Local cAlias := "SA2"
    Local cOrdem := "%A2_FILIAL,A2_COD,A2_LOJA%"

    oSection1:BeginQuery()

    MakeSqlExpr(oReport:uParam)

    BeginSql Alias cAlias

        SELECT SA2.A2_FILIAL,SA2.A2_COD,SA2.A2_LOJA,SA2.A2_NOME
        FROM %table:SA2% SA2
        

        //usar mv par pra pegar os fornecedores
        WHERE SA2.A2_COD >= %Exp:AllTrim(mv_par08)% AND SA2.A2_COD <=%Exp:AllTrim(mv_par09)% 

        ORDER BY %Exp:cOrdem%

    EndSql
    oSection1:EndQuery()
    oReport:SetMeter((cAlias)->(RecCount()))

    oSection1:EvalCell()
    oSection1:Print()

Return
