DECLARE @IDTURMADISC INT = (
    SELECT
        IDTURMADISC
    FROM 
        SESTAGIOCONTRATO
    WHERE
            IDPERLET = 167
        AND IDHABILITACAOFILIAL = 117		
        AND CODCOLIGADA = 1				
        AND RA = '2019110084'			
	)


DECLARE @ESTAGIOOBRIGATORIO VARCHAR(5) = (
    SELECT
        ESTAGIOOBRIGATORIO
    FROM 
        SESTAGIOCONTRATO
    WHERE
            IDPERLET = 167
        AND IDHABILITACAOFILIAL = 117		
        AND CODCOLIGADA = 1				
        AND RA = '2019110084'			
	)


DECLARE @CATEGORIA INT = (
    SELECT
        CATEGORIA
    FROM 
        SESTAGIOCONTRATO
        INNER JOIN SEMPRESA ON
                SEMPRESA.IDEMPRESA = SESTAGIOCONTRATO.IDEMPRESA
    WHERE
            SESTAGIOCONTRATO.IDPERLET = 167
        AND SESTAGIOCONTRATO.IDHABILITACAOFILIAL = 117		
        AND SESTAGIOCONTRATO.CODCOLIGADA = 1				
        AND SESTAGIOCONTRATO.RA = '2019110084'				
	)	


SELECT
	*
INTO 
	#CONSULTA1
FROM (
    SELECT
        SEMPRESA.NOME				[NOME_EMPRESA],				
        SEMPRESA.NOMEFANTASIA		[NOMEFANTASIA_EMPRESA],		
        FUNCIONARIOS.CARTIDENTIDADE,
        FUNCIONARIOS.UFCARTIDENT,
        SEMPRESA.CEP				[CEP_EMPRESA],
        SEMPRESA.RUA				[RUA_EMPRESA],	
        SEMPRESA.NUMERO				[NUMERO_EMPRESA],
        SEMPRESA.BAIRRO				[BAIRRO_EMPRESA],
        GMUNICIPIO.NOMEMUNICIPIO	[MUNICIPIO_EMPRESA],
        GMUNICIPIO.CODETDMUNICIPIO	[ESTADO_EMPRESA],
        SEMPRESA.CNPJ,
        SUPERVISOR.NOME				[SUPERVISOR],
        FUNCIONARIOS.NOME			[RESPONSAVEL],
        SUPERVISOR.CPF				[CPF_SUPERVISOR],
        SUPERVISOR.TELEFONE			[TEL_SUPERVISOR],
        SUPERVISOR.EMAIL			[EMAIL_SUPERVISOR],
        SUPERVISOR.CARGO			[CARGO_SUPERVISOR],
        SESTAGIOCONTRATO.IDESTAGIOCONTRATO	[IDESTAGIOCONTRATO_EMPRESA]

    FROM
        SESTAGIOCONTRATO (NOLOCK) 
        INNER JOIN SPLETIVO (NOLOCK) ON
                SPLETIVO.IDPERLET = SESTAGIOCONTRATO.IDPERLET
        INNER JOIN SMATRICPL (NOLOCK) ON
                SMATRICPL.RA = SESTAGIOCONTRATO.RA
            AND SMATRICPL.CODCOLIGADA = SESTAGIOCONTRATO.CODCOLIGADA
            AND SMATRICPL.IDHABILITACAOFILIAL = SESTAGIOCONTRATO.IDHABILITACAOFILIAL
            AND SMATRICPL.IDPERLET = SESTAGIOCONTRATO.IDPERLET
        INNER JOIN SEMPRESA (NOLOCK) ON
                SEMPRESA.IDEMPRESA = SESTAGIOCONTRATO.IDEMPRESA
        INNER JOIN SEMPRESAFUNCIONARIO SUPERVISOR (NOLOCK) ON
                SUPERVISOR.IDFUNCIONARIO = SESTAGIOCONTRATO.IDFUNCIONARIO
        LEFT JOIN SEMPRESAFUNCIONARIO FUNCIONARIOS (NOLOCK) ON
                FUNCIONARIOS.IDEMPRESA = SUPERVISOR.IDEMPRESA
            AND FUNCIONARIOS.FUNCAO IN (3, 4)
        INNER JOIN GMUNICIPIO (NOLOCK) ON
                GMUNICIPIO.CODMUNICIPIO = SEMPRESA.CODMUNICIPIO
            AND GMUNICIPIO.CODETDMUNICIPIO = SEMPRESA.ESTADO

    WHERE
            SESTAGIOCONTRATO.IDPERLET = 167
        AND SESTAGIOCONTRATO.IDHABILITACAOFILIAL = 117		
        AND SESTAGIOCONTRATO.CODCOLIGADA = 1				
        AND SESTAGIOCONTRATO.RA = '2019110084'			
    ) AS DADOS_EMPRESA


