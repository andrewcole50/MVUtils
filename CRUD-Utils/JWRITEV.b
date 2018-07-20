     SUBROUTINE JWRITEV(fileName,key,record,attr,isError)
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
     isError = FALSE
     
     OPEN fileName TO fileObject ELSE isError = TRUE
     OPEN 'DICT',fileName TO dictObject ELSE isError = TRUE
     
     IF fileName='' THEN isError = TRUE
     IF key='' THEN isError = TRUE
     IF record='' THEN isError = TRUE
     IF attr='' THEN isError = TRUE
     
     tempAttribute = ''
     READ dict from dictObject,attr THEN
        IF dict<conversionField>#'' THEN
           valueLength = DCOUNT(record<1>, VM)
           FOR i=1 TO valueLength
              subValueLength = DCOUNT(record<1,i>, SVM)
              FOR j=1 TO subValueLength
                 record<1,i,k> = ICONV(record<1,i,k>, dict<conversionField>)
              NEXT j
           NEXT i
        END
     END
     
     WRITEV record ON fileName.FL,key,attr
  END ELSE
     isError = TRUE
  END
  
  RETURN
