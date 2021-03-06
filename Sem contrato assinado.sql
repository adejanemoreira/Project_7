SELECT DISTINCT
	SMATRICPL.RA				[MATRICULA],
	UPPER(PPESSOA.NOME)			[ALUNO],
	SPLETIVO.CODPERLET			[PERIODO_LETIVO],
	SCURSO.NOME					[CURSO],
	S1.CODSTATUS				[CODSTATUS],
	S1.DESCRICAO				[STATUS],
	SCONTRATO.ASSINADO			[ASSINADO],
	SCONTRATO.DTCONTRATO		[DATA_CONTRATO],
	LOWER(PPESSOA.EMAIL)		[EMAIL],
	PPESSOA.TELEFONE2			[TELEFONE]

FROM
	SPLETIVO
	INNER JOIN SMATRICPL ON
			SMATRICPL.IDPERLET = SPLETIVO.IDPERLET
	INNER JOIN SMATRICULA ON
			SMATRICULA.RA = SMATRICPL.RA
		AND SMATRICULA.IDPERLET = SMATRICPL.IDPERLET
	INNER JOIN SHABILITACAOFILIAL ON
			SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SCONTRATO ON
			SCONTRATO.IDPERLET = SPLETIVO.IDPERLET
		AND SCONTRATO.RA = SMATRICPL.RA
		AND SCONTRATO.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL
	INNER JOIN SCURSO ON
			SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN SSTATUS S1 ON
			S1.CODSTATUS = SMATRICPL.CODSTATUS
	INNER JOIN SALUNO ON
			SALUNO.RA = SMATRICPL.RA
	INNER JOIN PPESSOA ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA

WHERE
		SPLETIVO.CODPERLET = '2021.2'
	AND S1.CODSTATUS IN (125, 101)
	AND SCONTRATO.ASSINADO = 'N'

ORDER BY
	[ALUNO]