/* Est??gio OBRIGAT??RIO com EMPRESA */
IF ((@IDTURMADISC IS NULL) AND (@ESTAGIOOBRIGATORIO = 'N' OR @ESTAGIOOBRIGATORIO IS NULL))
    SELECT
        'CONV??NIO'
        AS TITULO,

        'Conv??nio que celebram entre si o Educacional Fi??sa S/S Ltda, CNPJ n?? 04.242.942/0001-37, na qualidade de mantenedor do CENTRO UNIVERSIT??RIO PARA??SO, institui????o de ensino superior, com sede ?? Rua S??o Benedito, 344 ??? S??o Miguel ??? Juazeiro do Norte, CEP 63010-220, Estado do Cear??, doravante denominado CENTRO UNIVERSIT??RIO PARA??SO e ' + #CONSULTA1.NOME_EMPRESA + ' CNPJ n?? ' + #CONSULTA1.CNPJ + ', localizada a ' + #CONSULTA1.RUA_EMPRESA + ', ' + #CONSULTA1.NUMERO_EMPRESA + ', ' + #CONSULTA1.BAIRRO_EMPRESA + ', ' + #CONSULTA1.MUNICIPIO_EMPRESA + ', ' + #CONSULTA1.ESTADO_EMPRESA + ', doravante denominada EMPRESA com o fim de colaborarem, reciprocamente, no planejamento, execu????o e avalia????o dos Est??gios N??o-Obrigat??rios, conforme o que determina a Lei n?? 11.788, de 25/09/2008.'
        AS PREINTRO,

        'O CENTRO UNIVERT??RIO PARA??SO, doravante denominada CENTRO UNIVERSIT??RIO, neste ato representada por seu Reitor, Jo??o Luis Alexandre Fi??sa e ' + #CONSULTA1.NOME_EMPRESA + ' doravante denominada EMPRESA, neste ato representada por Sr.(a) ' + #CONSULTA1.RESPONSAVEL + ' t??m justo e acertado o consubstanciado nas seguintes cl??usulas:'
        AS INTRO,

        'CL??USULA 1?? - DO OBJETIVO DO CONV??NIO'
        AS TITULO1,
        'O presente conv??nio objetiva estabelecer as condi????es para a realiza????o dos est??gios n??o-obrigat??rios, observando o preceituado na Lei n?? 11.788, de 25/09/2008.'
        AS CLAUSULA1,

        'CL??USULA 2?? - DA NATUREZA DO EST??GIO N??O-OBRIGAT??RIO'
        AS TITULO2,
        'I ??? designar supervisor de est??gio que dever?? ter forma????o ou experi??ncia na ??rea de atua????o do ESTAGI??RIO (A), respeitando o limite de supervis??o de at?? 10(dez) estagi??rios simultaneamente;' + CHAR(10) +
        'II ??? proceder, a qualquer momento, mediante a indica????o explicita das raz??es, o desligamento ou substitui????o do (a) ESTAGI??RIO (A), dando ci??ncia por escrito da ocorr??ncia ao coordenador de est??gio do CENTRO UNIVERSIT??RIO PARA??SO;' + CHAR(10) +
        'III - possibilitar o acesso do(a) professor(a) orientador(a) pelo CENTRO UNIVERSIT??RIO PARA??SO que visitar?? o local de est??gio quando necess??rio;' + CHAR(10) +
        'IV ??? A empresa conceder?? bolsa-aux??lio no valor de R$ ' + #CONSULTA1.VLRBOLSA + ' e R$ ' + #CONSULTA1.VLRBENEFICIOS + ' referente ao aux??lio transporte.' + CHAR(10) +
        'V ??? O seguro contra acidentes pessoais em favor do estagi??rio foi realizado pela Seguradora ' + #CONSULTA1.NOMECIASEGUROS + ', cuja ap??lice ?? de n?? ' + #CONSULTA1.NRAPOLICE + '.' + CHAR(10) +
        'VI ??? Reduzir a carga hor??ria do est??gio pelo menos ?? metade, no per??odo de avalia????es calendarizadas pela FACULDADE PARA??SO, mediante comprova????o atrav??s do Calend??rio Acad??mico;' + CHAR(10) +
        'VII ??? Assegurar ao estagi??rio, per??odo de recesso remunerado de 30(trinta) dias, a ser gozado, preferencialmente, nos meses de janeiro ou julho, sempre que o est??gio tenha dura????o igual ou superior a 1(um) ano.'
        AS CLAUSULA2,

        'CL??USULA 3?? - DA FINALIDADE DO EST??GIO N??O-OBRIGAT??RIO'
        AS TITULO3,
        'I - Preparar, em n??vel preliminar, os (as) universit??rios (as) para o est??gio;' + CHAR(10) +
        'II - Designar, como professor(a) orientador(a) o (a) Prof (a). ' + #CONSULTA1.ORIENTADOR + ' a quem caber?? acompanhamento, orienta????o e avalia????o do (a) ESTAGI??RIO (A), bem como poder?? visitar a EMPRESA conforme item III da Cl??usula 2??;' + CHAR(10) +
        'III - Manter atualizadas as informa????es cadastrais relativas ao Estagi??rio;' 
        AS CLAUSULA3,

        'CL??USULA 4?? - DAS COMPET??NCIAS DO CENTRO UNIVERSIT??RIO'
        AS TITULO4,
        'I - estagiar durante 24 (vinte e quatro) meses, no m??ximo, num total de at?? 30 (trinta) horas semanais, sendo 6(seis) horas di??rias;' + CHAR(10) +
        'II - realizar as tarefas previstas no seu Plano de Est??gio e, na impossibilidade eventual do cumprimento de algum item dessa programa????o, comunicar por escrito ao Supervisor(a) da EMPRESA, para fins de aprova????o ou n??o;' + CHAR(10) +
        'III - cumprir as normas da EMPRESA, principalmente as relativas ao est??gio, que o ESTAGI??RIO(A) declara expressamente conhecer;' + CHAR(10) +
        'IV - responder por perdas e danos consequentes da inobserv??ncia das normas internas, ou das constantes neste Termo de Compromisso seja por dolo ou culpa;' + CHAR(10) +
        'V - seguir a orienta????o do(a) supervisor(a) da EMPRESA e do(a) professor(a) orientador(a) designado pelo CENTRO UNIVERSIT??RIO PARA??SO;' + CHAR(10) +
        'VI - apresentar os relat??rios que lhe forem solicitados pela EMPRESA e pelo CENTRO UNIVERSIT??RIO PARA??SO.' + CHAR(10) +
        'VII - cumprir a carga hor??ria total de ' + #CONSULTA1.CHSEMANAL + ' horas, realizando o est??gio no hor??rio de ' + #CONSULTA1.HRINICIO + ' horas ??s ' + #CONSULTA1.HRFIM + ' horas, tendo como supervisor de est??gio o Sr.(a) ' + #CONSULTA1.SUPERVISOR + ';' + CHAR(10) +
        'VIII - realizar as seguintes atividades: ' + #CONSULTA1.OBJETIVO + ';' + CHAR(10) +
        'IX - cumprir o est??gio com vig??ncia de ' + #CONSULTA1.DTINICIOESTAGIO + ' ?? ' + #CONSULTA1.DTFINALESTAGIO + '.'
        AS CLAUSULA4,

        'CL??USULA 5?? - DAS COMPET??NCIAS DA EMPRESA'
        AS TITULO5,
        'I - o(a) ESTAGI??RIO(A) n??o ter??, para quaisquer efeitos, v??nculo empregat??cio com a EMPRESA, conforme o artigo 3?? da Lei n?? 11.788, de 25/09/2008.' + CHAR(10) +
        'Par??grafo ??nico. E por estarem concordes, as partes signat??rias deste instrumento elegem o foro do munic??pio de Juazeiro do Norte (CE) para dirimir eventuais pend??ncias e subscrevem-no em tr??s vias de igual teor, ficando uma via sob a guarda do ESTAGI??RIO (A), outra com a EMPRESA e outra com o CENTRO UNIVERSIT??RIO PARA??SO.'
        AS CLAUSULA5,

        'CL??USULA 6?? ??? DO DESLIGAMENTO OU SUBSTITUI????O DO ESTAGI??RIO'
        AS TITULO6,
        NULL
        AS CLAUSULA6,

        'CL??USULA 7?? ??? DA VIG??NCIA'
        AS TITULO7,
        NULL
        AS CLAUSULA7,

        'CL??USULA 8?? ??? DA RESCIS??O'
        AS TITULO8,
        NULL
        AS CLAUSULA8,

        NULL AS TITULO9,
        NULL AS CLAUSULA9
