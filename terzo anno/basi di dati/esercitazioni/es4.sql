-- ESERCITAZIONE 4 - BASI DI DATI - SQL --

UTENTE(Codice, Nome, Cognome, Indirizzo, Telefono)
PRESTITO(Collocazione, CodUtente, DataPrestito, DataResa)
COPIA(Collocazione, ISBN, DataAcquisizione, Costo)
DATILIBRO(ISBN, Titolo, AnnoPub, CasaEd, PrimoAut, Genere)

-- 1. Trovare tutti i titoli dei libri acquisiti nel 2010 in ordine alfabetico

SELECT 		Titolo
FROM  		DATILIBRO AS D, copia AS C
WHERE		D.ISBN = C.ISBN AND	C.DataAcquisizione >= 1/1/2010 AND C.Datac <= 31712/2010
ORDER BY	Titolo ASC --asc = ascendente 

-- 2. Trovare quanti prestiti sono stati effettuati

SELECT Count(*)
FROM PRESTITO

-- 3. Trovare quante copie sono state acquisite nel 2018 e quanto sono state pagate complessivamente (in migliaia di euro)

SELECT Count(*) AS TotCopie18, SUM(Costo)/1000 AS TotCosti
FROM Copia
WHERE DataAcquisizione BETWEEN 1/1/18 AND 31/12/2018


-- 4. Trovare quanti prestiti di libri di genere Giallo sono stati effettuati. Scrivere due query, una considerando i libri come copie fisiche una con i libri entità
SELECT count(*) AS Totprestiti
FROM prestito AS P, Copia AS C, DATILIBRO AS D
WHERE P.coll = C.coll  AND C.ISBN = D.ISBN AND D.genere = "giallo"

-- caso entità
SELECT count(distinct, C.ISBN) AS TotprestitiISBN
FROM prestito AS P, Copia AS C, DATILIBRO AS D
WHERE P.coll = C.coll  AND C.ISBN = D.ISBN AND D.genere = "giallo"

-- 5. Trovare quanti libri diversi sono stati acquisiti nel 2020

per casa 


-- 6. Trovare il libro pi`u costoso e con titolo che inizia per ’I’ acquisito dalla biblioteca

SELECT D1.titolo, C1.Collocazione, MAX(Costo)
FROM Copia AS C1
NATURAL JOIN Datalibro AS D1
WHERE D1.titolo LIKE "I%" AND D1.costo = (SELECT MAX(costo) FROM copia AS C2 NATURAL JOIN DATILIBRO AS D2 WHERE D2.titolo LIKE "I%")

-- 7. Trovare il primo libro acquisito dalla biblioteca
da fare 

-- 8. Trovare quanti prestiti ha fatto ogni utente. Aggiungere anche il Nome di questi utenti.	




-- 9. Trovare quanti diversi libri (isbn) ha preso ogni utente (se ne indichi anche il nome)


-- 10. Trovare quando `e stato pubblicato il libro giallo pi`u vecchio di ciascuna casa editrice che abbia pubblicato almeno 100 gialli diversi


-- 11. Trovare i libri che hanno almeno due copie che sono state acquisite il 01/05/2022 e il 01/06/2022


-- 12. Elencare tutti i nomi degli autori dei libri e degli utenti della biblioteca


--13. Elencare tutti i nomi degli autori dei libri che non sono anche nomi di utenti della biblioteca


-- 14. Trovare gli utenti che non hanno comunicato il numero di telefono quando si sono iscritti ma hanno inserito l’indirizzo di casa


-- 15. Trovare il numero di telefono degli utenti che hanno preso in prestito almeno un libro nel 2013.


-- 16. Trovare utenti che hanno preso in prestito libri di tutti i generi
















