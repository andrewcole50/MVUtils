     SUBROUTINE JWRITE(fileName,key,record,isError)
     *********************************************
      * 2018-07-20 by Andrew Cole
      * 
      * Tested Platforms:
      * d3: Untested
      * UniVerse: Untested
      * UniData: Untested
      * jBase: Works
      * OpenQM: Untested
      * mvBase: Works
      *********************************************
     * Set Initial Variables
     AM = CHAR(254)
     VM = CHAR(253)
     SVM = CHAR(252)
     TRUE = 1
     FALSE = 0
     conversionField = 7
     isError = 0
     
     OPEN fileName TO fileObject ELSE isError = TRUE
     OPEN 'DICT',fileName TO dictObject ELSE isError = TRUE
     
     IF fileName='' THEN isError = TRUE
     IF key='' THEN isError = TRUE
     IF record='' THEN isError = TRUE
     
     IF NOT(isError) THEN
        QUERY="SELECT DICT ":fileName:" IF ":conversionField
        EXECUTE QUERY
        
        doLoop = TRUE
        LOOP
           READNEXT i ELSE doLoop = FALSE
        WHILE doLoop DO
           IF i MATCHES "0N" THEN
              READV conversionCode FROM dictObject,i,conversionField THEN
                 valueLength = DCOUNT(record<i>, VM)
                 FOR j=1 TO valueLength
                    subValueLength = DCOUNT(record<i,j>, SVM)
                    FOR k=1 TO subValueLength
                       record<i,j,k> = OCONV(record<i,j,k>, conversionCode)
                    NEXT k
                 NEXT j
              END
           END
        REPEAT
        
        WRITE record ON fileObject,key
     END
     
     RETURN
