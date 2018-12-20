(local tcp-server (require :firmament.tcp-server))
(local connection (require :firmament.connection))
(local util (require :firmament.util))
(local tba-server (require :firmament.tba-server))

(local server (tba-server {:port 3587}))
(local (succ err) (server.init))
(assert succ err)

(defn echo [conn tba]
  (local tsa (util.tba->tsa tba))
  (local dmsg (util.list->string tsa))
  (local (ip port) (conn.get-sockname))
  (print "<-> message" ip port dmsg)
  (conn.send tba))

(set server.on-message echo)

(while true
  (server.on-update))


;(local server (tcp-server {:adress "localhost" :port 3587}))
;
;(local (succ err) (server.init))
;(assert succ err)
;
;(var n 1)
;(local connections {})
;
;(while true
;  (local sock (server.accept))
;  (when sock
;    (tset connections n (connection sock))
;    (set n (+ n 1))
;    (print "<-> new connection"))
;
;  (each [k v (pairs connections)]
;    (local (tba err) (v.receive))
;    (when tba
;      (local tsa (util.tba->tsa tba))
;      (util.plist tsa))
;    (when err
;      (print "<-> connection lost")
;      (tset connections k nil))))


  ;(when sock
  ;  (local client (connection sock))
  ;  (print "DING")
  ;  (var error false)
  ;  (while (not error)
  ;    (local (msg err part) (client.receive))
  ;    (set error err)
  ;    (when err
  ;      (print err)))
  ;  (print "click")))
