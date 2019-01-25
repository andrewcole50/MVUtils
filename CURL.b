      SUBROUTINE CURL(url,headers,type,data,response)
      *********************************************
      * 2018-07-20 by Andrew Cole
      * 
      * Tested Platforms:
      * d3: Untested
      * UniVerse: Untested
      * UniData: Untested
      * jBase: Works queryChar = @IM:'k'
      * OpenQM: Untested
      * mvBase: Works queryChar = '! '
      *********************************************
      queryChar = '! '
      response = ''
      curlCMD = 'curl -s '
      
      validTypes = 'GET':@AM:'POST':@AM:'PUT':@AM:'DELETE'
      LOCATE(type, validTypes; i) THEN
         curlCommand = queryChar:curlCMD
         curlCommand := '-X ':type:' '
         curlCommand := url:' '
         size = DCOUNT(headers, @AM)
         FOR j=1 TO size
            curlCommand := '-H "':headers<j>:'" '
         NEXT j
         
         IF data#'' THEN
            size = DCOUNT(data, @AM)
            FOR j=1 TO size
               curlCommand := "-d '":data<j>:"' "
            NEXT j
         END
         CRT curlCommand
         EXECUTE 'CAP-HUSH-ON' ;* mvBase to hide terminal output
         EXECUTE curlCommand CAPTURING rawResponse
         EXECUTE 'CAP-HUSH-OFF' ;* mvBase to enable terminal output
         
         size = DCOUNT(rawResponse, @AM)
         FOR j=3 TO size
            IF rawResponse<j>#'' THEN
               IF NOT(INDEX(rawResponse<j>, '[!]>EXIT', 1)) THEN
                  response<-1> = rawResponse<j>
               END
            END
         NEXT j
      END ELSE 
         response = 0
      END
      RETURN
