(local tcp-client (require :firmament.tcp-client))
(local connection (require :firmament.connection))
(local util (require :firmament.util))
(local transcoder (require :firmament.transcoder))
(local tba-client (require :firmament.tba-client))

(local client (tba-client {:port 3587}))
(local (succ err) (client.init))
(assert succ err)
(while true
  (io.write (.. ">"))
  (local msg (io.read))
  (local tba [(util.string->octets msg)])
  ;(local fstream (transcoder.tba->fstream tba))
  ;(local emsg (util.octets->string fstream))
  (client.send tba)
  (client.on-update))


;(local client (tcp-client {:adress "localhost" :port 3587}))
;(local (succ err) (client.init))
;(print succ err)
;
;(local connection (connection (client.get)))
;
;(while true
;  (io.write (.. ">"))
;  (local msg (io.read))
;  (local tba [(util.string->octets msg)])
;  ;(local fstream (transcoder.tba->fstream tba))
;  ;(local emsg (util.octets->string fstream))
;  (connection.send tba))