FROM #CONSULTA1

/* Est??gio OBRIGAT??RIO com PROFISSIONAL LIBERAL */
ELSE IF ((@IDTURMADISC IS NOT NULL) AND (@ESTAGIOOBRIGATORIO = 'S') AND (@CATEGORIA = 5))
    SELECT
        'CONV??NIO'
        AS TITULO,

        'Termo de conv??nio que entre si celebram, de um lado, o CENTRO UNIVERSIT??RIO PARA??SO, e de outro lado, ' + #CONSULTA1.NOME_EMPRESA + ', visando ?? realiza????o de est??gio.'
        AS PREINTRO,

        'O CENTRO UNIVERSIT??RIO PARA??SO, doravante denominada CENTRO UNIVERSIT??RIO PARA??SO, Institui????o de Ensino Superior Privada, mantida por Fi??sa Educacional S/Simples Ltda., regularmente inscrita no CNPJ/MF sob o n?? 04.242.942/0001-37, com sede ?? Rua S??o Benedito, 344, CEP 63010-220, Bairro S??o Miguel, em Juazeiro do Norte (CE), neste ato representada pelo seu Reitor, Professor Jo??o Luis Alexandre Fi??sa, e ' + #CONSULTA1.NOME_EMPRESA + ', doravante denominada(o) CONCEDENTE, pessoa f??sica com n?? de Registro  Profissional sob o n??mero ' + #CONSULTA1.CNPJ + ', portador(a) da c??dula de identidade n?? ' + #CONSULTA1.CARTIDENTIDADE + ', SSP/' + #CONSULTA1.UFCARTIDENT + ', inscrita(o) no CPF sob o n?? ' + #CONSULTA1.CPF_SUPERVISOR + ', residente ?? Rua ' + #CONSULTA1.RUA_EMPRESA + ', n?? ' + #CONSULTA1.NUMERO_EMPRESA + ', Bairro ' + #CONSULTA1.BAIRRO_EMPRESA + ', CEP ' + #CONSULTA1.CEP_EMPRESA + ', na cidade de ' + #CONSULTA1.MUNICIPIO_EMPRESA + ' ??? ' + #CONSULTA1.ESTADO_EMPRESA + ', resolvem celebrar o presente conv??nio, que ser?? regido pela Lei n?? 11.788, de 25/09/08, mediante as seguintes cl??usulas e condi????es:'
        AS INTRO,

        'CL??USULA 1?? - DO OBJETO, DA CLASSIFICA????O E DAS RELA????ES DE EST??GIO'
        AS TITULO1,
        '1.1.   O presente conv??nio tem por objetivo regular as rela????es entre as partes ora conveniadas no que tange ?? concess??o de est??gio curricular supervisionado para estudantes regularmente matriculados e que venham frequentando efetivamente cursos oferecidos pelo CENTRO UNIVERSIT??RIO PARA??SO, nos termos da Lei n?? 11.788, de 25 de setembro de 2008.' + CHAR(10) +
        '1.2.   Para os fins deste conv??nio, entende-se como est??gio as atividades proporcionadas ao aluno de gradua????o, em situa????es reais da profiss??o e do trabalho, ligadas ?? sua ??rea de forma????o no CENTRO UNIVERSIT??RIO PARA??SO e previstas no Projeto Pedag??gico do Curso.' + CHAR(10) +
        '1.3.   O est??gio obrigat??rio n??o cria v??nculo empregat??cio de qualquer natureza.'
        AS CLAUSULA1,

        'CL??USULA 2?? - DAS COMPET??NCIAS DO CENTRO UNIVERSIT??RIO PARA??SO'
        AS TITULO2,
        '2.1.   Celebrar, atrav??s da Coordenadoria de Est??gios/Coordenadoria de Gradua????o dos Cursos, Termo de Compromisso de Est??gio com a parte CONCEDENTE e o aluno.' + CHAR(10) +
        '2.2.   Avaliar as instala????es da parte CONCEDENTE e a sua adequa????o ?? forma????o cultural e profissional do aluno.' + CHAR(10) +
        '2.3.   Indicar um professor orientador da ??rea a ser desenvolvida no est??gio como respons??vel pelo acompanhamento e avalia????o das atividades do estagi??rio.' + CHAR(10) +
        '2.4.   Exigir do estagi??rio, em prazo n??o superior a um semestre acad??mico, relat??rio de atividades conforme estabelecido no termo de compromisso e nas normas do curso. O relat??rio deve ser entregue pelo aluno ao Coordenador de Est??gios do curso devidamente assinado pelas partes envolvidas;' + CHAR(10) +
        '2.5.	Elaborar normas complementares e instrumentos de avalia????o dos est??gios dos seus educandos;' + CHAR(10) +
        '2.6.	Informar, atrav??s de declara????o subscrita pelo professor da disciplina, mediante solicita????o do aluno, as datas de avalia????es escolares ou acad??micas para fins de redu????o da carga hor??ria de est??gio no per??odo;' + CHAR(10) +
        '2.7.	Zelar pelo cumprimento do Termo de Compromisso de Est??gio, reorientando o estagi??rio para outro local em caso de descumprimento de suas cl??usulas por parte da CONCEDENTE.' + CHAR(10) +
        '2.8.	Comunicar ?? CONCEDENTE os casos de conclus??o ou abandono de curso, cancelamento ou trancamento da matr??cula.' + CHAR(10) +
        '2.9.	Efetuar, mensalmente, o pagamento do seguro contra acidentes pessoais para o aluno em est??gio obrigat??rio.'
        AS CLAUSULA2,

        'CL??USULA 3?? ??? DAS OBRIGA????ES DA CONCEDENTE'
        AS TITULO3,
        'Compete ?? CONCEDENTE:' + CHAR(10) +
        '3.1.   Conceder est??gios ao corpo discente do CENTRO UNIVERSIT??RIO PARA??SO, observadas a legisla????o vigente e as disposi????es deste conv??nio.' + CHAR(10) +
        '3.2.	Comunicar ao CENTRO UNIVERSIT??RIO PARA??SO o n??mero de vagas de est??gio dispon??veis por curso/??rea de forma????o, para a devida divulga????o e encaminhamento de alunos.' + CHAR(10) +
        '3.3.	Selecionar os estagi??rios dentre os alunos encaminhados pelo CENTRO UNIVERSIT??RIO PARA??SO.' + CHAR(10) +
        '3.4.	Celebrar Termo de Compromisso de Est??gio com o CENTRO UNIVERSIT??RIO PARA??SO e com o aluno, zelando pelo seu cumprimento.' + CHAR(10) +
        '3.5.	Ofertar instala????es que tenham condi????es de proporcionar ao educando atividades de aprendizagem social, profissional e cultural, observando o estabelecido na legisla????o relacionada ?? sa??de e seguran??a no trabalho.' + CHAR(10) +
        '3.6.	Indicar um funcion??rio de seu quadro de pessoal, com forma????o ou experi??ncia profissional na ??rea de conhecimento desenvolvida no curso do estagi??rio, para orientar e supervisionar as atividades desenvolvidas pelo estagi??rio. ' + CHAR(10) +
        '3.7.	Zelar para que a carga hor??ria m??xima do estagi??rio corresponda a, no m??ximo, 6 horas di??rias e 30 horas semanais.' + CHAR(10) +
        '3.8.	Assegurar ao estagi??rio, sempre que o est??gio tenha a dura????o igual ou superior a 1 (um) ano, o per??odo de recesso de 30 (trinta) dias, a ser gozado preferencialmente no per??odo de f??rias escolares.' + CHAR(10) +
        '3.9.	Encaminhar, por ocasi??o do desligamento do estagi??rio, o termo de realiza????o de est??gio ao Coordenador de Est??gio/de gradua????o do curso, com a indica????o resumida das atividades desenvolvidas, dos per??odos e da avalia????o de desempenho.  ' + CHAR(10) +
        '3.10.	Informar ao CENTRO UNIVERSIT??RIO PARA??SO sobre a frequ??ncia e o desempenho dos estagi??rios, observadas as exig??ncias de cada curso, quando for o caso.' + CHAR(10) +
        '3.11.	Indicar CENTRO UNIVERSIT??RIO PARA??SO, para ser substitu??do, o estagi??rio que, por motivo de natureza t??cnica, administrativa ou disciplinar, n??o for considerado apto a continuar suas atividades de est??gio.'
        AS CLAUSULA3,

        'CL??USULA 4?? ??? DAS COMPET??NCIAS DO ESTAGI??RIO'
        AS TITULO4,
        '4.1.   Cumprir o que for proposto no plano de est??gio, em conformidade com o professor orientador e supervisor de est??gio.' + CHAR(10) +
        '4.2.   Zelar pelos equipamentos, materiais e documentos da empresa.' + CHAR(10) +
        '4.3.   Manter sigilo sobre informa????es escritas ou verbais da empresa, adotando postura ??tica profissional.'
        AS CLAUSULA4,

        'CL??USULA 5?? ??? DO DESLIGAMENTO OU SUBSTITUI????O DE EST??GIO'
        AS TITULO5,
        'A concedente poder?? solicitar, a qualquer momento, o desligamento e/ou a substitui????o de estagi??rios nos casos previstos pela legisla????o vigente, dando ci??ncia ?? CENTRO UNIVERSIT??RIO PARA??SO, bem como a pr??pria I.E.S ou o pr??prio estagi??rio requerer o desligamento.'
        AS CLAUSULA5,

        'CL??USULA 6?? ??? DA VIG??NCIA'
        AS TITULO6,
        'O presente conv??nio ter?? vig??ncia de 02 anos (dois anos), a partir da data de sua assinatura, podendo ser prorrogado automaticamente, a cada ano, se nenhuma das partes se pronunciarem em contr??rio, at?? 30 (trinta) dias antes do t??rmino.'
        AS CLAUSULA6,

        'CL??USULA 7?? ???  DA RESCIS??O'
        AS TITULO7,
        'Este conv??nio poder?? ser denunciado por qualquer das partes a qualquer tempo, mediante correspond??ncia que anteceder?? 30 (trinta) dias, no m??nimo, ?? vig??ncia da cessa????o do presente pacto, indicando as raz??es da den??ncia.' + CHAR(10) +
        'E por estarem concordes, as partes signat??rias deste instrumento elegem o foro da cidade de Juazeiro do Norte (CE) para dirimir eventuais pend??ncias e subscrevem-se em duas vias de igual teor e forma.'
        AS CLAUSULA7,

        NULL
        AS TITULO8,
        NULL
        AS CLAUSULA8,

        NULL
        AS TITULO9,
        NULL
        AS CLAUSULA9
