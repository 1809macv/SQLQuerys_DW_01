
/****** Object:  StoredProcedure [dbo].[GeneratorId]    Script Date: 5/14/2019 3:34:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[GeneratorId] (
	@Table varchar(100),@CounterId int, @Id int output)
  as 

MERGE INTO keys
USING (SELECT @Table AS Tabla, @CounterId as Conta1) AS reg
ON keys.Tabla = reg.Tabla
WHEN MATCHED THEN
     --UPDATE SET Contador = Contador + reg.Conta1 --WHERE Tabla = @Tabla
     UPDATE SET Contador += reg.Conta1 
WHEN NOT MATCHED THEN
     INSERT (Tabla, Contador)
	 VALUES (reg.Tabla, 1)
--OUTPUT inserted.Contador
--	   INTO @Id;
SELECT @Id = Contador From Keys
 Where Tabla = @Table;

 GO


 