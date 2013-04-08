/***************************/
/* Versi�n 3.2             */
/***************************/

-- Insertar la versi�n actual de bd
INSERT INTO AGINFOSISTEMA (AUTID,NOMBRE,VALOR,FECHAACTUALIZACION) VALUES (SEQ_INFO.NextVal,'VERSIONBD','3.2',SYSDATE);

-- Plazos de transferencia en valoraciones
CREATE TABLE ASGFPZTRVALSERIE(
    IDVALSERIE         VARCHAR2(32) NOT NULL,
    PLAZO             NUMBER  NOT NULL,
    IDNIVELARCHORG     VARCHAR2(32) NOT NULL,
    IDNIVELARCHDST     VARCHAR2(32) NOT NULL,
    ORDEN             NUMBER NOT NULL
);

--Insertar el Campo Tabla Fechas de Existencia
INSERT INTO ADCAMPOTBL (ID,NOMBRE,TIPONORMA,IDAREA,ETIQUETAXML,ETIQXMLFILA , DESCRIPCION)
VALUES('104','Fechas de Existencia',2,10,'Fechas_Existencia','Fecha_Existencia_Fila', null);

    --Eliminar el Campo que ya exist�a.
    DELETE FROM ADCAMPODATO WHERE ID='106';

    --Insertar el campo Dato Fecha Existencia Inicial
    INSERT INTO ADCAMPODATO(ID, NOMBRE, TIPO, TIPONORMA, IDAREA, IDTBLPADRE, POSENTBL, ETIQUETAXML, DESCRIPCION)
    VALUES ('106', 'Fecha Existencia Inicial', 3, 2, '10', '104', 1, 'Fecha_Existencia_Inicial', null);

    --Insertar el campo Dato Fecha Existencia Final
    INSERT INTO ADCAMPODATO(ID,NOMBRE,TIPO,TIPONORMA,IDAREA,ETIQUETAXML, IDTBLPADRE,POSENTBL, DESCRIPCION) 
    VALUES('218','Fecha Existencia Final',3,2,10,'Fecha_Existencia_Final','104',2, null);


--ADUSOOBJETO

--A�ADIR CAMPOS A LA FICHA
--Tabla: Fechas Existencia
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('104',5,'5',1);     

    --Dato:Fecha Existencia Inicial                                                                                        
    --INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('106',1,'5',1);     

    --Dato:Fecha Existencia Final                                                                                        
    INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('218',1,'5',1);     


--Tabla: Fechas Existencia
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('10',4,'104',3);     

    --Dato:Fecha Existencia Inicial                                                                                        
    --INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('10',4,'106',2);     

    --Dato:Fecha Existencia Final                                                                                        
    INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('10',1,'218',2);     



--/********************************************
-- * Asignar las tablas a las areas
-- ********************************************/

--Area de menci�n de la identidad->Tabla Volumen y Soporte
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('1',4,'1',3);
                                                         
--Area de menci�n de la identidad->Tabla Interesados     
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('1',4,'2',3);
                                                         
--Area de menci�n de la identidad->Tabla Emplazamientos      
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('1',4,'3',3);                                                     
                                                         
--Area de menci�n de la identidad->Tabla Rangos de Expedientes     
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('1',4,'102',3);
                                                         
--Area de contexto->Tabla Productores de Serie       
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('2',4,'5',3);

--Area de alcance y contenido->Tabla Documentos F�sicos     
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('3',4,'4',3);
                                                         
--Area de alcance y contenido->Tabla Documentos Electr�nicos     
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('3',4,'6',3);
                                                         
--Area de Relaciones->Tabla Entidades Relacionadas       
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('11',4,'100',3);
                                                     
--Area de Relaciones->Tabla Relaciones de entidades con otros recursos       
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('11',4,'101',3);

--Area de menci�n de la identidad->Tabla Volumen y Forma Documental
INSERT INTO ADUSOOBJETO (IDOBJ,TIPOOBJ,IDOBJUSUARIO,TIPOOBJUSUARIO)VALUES('1',4,'7',3);


--Permitir c�digo nulo
ALTER TABLE ASGFELEMENTOCF MODIFY CODIGO VARCHAR2(128);

--Permitir c�digo de referencia nulo.
ALTER TABLE ASGFELEMENTOCF MODIFY CODREFERENCIA VARCHAR2(1024);

-- Crear una columna para guardar el tipo de signaturacion
ALTER TABLE AGARCHIVO ADD TIPOSIGNATURACION INTEGER DEFAULT 1 NOT NULL;

-- Crear una columna en el hueco para almacenar la numeracion del hueco en el archivo
ALTER TABLE ASGDHUECO ADD NUMERACION VARCHAR2 (16);

-- Crear una tabla para almacenar el n�mero del siguiente hueco a crear para un archivo
-- en concreto
CREATE TABLE ASGDSIGNUMHUECO ( 
  IDARCHIVO     VARCHAR2(32) NOT NULL,
  SIGNUMHUECO      NUMBER(16) NOT NULL
  ) ; 

