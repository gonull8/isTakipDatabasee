--sorunlar tablosu verileri �ekme 
SELECT *
FROM Sorunlar
inner join Oteller o on o.OtelID=Sorunlar.otelid


-- sorunlar tablosu veri ekleme 
INSERT INTO Sorunlar (
                          [IsletmePersonelAdi]
                          ,[Tel]
                          ,[Sorun]
                          ,[Cozum]
                          ,[SorunSaati]
                          ,[AtananPersonel]
                          ,[CozenPersonel]
                          ,[Departman]
						  ,[otelid])
VALUES ( 'ferhat', '0000000', 'uygul�ama a��lm�yor', 'internet ba�lant�s� olmad��� i�in program a��lm�yor', '15:00', 'bet�l', 'bet�l', 'rezervasyon',2);


--sorunlar tablosu update etme 
UPDATE Sorunlar
SET [IsletmePersonelAdi] = 'ferhat',
    [Tel] = '0000000',
    [Sorun] = 'uygul�ama a��lm�yo',
    [Cozum] = 'internet ba�lant�s� olmad��� i�in program a��lm�yor',
    [SorunSaati] = '15:00',
    [AtananPersonel] = 'bet�l',
    [CozenPersonel] = 'ferman',
    [Departman] = 'rezervasyon',
	[otelid]=3

WHERE [SorunID] = 2;


--sorunlar tablosu veri silme 
DELETE FROM Sorunlar
WHERE [SorunID] = 2;


-- oteller tablosu ile sorunlar tablosu inner join ile birle�tirilir [OtelAd]stununa g�re maya kelimesinmi arat�r  "SorunSaati" s�tununa g�re azalan �ekilde s�ralan�r 
SELECT *
FROM Sorunlar
INNER JOIN Oteller o ON o.OtelID = Sorunlar.otelid
WHERE o.[OtelAd] LIKE '%maya%'
ORDER BY Sorunlar.[SorunSaati] DESC;



--usteki sorguyu parametreli �ekilde proceduree yapt�k 
CREATE PROCEDURE Aranan_Hotel
    @arananhotel NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Sorunlar
    INNER JOIN Oteller o ON o.OtelID = Sorunlar.otelid
    WHERE o.[OtelAd] LIKE '%' + @otelAdKeyword + '%'
    ORDER BY Sorunlar.[SorunSaati] DESC;
END;

--kullan�m �ekli

EXEC Aranan_Hotel @arananhotel = 'maya';


--sorun eklmeyi procedure olarak parametre alarak ekleme yapt�k
CREATE PROCEDURE SorunEkle
    @sorunID INT,
    @isletmePersonelAdi NVARCHAR(50),
    @tel NVARCHAR(20),
    @sorun NVARCHAR(100),
    @cozum NVARCHAR(100),
    @sorunSaati NVARCHAR(10),
    @atananPersonel NVARCHAR(50),
    @cozenPersonel NVARCHAR(50),
    @departman NVARCHAR(50),
    @otelID INT
AS
BEGIN
    INSERT INTO Sorunlar ([SorunID]
                          ,[IsletmePersonelAdi]
                          ,[Tel]
                          ,[Sorun]
                          ,[Cozum]
                          ,[SorunSaati]
                          ,[AtananPersonel]
                          ,[CozenPersonel]
                          ,[Departman]
                          ,[otelid])
    VALUES (@sorunID, @isletmePersonelAdi, @tel, @sorun, @cozum, @sorunSaati, @atananPersonel, @cozenPersonel, @departman, @otelID);
END;

--kullan�m �ekli
EXEC SorunEkle @sorunID = 2,
                 @isletmePersonelAdi = 'ferhat',
                 @tel = '0000000',
                 @sorun = 'uygul�ama a��lm�yor',
                 @cozum = 'internet ba�lant�s� olmad��� i�in program a��lm�yor',
                 @sorunSaati = '15:00',
                 @atananPersonel = 'bet�l',
                 @cozenPersonel = 'bet�l',
                 @departman = 'rezervasyon',
                 @otelID = 2;



-- gelen departman ad�na g�re otel adlar�n� listeleye
CREATE FUNCTION departmana_gore_otel_listele(@departmentadi NVARCHAR(50))
RETURNS TABLE
AS
RETURN (
    SELECT o.OtelAd
    FROM Oteller o
    INNER JOIN sorunlar s ON s.OtelID = o.OtelID
    WHERE s.Departman = @departmentName
);
--fonksiyon kullan�m �ekli
SELECT *
FROM dbo.departmana_gore_otel_listele('rezervasyon');

--eklenecek olan kayd�n alan de�erlerini yakalar ve ard�ndan iste�e ba�l� olarak bu de�erleri kullanarak i�lemler yapabiliriz
CREATE TRIGGER tr_nsert_sorunlar
ON Sorunlar
FOR INSERT
AS
BEGIN
    DECLARE @SorunID INT, @IsletmePersonelAdi NVARCHAR(50), @Tel NVARCHAR(20), @Sorun NVARCHAR(MAX),
            @Cozum NVARCHAR(MAX), @SorunSaati TIME, @AtananPersonel NVARCHAR(50), @CozenPersonel NVARCHAR(50),
            @Departman NVARCHAR(50), @otelid INT;

    SELECT @SorunID = SorunID, @IsletmePersonelAdi = IsletmePersonelAdi, @Tel = Tel, @Sorun = Sorun,
           @Cozum = Cozum, @SorunSaati = SorunSaati, @AtananPersonel = AtananPersonel,
           @CozenPersonel = CozenPersonel, @Departman = Departman, @otelid = otelid
    FROM inserted;

    -- ��lem yapmak i�in trigger i�inde uygun kodlar� buraya ekleyin

    -- �rnek: Ekleme i�lemi yap�lan kayd�n bilgilerini ekrana yazd�ral�m
    PRINT 'Yeni kay�t eklendi. Sorun ID: ' + CAST(@SorunID AS NVARCHAR(10)) +
          ', ��letme Personel Ad�: ' + @IsletmePersonelAdi +
          ', Tel: ' + @Tel +
          ', Sorun: ' + @Sorun +
          ', ��z�m: ' + @Cozum +
          ', Sorun Saati: ' + CONVERT(NVARCHAR(8), @SorunSaati) +
          ', Atanan Personel: ' + @AtananPersonel +
          ', ��zen Personel: ' + @CozenPersonel +
          ', Departman: ' + @Departman +
          ', Otel ID: ' + CAST(@otelid AS NVARCHAR(10));
END;

--ornek olarak bu �ekilde bir insert gi�ri�i yapt��p�m�zda triggere tetikleni�cektir
INSERT INTO Sorunlar ([SorunID], [IsletmePersonelAdi], [Tel], [Sorun], [Cozum], [SorunSaati], [AtananPersonel], [CozenPersonel], [Departman], [otelid])
VALUES (2, 'ferhat', '0000000', 'uygul�ama a��lm�yor', 'internet ba�lant�s� olmad��� i�in program a��lm�yor', '15:00', 'bet�l', 'bet�l', 'rezervasyon', 2);
