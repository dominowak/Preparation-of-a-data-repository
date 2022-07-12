--TABELE WYMIARÓW
--SELECT id_czas_pk, id_ladunek_pk, wartosc_zamowienia_EUR FROM [Import_Port_Gdansk].[dbo].[Arkusz1$]
-- LADUNEK
SELECT DISTINCT [id_ladunek_pk]
	,[id_jednostka_miary_ladunku_fk]
	,[nazwa_towaru]
	,[masa_ladunku]
	,[rodzaj_zmiennej_towaru]
	,[warunki_przewozu]
		INTO LADUNEK_GD
FROM[Baza_Import_Port_Gdansk].[dbo].[Arkusz1$]

-- JEDNOSTKI_MIARY_LADUNKU
	SELECT DISTINCT [id_jednostka_miary_ladunku_pk]
	,[nazwa_jednostki_miary]
	,[jednostka_miary_ladunku_symbol]
	,[opis_jednostki_miary]
	INTO JEDNOSTKA_MIARY_LADUNKU_GD
FROM[Baza_Import_Port_Gdansk].[dbo].[Arkusz1$]

-- KLIENT
SELECT DISTINCT [id_klient_pk]
	,[id_region_centrum_dystrybucji_fk]
	,[nazwa_firmy]
	,[numer_telefonu_centrali]
		INTO KLIENT_GD
FROM[Baza_Import_Port_Gdansk].[dbo].[Arkusz1$]

-- CENTRUM_DYSTRYBUCJI
SELECT DISTINCT [id_region_centrum_dystrybucji_pk]
      ,[region_centrum_dystrybucji]
      ,[wojewodztwo_centrum_dystrybucji]
      ,[numer_telefonu_oddzia³u]
		INTO CENTRUM_DYSTRYBUCJI_GD
FROM[Baza_Import_Port_Gdansk].[dbo].[Arkusz1$]

-- CZAS
	SELECT DISTINCT [id_czas_pk]
	,[dzien_tygodnia_zlozenia_zamowienia]
	,[dzien_tygodnia_zlozenia_zamowienia_nazwa]
	,[miesiac_zamowienia]
	,[miesiac_zamowienia_nazwa]
	,[rok_zlozenia_zamowienia]
	,[kwartal]
	,[kwartal_nazwa]
	INTO CZAS_GD
FROM[Baza_Import_Port_Gdansk].[dbo].[Arkusz1$]

-- LOKALIZACJA
	SELECT DISTINCT[id_miejsce_pk]
	,[id_przeladunek_fk]
	,[port_zaladunku]
	,[port_przeznaczenia]
	,[terminal_rozladunku]
		INTO LOKALIZACJA_GD
FROM[Baza_Import_Port_Gdansk].[dbo].[Arkusz1$]

-- PRZELADUNEK
		SELECT DISTINCT [id_przeladunek_pk]
      ,[srodek_transportu_przeladunek]
      ,[wystepowanie_systemu_intermodalnego]
	  ,[rodzaj_systemu_intermodalnego]
	  	INTO PRZELADUNEK_GD
FROM[Baza_Import_Port_Gdansk].[dbo].[Arkusz1$]

-- PARAMETRY_STATKU
	SELECT DISTINCT[id_parametry_statku_pk]
	,[typ_statku]
	,[armator_statku]
	,[rozmiar_statku_TEU]
	,[bandera_statku]
	,[numer_imo]
		INTO PARAMETRY_STATKU_GD
FROM[Baza_Import_Port_Gdansk].[dbo].[Arkusz1$]

--KLUCZE OBCE I G£ÓWNE
ALTER TABLE LADUNEK_GD ALTER COLUMN id_ladunek_pk FLOAT NOT NULL
GO
ALTER TABLE LADUNEK_GD ADD PRIMARY KEY (id_ladunek_pk)
GO