-- Tabla: ASGDSIGNUMHUECO
CREATE UNIQUE INDEX ASGDSIGNUMHUECO1 ON ASGDSIGNUMHUECO(IDARCHIVO, SIGNUMHUECO) TABLESPACE &1;

-- Tabla: ADTEXTTBLVLD (para evitar duplicados sobre las listas de valores)
--Eliminar Previamente los valores duplicados.
INSERT INTO ADTEXTTBLVLD SELECT ID+'-NEW',VALOR,IDTBLVLD from ADTEXTTBLVLD GROUP BY ID,VALOR,IDTBLVLD HAVING COUNT(ID)>1;
DELETE FROM ADTEXTTBLVLD WHERE ID IN (SELECT ID FROM ADTEXTTBLVLD GROUP BY ID HAVING COUNT(ID)>1);
UPDATE ADTEXTTBLVLD set ID=REPLACE(ID,'-NEW','') WHERE ID LIKE '%-NEW';

CREATE UNIQUE INDEX ADTEXTTBLVLD2 ON ADTEXTTBLVLD (ID) TABLESPACE &1;

-- Nuevo campo para marcas para huecos cuyo valor dependera de la numeraci�n del hueco
ALTER TABLE ASGDHUECO ADD MARCAS           NUMBER(2) DEFAULT 0 NOT NULL;

-- Nuevo procedimiento de comprobacion de marcas
CREATE OR REPLACE FUNCTION DEVOLVERMARCA ( numeroEnBase10 in NUMBER,posicionBit in NUMBER) 
            RETURN NUMBER
     AS
         vNumeros VARCHAR(10);
         nuevoNumero VARCHAR(120);
         auxNumeroEnBase10 NUMBER;
 BEGIN
     vNumeros:= '0123456789';
     nuevoNumero:='';
     auxNumeroEnBase10:=numeroEnBase10;   
     IF (posicionBit<0) THEN
        RETURN 0;
     END IF;
     
     WHILE (auxNumeroEnBase10 <> 0) LOOP
            nuevoNumero := (SUBSTR(vNumeros, MOD(auxNumeroEnBase10,2) + 1, 1) || nuevoNumero);
            auxNumeroEnBase10 := FLOOR(auxNumeroEnBase10 / 2);
     END LOOP;
     
     IF (posicionBit>=LENGTH(nuevoNumero)) THEN
        RETURN 0;
     END IF;
     
     IF SUBSTR(nuevoNumero, LENGTH(nuevoNumero)-posicionBit,1) ='1' THEN
        RETURN 1;
     END IF;
     RETURN 0;
END;
/

--/*****************************/
--/* Versi�n 3.0.1             */
--/*****************************/

-- Insertar la versi�n actual de bd
INSERT INTO AGINFOSISTEMA (AUTID,NOMBRE,VALOR,FECHAACTUALIZACION) VALUES (SEQ_INFO.NextVal,'VERSIONBD','3.0.1',SYSDATE);

DROP INDEX ASGDSIGNUMHUECO1;
ALTER TABLE ASGDSIGNUMHUECO MODIFY IDARCHIVO VARCHAR2(32);
ALTER TABLE ASGDSIGNUMHUECO MODIFY SIGNUMHUECO NUMBER(16);
CREATE UNIQUE INDEX ASGDSIGNUMHUECO1 ON ASGDSIGNUMHUECO(IDARCHIVO, SIGNUMHUECO) TABLESPACE &1;


--/***************************/
--/* Versi�n 3.1             */
--/***************************/

-- Crear la tabla de revisi�n de documentaci�n
CREATE TABLE ASGPREVDOCUDOC ( 
  IDREVDOC            VARCHAR2 (32)  NOT NULL, 
  IDUDOC                  VARCHAR2 (32)  NOT NULL, 
  TITULO                  VARCHAR2 (1024)  NOT NULL, 
  SIGNATURAUDOC       VARCHAR2 (254)  NOT NULL, 
  EXPEDIENTEUDOC      VARCHAR2 (128), 
  ESTADO                  NUMBER(2)    NOT NULL, 
  FESTADO                 DATE          NOT NULL, 
  OBSERVACIONES            VARCHAR2 (1024),
  MOTIVORECHAZO     VARCHAR2 (254),
  IDUSRGESTOR            VARCHAR2 (32) NOT NULL,
  IDALTA            VARCHAR2 (32)
);

-- Crear los �ndices necesarios en ASGPREVDOCUDOC
CREATE UNIQUE INDEX ASGPREVDOCUDOC1 ON ASGPREVDOCUDOC (IDREVDOC) TABLESPACE &1;
CREATE INDEX ASGPREVDOCUDOC2 ON ASGPREVDOCUDOC (IDUDOC) TABLESPACE &1;
CREATE INDEX ASGPREVDOCUDOC3 ON ASGPREVDOCUDOC (IDUDOC, ESTADO) TABLESPACE &1;

