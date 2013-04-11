-- =============================================
-- Author:        Johan .V
-- Create date: 11 mars 2013
-- Description:   Ce script permet de calculer et de définir les jours fériés 
-- =============================================

CREATE FUNCTION anneeBissextile (@Annee AS int) 
RETURNS bit
AS
BEGIN
    Declare @Date29Fev AS Datetime
    Declare @Result AS bit
    SET @Date29Fev  = DATEADD(DAY, -1, Cast('01/03/'+Cast(@Annee AS varchar(4)) AS datetime))
    IF Day(@Date29Fev )=29    
        SET @Result = 1
    ELSE
        SET @Result = 0
    return @Result
END