ALTER TABLE JEDNOSTKA_MIARY_LADUNKU_GD ALTER COLUMN id_jednostka_miary_ladunku_pk FLOAT NOT NULL
GO
ALTER TABLE JEDNOSTKA_MIARY_LADUNKU_GD ADD PRIMARY KEY (id_jednostka_miary_ladunku_pk)
GO

ALTER TABLE LADUNEK_GD ADD CONSTRAINT id_jednostka_miary_ladunku_fk FOREIGN KEY (id_jednostka_miary_ladunku_fk) REFERENCES JEDNOSTKA_MIARY_LADUNKU_GD(id_jednostka_miary_ladunku_pk)

ALTER TABLE KLIENT_GD ALTER COLUMN id_klient_pk FLOAT NOT NULL
GO
ALTER TABLE KLIENT_GD ADD PRIMARY KEY (id_klient_pk)
GO

ALTER TABLE CENTRUM_DYSTRYBUCJI_GD ALTER COLUMN id_region_centrum_dystrybucji_pk FLOAT NOT NULL
GO
ALTER TABLE CENTRUM_DYSTRYBUCJI_GD ADD PRIMARY KEY (id_region_centrum_dystrybucji_pk)
GO

ALTER TABLE KLIENT_GD ADD CONSTRAINT id_region_centrum_dystrybucji_fk FOREIGN KEY (id_region_centrum_dystrybucji_fk) REFERENCES CENTRUM_DYSTRYBUCJI_GD(id_region_centrum_dystrybucji_pk)

ALTER TABLE CZAS_GD ALTER COLUMN id_czas_pk FLOAT NOT NULL
GO
ALTER TABLE CZAS_GD ADD PRIMARY KEY (id_czas_pk)
GO

ALTER TABLE LOKALIZACJA_GD ALTER COLUMN id_miejsce_pk FLOAT NOT NULL
GO
ALTER TABLE LOKALIZACJA_GD ADD PRIMARY KEY (id_miejsce_pk)
GO

ALTER TABLE PRZELADUNEK_GD ALTER COLUMN id_przeladunek_pk FLOAT NOT NULL
GO
ALTER TABLE PRZELADUNEK_GD ADD PRIMARY KEY (id_przeladunek_pk)
GO

ALTER TABLE LOKALIZACJA_GD ADD CONSTRAINT id_ladunek_przeladunek_fk FOREIGN KEY (id_przeladunek_fk) REFERENCES PRZELADUNEK_GD(id_przeladunek_pk)

ALTER TABLE PARAMETRY_STATKU_GD ALTER COLUMN id_parametry_statku_pk FLOAT NOT NULL
GO
ALTER TABLE PARAMETRY_STATKU_GD ADD PRIMARY KEY (id_parametry_statku_pk)
GO

-- TABELA FAKTÓW
CREATE TABLE TFAKT_GD (
id_ladunek_fk FLOAT FOREIGN KEY (id_ladunek_fk) REFERENCES LADUNEK_GD (id_ladunek_pk),
id_klient_fk FLOAT FOREIGN KEY (id_klient_fk) REFERENCES KLIENT_GD (id_klient_pk),
id_czas_fk FLOAT FOREIGN KEY (id_czas_fk) REFERENCES CZAS_GD (id_czas_pk),
id_miejsce_fk FLOAT FOREIGN KEY (id_miejsce_fk) REFERENCES LOKALIZACJA_GD (id_miejsce_pk),
id_parametry_statku_fk FLOAT FOREIGN KEY (id_parametry_statku_fk) REFERENCES PARAMETRY_STATKU_GD (id_parametry_statku_pk), wartosc_zamowienia_EUR FLOAT, liczba_jednostek FLOAT)

-- IMPORTOWANIE DANYCH DO TFAKT_GD
INSERT INTO TFAKT_GD
SELECT [id_ladunek_fk]
,[id_klient_fk]
,[id_czas_fk]
,[id_miejsce_fk]
,[id_parametry_statku_fk]
,[wartosc_zamowienia_EUR]
,[liczba_jednostek]
FROM[Baza_Import_Port_Gdansk].[dbo].[Arkusz1$]