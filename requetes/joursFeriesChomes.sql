-- =============================================
-- Author:        Johan .V
-- Create date: 11 mars 2013
-- Description:   Ce script permet de calculer et de définir les jours fériés 
-- =============================================

-- Source de cette fonction http://stackoverflow.com/questions/266924/create-a-date-with-t-sql
--create function [dbo].[fnDateTime2FromParts](@Year int, @Month int, @Day int, @Hour int, @Minute int, @Second int, @Nanosecond int)
--  returns datetime2
--  as
--  begin
--  	-- Note! SQL Server 2012 includes datetime2fromparts() function
--  	declare @output datetime2 = '19000101'
--  	set @output = dateadd(year      , @Year - 1900  , @output)
--  	set @output = dateadd(month     , @Month - 1    , @output)
--  	set @output = dateadd(day       , @Day - 1      , @output)
--  	set @output = dateadd(hour      , @Hour         , @output)
--  	set @output = dateadd(minute    , @Minute       , @output)
--  	set @output = dateadd(second    , @Second       , @output)
--  	set @output = dateadd(ns        , @Nanosecond   , @output)
--  	return @output
--  end

-- Source de ce scrit http://www.xoowiki.com/Article/SQL/liste-des-jours-feries-47.aspx
DECLARE @JoursFeries AS TABLE  (      
    [JourId] [INT] IDENTITY(1,1) NOT NULL,      
    [JourDate] [DATETIME] NOT NULL,      
    [JoURLabel] [VARCHAR](50) NULL,      
    [JourChome] [bit] NULL DEFAULT ((1))   
)       
    
DECLARE @an INT 
DECLARE @G INT     
DECLARE @I INT     
DECLARE @J INT     
DECLARE @C INT     
DECLARE @H INT     
DECLARE @L INT     
DECLARE @JourPaque INT     
DECLARE @MoisPaque INT     
DECLARE @DimPaque DATETIME     
DECLARE @LunPaque DATETIME     
DECLARE @JeuAscension DATETIME     
DECLARE @LunPentecote DATETIME     
DECLARE @NouvelAn DATETIME     
DECLARE @FeteTravail DATETIME     
DECLARE @Armistice3945 DATETIME     
DECLARE @Assomption DATETIME     
DECLARE @Armistice1418 DATETIME     
DECLARE @FeteNationale DATETIME     
DECLARE @ToussaINT DATETIME     
DECLARE @Noel DATETIME   
   
SET @an = YEAR(GETDATE())    
       
SET @G = @an % 19      
SET @C = @an / 100      
SET @H = (@C - @C / 4 - (8 * @C + 13) / 25 + 19 * @G + 15) % 30      
SET @I = @H - (@H / 28) * (1 - (@H / 28) * (29 / (@H + 1)) * ((21 - @G) / 11))      
SET @J = (@an + @an / 4 + @I + 2 - @C + @C / 4) % 7      
       
SET @L = @I - @J      
SET @MoisPaque = 3 + (@L + 40) / 44      
SET @JourPaque = @L + 28 - 31 * (@MoisPaque / 4)      
       
-- Jours fériés mobiles             
SET @DimPaque = Infocentre.dbo.fnDateTime2FromParts(@an, @MoisPaque, @JourPaque, 0, 0, 0, 0)      
SET @LunPaque = DATEADD(DAY, 1, @DimPaque)      
SET @JeuAscension = DATEADD(DAY, 39, @DimPaque)      
SET @LunPentecote = DATEADD(DAY, 50, @DimPaque)      
       
-- Jours fériés fixes             
SET @NouvelAn = Infocentre.dbo.fnDateTime2FromParts(@an, 01, 01, 0, 0, 0, 0) --DATEFROMPARTS(@an, 1, 1) -- cast(cast(@an AS VARCHAR(4))+'-01-01 00:00:00' AS DATETIME)
SET @FeteTravail = Infocentre.dbo.fnDateTime2FromParts(@an, 05, 01, 0, 0, 0, 0) --DATEFROMPARTS(@an, 5, 1) -- cast(cast(@an AS VARCHAR(4))+'-05-01 00:00:00' AS DATETIME)
SET @Armistice3945 = Infocentre.dbo.fnDateTime2FromParts(@an, 05, 08, 0, 0, 0, 0) --DATEFROMPARTS(@an, 5, 8) -- cast(cast(@an AS VARCHAR(4))+'-05-08 00:00:00' AS DATETIME)      
SET @Assomption = Infocentre.dbo.fnDateTime2FromParts(@an, 08, 15, 0, 0, 0, 0) --DATEFROMPARTS(@an, 8, 15) --cast(cast(@an AS VARCHAR(4))+'-08-15 00:00:00' AS DATETIME)      
SET @Armistice1418 = Infocentre.dbo.fnDateTime2FromParts(@an, 11, 11, 0, 0, 0, 0) --DATEFROMPARTS(@an, 11, 11) --cast(cast(@an AS VARCHAR(4))+'-11-11 00:00:00' AS DATETIME)      
SET @FeteNationale = Infocentre.dbo.fnDateTime2FromParts(@an, 07, 14, 0, 0, 0, 0) --DATEFROMPARTS(@an, 7, 14) --cast(cast(@an AS VARCHAR(4))+'-07-14 00:00:00' AS DATETIME)      
SET @ToussaINT = Infocentre.dbo.fnDateTime2FromParts(@an, 11, 01, 0, 0, 0, 0) --DATEFROMPARTS(@an, 11, 1) --cast(cast(@an AS VARCHAR(4))+'-11-01 00:00:00' AS DATETIME)      
SET @Noel = Infocentre.dbo.fnDateTime2FromParts(@an, 12, 25, 0, 0, 0, 0) --DATEFROMPARTS(@an, 5, 1) --cast(cast(@an AS VARCHAR(4))+'-12-25 00:00:00' AS DATETIME)    
-- Il faut que je test le DATEFROMPARTS sur SQLSERVEUR 2012 -- http://msdn.microsoft.com/en-us/library/hh213228.aspx
       
INSERT  INTO @JoursFeries (JourDate, JoURLabel, JourChome)  
SELECT  @DimPaque, 'Dimanche de Pâques', 0    
UNION 
SELECT  @LunPaque, 'Lundi de Pâques', 0  
UNION 
SELECT  @JeuAscension, 'Jeudi de l''Ascension', 1    
UNION   
SELECT  @LunPentecote, 'Lundi de Pentecôte', 1    
UNION 
SELECT  @NouvelAn, 'Nouvel an', 1    
UNION 
SELECT  @FeteTravail, 'Fête du travail', 1   
UNION   
SELECT  @Armistice3945, 'Armistice 39-45', 1   
UNION  
SELECT  @Assomption, 'Assomption', 1   
UNION 
SELECT  @FeteNationale, 'Fête Nationale', 1   
UNION 
SELECT  @ToussaINT, 'Toussaint', 1   
UNION 
SELECT  @Armistice1418, 'Armistice 14-18', 1    
UNION 
SELECT  @Noel, 'Noël', 0  
   
SELECT  *  
FROM    @JoursFeries
