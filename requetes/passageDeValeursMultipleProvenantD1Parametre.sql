-- =============================================
-- Author:        Hotfirenet
-- Create date: 11 mars 2013
-- Description:   Cette fonction permet de couper plusieurs elements dans une chaine de caractere separes par une virgule
-- =============================================
CREATE FUNCTION [dbo].[fnSplitStringList] (@StringList VARCHAR(MAX))
RETURNS @TableList TABLE( StringLiteral VARCHAR(128))

BEGIN

    DECLARE @StartPointer INT, @EndPointer INT

    SELECT @StartPointer = 1, @EndPointer = CHARINDEX(',', @StringList)

    WHILE (@StartPointer < LEN(@StringList) + 1) 

    BEGIN

        IF @EndPointer = 0 

            SET @EndPointer = LEN(@StringList) + 1

        INSERT INTO @TableList (StringLiteral) 

        VALUES(LTRIM(RTRIM(SUBSTRING(@StringList, @StartPointer, 

                                     @EndPointer - @StartPointer))))

        SET @StartPointer = @EndPointer + 1

        SET @EndPointer = CHARINDEX(',', @StringList, @StartPointer)

    END -- WHILE

    RETURN

END -- FUNCTION

