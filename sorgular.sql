--sorunlar tablosu verileri çekme 
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
VALUES ( 'ferhat', '0000000', 'uygulþama açýlmýyor', 'internet baðlantýsý olmadýðý için program açýlmýyor', '15:00', 'betül', 'betül', 'rezervasyon',2);


--sorunlar tablosu update etme 
UPDATE Sorunlar
SET [IsletmePersonelAdi] = 'ferhat',
    [Tel] = '0000000',
    [Sorun] = 'uygulþama açýlmýyo',
    [Cozum] = 'internet baðlantýsý olmadýðý için program açýlmýyor',
    [SorunSaati] = '15:00',
    [AtananPersonel] = 'betül',
    [CozenPersonel] = 'ferman',
    [Departman] = 'rezervasyon',
	[otelid]=3

WHERE [SorunID] = 2;


--sorunlar tablosu veri silme 
DELETE FROM Sorunlar
WHERE [SorunID] = 2;


-- oteller tablosu ile sorunlar tablosu inner join ile birleþtirilir [OtelAd]stununa göre maya kelimesinmi aratýr  "SorunSaati" sütununa göre azalan þekilde sýralanýr 
SELECT *
FROM Sorunlar
INNER JOIN Oteller o ON o.OtelID = Sorunlar.otelid
WHERE o.[OtelAd] LIKE '%maya%'
ORDER BY Sorunlar.[SorunSaati] DESC;



--usteki sorguyu parametreli þekilde proceduree yaptýk 
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

--kullaným þekli

EXEC Aranan_Hotel @arananhotel = 'maya';


--sorun eklmeyi procedure olarak parametre alarak ekleme yaptýk
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

--kullaným þekli
EXEC SorunEkle @sorunID = 2,
                 @isletmePersonelAdi = 'ferhat',
                 @tel = '0000000',
                 @sorun = 'uygulþama açýlmýyor',
                 @cozum = 'internet baðlantýsý olmadýðý için program açýlmýyor',
                 @sorunSaati = '15:00',
                 @atananPersonel = 'betül',
                 @cozenPersonel = 'betül',
                 @departman = 'rezervasyon',
                 @otelID = 2;



-- gelen departman adýna göre otel adlarýný listeleye
CREATE FUNCTION departmana_gore_otel_listele(@departmentadi NVARCHAR(50))
RETURNS TABLE
AS
RETURN (
    SELECT o.OtelAd
    FROM Oteller o
    INNER JOIN sorunlar s ON s.OtelID = o.OtelID
    WHERE s.Departman = @departmentName
);
--fonksiyon kullaným þekli
SELECT *
FROM dbo.departmana_gore_otel_listele('rezervasyon');

--eklenecek olan kaydýn alan deðerlerini yakalar ve ardýndan isteðe baðlý olarak bu deðerleri kullanarak iþlemler yapabiliriz
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

    -- Ýþlem yapmak için trigger içinde uygun kodlarý buraya ekleyin

    -- Örnek: Ekleme iþlemi yapýlan kaydýn bilgilerini ekrana yazdýralým
    PRINT 'Yeni kayýt eklendi. Sorun ID: ' + CAST(@SorunID AS NVARCHAR(10)) +
          ', Ýþletme Personel Adý: ' + @IsletmePersonelAdi +
          ', Tel: ' + @Tel +
          ', Sorun: ' + @Sorun +
          ', Çözüm: ' + @Cozum +
          ', Sorun Saati: ' + CONVERT(NVARCHAR(8), @SorunSaati) +
          ', Atanan Personel: ' + @AtananPersonel +
          ', Çözen Personel: ' + @CozenPersonel +
          ', Departman: ' + @Departman +
          ', Otel ID: ' + CAST(@otelid AS NVARCHAR(10));
END;

--ornek olarak bu þekilde bir insert giþriþi yaptýðpýmýzda triggere tetikleniþcektir
INSERT INTO Sorunlar ([SorunID], [IsletmePersonelAdi], [Tel], [Sorun], [Cozum], [SorunSaati], [AtananPersonel], [CozenPersonel], [Departman], [otelid])
VALUES (2, 'ferhat', '0000000', 'uygulþama açýlmýyor', 'internet baðlantýsý olmadýðý için program açýlmýyor', '15:00', 'betül', 'betül', 'rezervasyon', 2);