FROM #CONSULTA1

/* Est??gio N??O-OBRIGAT??RIO */
ELSE IF ((@IDTURMADISC IS NOT NULL) AND (@ESTAGIOOBRIGATORIO = 'S') AND (@CATEGORIA <> 5))
SELECT
	'CONV??NIO'
	AS TITULO,

    ''
    AS PREINTRO,

	''
	AS INTRO,

	'CL??USULA 1?? ??? DOS OBJETIVOS DO EST??GIO CURRICULAR SUPERVISIONADO'
	AS TITULO1,
	''
	AS CLAUSULA1,

	'CL??USULA 2?? ??? DAS COMPET??NCIAS DA EMPRESA'
	AS TITULO2,
	''
	AS CLAUSULA2,

	'CL??USULA 3?? ??? DAS COMPET??NCIAS DO CENTRO UNIVERSIT??RIO'
	AS TITULO3,
	''
	AS CLAUSULA3,

	'CL??USULA 4?? - DAS COMPET??NCIAS DO(A) ESTAGI??RIO(A)'
	AS TITULO4,
	''
	AS CLAUSULA4,

	'CL??USULA 5?? ??? DAS DISPOSI????ES GERAIS'
	AS TITULO5,
	''
	AS CLAUSULA5,

	NULL AS TITULO6,
	NULL AS CLAUSULA6,

	NULL AS TITULO7,
	NULL AS CLAUSULA7,

	NULL AS TITULO8,
	NULL AS CLAUSULA8,

	NULL AS TITULO9,
	NULL AS CLAUSULA9
FROM #CONSULTA1