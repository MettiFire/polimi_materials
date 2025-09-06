-- ESERCITAZIONE 6 --

-- Considerate il seguente schema:
SALA(NomeSala, Piano, Capienza, TelefonoSala , Videoproiettore)
EVENTO(IDEvento, NomeEvento, Descrizione, DataInizio, DataFine, NomeSala)
ORGANIZZATORE(CFOrganizzatore, Nome, Cognome, Ruolo, Telefono, Mail)
ORGANIZZA(IDEvento, CFOrganizzatore)

-- Nota: TelefonoSala e Videoproiettore contengono rispettivamente il 
-- numero di telefono (se presente) e l’indicazione della presenza di videoproiettore nella sala.

-- 1. Specificare in linguaggio SQL la creazione delle tabelle SALA, EVENTO e 
-- ORGANIZZA con vincoli di tupla, di dominio e di integrit`a referenziale.

CREATE TABLE SALA (
					NomeSala 		varchar(15) primary key,
					Piano 			integer not null, 
					Capienza 		integer not null,
					TelefonoSala 	varchar(14) unique,
					Videoproiettore bool default false not null
				   )

CREATE TABLE EVENTO (
					  IDEvento		integer primary key,
					  NomeEvento	varchar(30)
					  Descrizione	varchar(255)
					  DataInizio	date not null	
					  DataFine		date not null CHECK(DataInizio >= DataFine)
					  NomeSala		varchar(15) not null references Sala.NomeSala ON UPDATE	CASCADE
					  															  ON DELETE NO ACTION
					)

CREATE TABLE ORGANIZZA (
					  	 IDEvento			integer references Evento.IDEvento ON UPDATE CASCADE, ON DELETE NO ACTION
					     CFOrganizzatore	char(16) references organizzatore.CFOrganizzatore ON UPDATE CASCADE, ON DELETE NO ACTION
					     PRIMARY KEY (IDEvento, CFOrganizzatore)
					)



-- Considerate il seguente schema riguardo la gestione di una piscina:
VASCA (CodVasca, Profondità)
CORSO (CodCorso, Descrizione, Tipo, DataInizio, DataFine)
CALENDARIO (CodiceCorso, Vasca, Giorno, OraInizio, Insegnante, Durata)
PERSONA (CF, Nome, Cognome, Indirizzo, Città, Tel)
FREQUENZA (CodiceCorso, Vasca, Giorno, OraInizio, Cliente, DataDiIscrizione)
-- Il campo Tipo nella tabella CORSO specifica se il corso è “Monosettimanale” 
-- o “Bisettimanale”. Solitamente i corsi sono monosettimanali. 
-- La tabella PERSONA contiene i dati di clienti e insegnanti. 
-- La piscina apre alle 8.00 e chiude alle 20.00.

-- 2. Specificare in SQL la creazione delle tabelle CORSO e FREQUENZA, 
-- definendo i vincoli di tupla e di dominio ritenuti opportuni ed esprimendo eventuali vincoli di
-- integrità referenziale relativi a tutte le tabelle dello schema.

CREATE TABLE CORSO (
					 CodiceCorso 	char(5) primary key
					 Descrizione 	varchar(255) not null
					 Tipo			enum("monosettimanale", "bisettimanale") default "monosettimanale"
					 DataInizio		date not null
					 DataFine		date not null
					)

CREATE TABLE FREQUENZA (
						 CodiceCorso 		char(5)
						 CodVasca			varchar(5)
						 Giorno				date
						 OraInizio			time check(OraInizio between 8:00 and 20.00)
						 Cliente			char(16) references PERSONA.cf ON UPDATE CASCADE, ON DELETE NO ACTION 
						 DataDiIscrizione	date not null
						 PRIMARY KEY(CodiceCorso, Vasca, Giorno, OraInizio, Cliente)
						)



-- 3. Specificare in SQL il vincolo che controlla che la data di iscrizione non sia posteriore
-- alla data di fine del corso.
-- 4. Specificare in SQL il vincolo che controlla che in uno stesso giorno non ci siano più di
-- 50 persone che frequentano lezioni.