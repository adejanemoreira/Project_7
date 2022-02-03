SELECT DISTINCT
	SCURSO.NOME											[CURSO], 
	SMODALIDADECURSO.DESCRICAO							[MODALIDADE],
	SDISCIPLINA.NOME									[DISCIPLINA],
	CASE
		WHEN SHABILITACAOFILIAL.CODTURNO = 1 THEN 'Manh�'
		WHEN SHABILITACAOFILIAL.CODTURNO = 3 THEN 'Noite'
	END													[TURNO],
	CONVERT(DECIMAL(10,2), AVG(SNOTAETAPA.NOTAFALTA))	[M�DIA DISCIPLINA],
	COUNT(SMATRICULA.RA)								[QTD DE ALUNOS],
	CONVERT(DECIMAL(10, 2), (CAST(SUM(CASE WHEN SMATRICULA.CODSTATUS = 4 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(SMATRICULA.RA))*100) AS [% REPROVA��O]

FROM SPLETIVO (NOLOCK)
	INNER JOIN SMATRICPL (NOLOCK) ON
			SMATRICPL.CODCOLIGADA = SPLETIVO.CODCOLIGADA
		AND SMATRICPL.CODFILIAL = SPLETIVO.CODFILIAL
		AND SMATRICPL.IDPERLET = SPLETIVO.IDPERLET
	INNER JOIN SMATRICULA (NOLOCK) ON
			SMATRICULA.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SMATRICULA.IDPERLET = SMATRICPL.IDPERLET
		AND SMATRICULA.RA = SMATRICPL.RA
	INNER JOIN STURMADISC (NOLOCK) ON
			STURMADISC.CODCOLIGADA = SMATRICULA.CODCOLIGADA
		AND STURMADISC.IDPERLET = SMATRICULA.IDPERLET
		AND STURMADISC.IDTURMADISC = SMATRICULA.IDTURMADISC
	INNER JOIN SDISCIPLINA (NOLOCK) ON
			SDISCIPLINA.CODCOLIGADA = STURMADISC.CODCOLIGADA
		AND SDISCIPLINA.CODDISC = STURMADISC.CODDISC
	INNER JOIN SNOTAETAPA (NOLOCK) ON
			SNOTAETAPA.CODCOLIGADA = SMATRICULA.CODCOLIGADA
		AND SNOTAETAPA.IDTURMADISC = SMATRICULA.IDTURMADISC
		AND SNOTAETAPA.RA = SMATRICULA.RA
	INNER JOIN SETAPAS (NOLOCK) ON
			SETAPAS.CODCOLIGADA = SNOTAETAPA.CODCOLIGADA
		AND SETAPAS.CODETAPA = SNOTAETAPA.CODETAPA
		AND SETAPAS.TIPOETAPA = SNOTAETAPA.TIPOETAPA
		AND SETAPAS.IDTURMADISC = SNOTAETAPA.IDTURMADISC
	INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON
			SHABILITACAOFILIAL.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	INNER JOIN SCURSO (NOLOCK) ON
			SCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
		AND SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
	INNER JOIN SMODALIDADECURSO (NOLOCK) ON
			SMODALIDADECURSO.CODCOLIGADA = SCURSO.CODCOLIGADA
		AND SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO
	INNER JOIN SALUNO (NOLOCK) ON
			SALUNO.CODCOLIGADA = SMATRICPL.CODCOLIGADA
		AND SALUNO.RA = SMATRICPL.RA
	INNER JOIN PPESSOA (NOLOCK) ON
			PPESSOA.CODIGO = SALUNO.CODPESSOA

WHERE SPLETIVO.CODPERLET = '2020.2'
	AND SCURSO.NOME = 'Engenharia Civil'
	AND SMATRICPL.CODSTATUS IN (5, 12, 101, 111)
	AND SPLETIVO.CODFILIAL = 1
	AND SNOTAETAPA.TIPOETAPA = 'N'
	AND SETAPAS.ETAPAFINAL = 'S'

GROUP BY SCURSO.NOME, SMODALIDADECURSO.DESCRICAO, SDISCIPLINA.NOME, SHABILITACAOFILIAL.CODTURNO
ORDER BY SCURSO.NOME, SDISCIPLINA.NOME
