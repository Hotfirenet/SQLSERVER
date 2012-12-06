-- =============================================
-- Author:        Hotfirenet
-- Create date: 28 mars 2012
-- Description:   Permet de supprimer toutes les tables d'une base sous SQLSERVER
-- =============================================
 
DECLARE @requete VARCHAR(MAX), @nomSchema  VARCHAR(MAX), @nomTable VARCHAR(MAX)
 
DECLARE supprimToutesLesTablesDeLaBase CURSOR FOR
 
      SELECT tab.name AS nomTable
              ,sch.name AS nomSchema
      FROM sys.tables AS tab
      INNER JOIN sys.schemas AS sch ON tab.schema_id = sch.schema_id
      WHERE type  = 'U' AND sch.name <> 'DBO'
 
OPEN supprimToutesLesTablesDeLaBase
FETCH NEXT FROM supprimToutesLesTablesDeLaBase INTO @nomTable, @nomSchema
WHILE(@@FETCH_STATUS = 0)
      BEGIN
            SET @requete = 'DROP TABLE ' + @nomSchema + '.' + @nomTable
            EXEC (@requete)
            FETCH NEXT FROM supprimToutesLesTablesDeLaBase INTO @nomTable, @nomSchema
      END
CLOSE supprimToutesLesTablesDeLaBase
DEALLOCATE supprimToutesLesTablesDeLaBase