ALTER TABLE ASCAGRUPO ADD INFO VARCHAR2(1024) DEFAULT '';


--Actualizaci�n de la vesi�n anterior
DELETE FROM AGINFOSISTEMA WHERE NOMBRE='VERSIONBD' AND VALOR LIKE '3.1';

--Cambiar la columna numexp a tama�o 256
ALTER TABLE ASGTUNIDADDOCRE MODIFY NUMEXP VARCHAR (256);
ALTER TABLE ASGFUNIDADDOC MODIFY NUMEXP VARCHAR (256);
ALTER TABLE ASGFHISTUDOC MODIFY NUMEXPUDOC VARCHAR (256);
ALTER TABLE ASGFUDOCENDIVISIONFS MODIFY NUMEXP VARCHAR (256);

-- Insertar la versi�n actual de bd
INSERT INTO AGINFOSISTEMA (AUTID,NOMBRE,VALOR,FECHAACTUALIZACION) VALUES (SEQ_INFO.NextVal,'VERSIONBD','3.1',SYSDATE);


--/**************************/
--/* Versi�n 3.2            */
--/**************************/

ALTER TABLE ASGFELEMENTOCF ADD ORDPOS VARCHAR2(32);


CREATE OR REPLACE FUNCTION CALCULARFINALCODREFPADRE
(   vCodReferencia in VARCHAR2,
    vCodRefFondo in VARCHAR2,
    vCodigo in VARCHAR2,
    vFinalCodRefPadreActual in VARCHAR2,
    vDelimitador in VARCHAR2 )
    return VARCHAR2
AS
    vCodRefSinCodRefFondo  VARCHAR2(255);
    iNumCars INTEGER;
    vReturnValue VARCHAR2(255);
BEGIN
    -- algoritmo: Ej
    -- vCodReferencia            ES/NA/AJRP/CF1/CF2/F1/CS1/CS2/S1/U1
    -- vCodRefFondo                ES/NA/AJRP/CF1/CF2/F1
    -- vCodigo                    U1
    -- vFinalCodRefPadreActual    CF1/CF2/F2/CS1/CS2/S1/U1
    -- vDelimitador                /

    -- valor retornado:
    --    sin lanzar excepciones:        CS1/CS2/S1
    --    si algo fala:                CF1/CF2/F2/CS1/CS2/S1/U1

    --reemplazar en la cadena la parte del fondo+delimitador por la cadena vacia
    

    -- El codigo de referencia del fondo nunca puede llegar nulo, si llega nulo => error
    IF(LENGTH(vCodRefFondo)=0) THEN 
        RETURN vFinalCodRefPadreActual;
    END IF;

    -- El codigo de referencia nunca puede llegar nulo, si llega nulo => error
    IF(LENGTH(vCodReferencia)=0) THEN 
        RETURN vFinalCodRefPadreActual;
    END IF;
    
    -- Si el codigo de referencia del fondo no esta contenido ,en el codigo de referencia => error
    IF(INSTR(vCodReferencia,vCodRefFondo)=0) THEN 
        RETURN vFinalCodRefPadreActual;
    END IF;

    -- Quitamos la parte con el codigo de referencia del fondo, del codigo de referencia
    vCodRefSinCodRefFondo := REPLACE(vCodReferencia, vCodRefFondo || vDelimitador,'');

    -- codigo vacio
    IF(LENGTH(vCodigo)=0) THEN 
        RETURN vCodRefSinCodRefFondo;
    END IF;

    -- quitamos el codigo al final de la cadena y el caracter delimitador
    iNumCars:=LENGTH(vCodRefSinCodRefFondo)-LENGTH(vCodigo);
    vReturnValue:=null;

    IF (iNumCars>0) THEN
        vReturnValue:=SUBSTR(vCodRefSinCodRefFondo,1,iNumCars-1);
    END IF;

    RETURN vReturnValue;
EXCEPTION
    WHEN others THEN
        RETURN vFinalCodRefPadreActual;
END;
/

CREATE OR REPLACE FUNCTION ISNUMERIC 
        ( cad in VARCHAR2) 
        RETURN NUMBER AS
     aux_number NUMBER;
BEGIN
     aux_number := cad;
     RETURN 1;
EXCEPTION
     WHEN others THEN
         RETURN 0;
END;
/

CREATE OR REPLACE FUNCTION GETNUMERICPOSITIVE
        ( cad in VARCHAR2)
        RETURN NUMBER AS
     aux_number NUMBER;
BEGIN
     aux_number := cad;
     RETURN aux_number;
EXCEPTION
     WHEN others THEN
         RETURN -1;
END;
/

-- Insertar la versi�n actual de bd
INSERT INTO AGINFOSISTEMA (AUTID,NOMBRE,VALOR,FECHAACTUALIZACION) VALUES (SEQ_INFO.NextVal,'VERSIONBD','3.2',SYSDATE);

COMMIT;