SELECT
	SPLETIVO.CODPERLET,
	SSTATUS.DESCRICAO,
	COUNT(DISTINCT(CONCAT(SMATRICPL.RA, SPLETIVO.IDPERLET, SMATRICPL.IDHABILITACAOFILIAL))) AS TOTAL

FROM
	SMATRICPL
	INNER JOIN SPLETIVO ON
			SPLETIVO.IDPERLET = SMATRICPL.IDPERLET
	INNER JOIN SSTATUS ON
			SSTATUS.CODSTATUS = SMATRICPL.CODSTATUS

WHERE 
	SPLETIVO.CODPERLET IN ('2019.1', '2019.2', '2020.1', '2020.2')
	AND SMATRICPL.CODSTATUS IN (5, 12, 101, 111)

GROUP BY
	SPLETIVO.CODPERLET,
	SSTATUS.DESCRICAO
