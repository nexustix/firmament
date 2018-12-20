(local tcp-server (require :firmament.tcp-server))
(local connection (require :firmament.connection))
(local util (require :firmament.util))


(defn tba-server [a]
  (local self {})
  (local a (or a {}))

  (local socket-wrapper (or a.socket-wrapper connection))

  (local adress (or a.adress "*"))
  (local port (or a.port 8080))
  (local server (tcp-server {:adress adress :port port}))

  ;HACK will technically run out - bad practice
  (var n 1)
  (local connections {})
  ;forego callbacks and handle connections manualy
  (local manual a.manual)

  (defn self.on-init [addr prt]
    (print "<-> starting server on" (.. adress :: port)))

  (defn self.on-connect [conn]
    (local (ip port) (conn.get-sockname))
    (print "<-> new connection" ip port))

  (defn self.on-lost [conn reason]
    (local (ip port) (conn.get-sockname))
    (print "<-> connection lost" ip port))

  (defn self.on-message [conn tba]
    (local tsa (util.tba->tsa tba))
    (local dmsg (util.list->string tsa))
    (local (ip port) (conn.get-sockname))
    (print "<-> message" ip port dmsg))

  (defn self.init []
    (self.on-init)
    (server.init adress port))

  (defn self.get-connections []
    connections)

  (defn receive-all []
    (each [k v (pairs connections)]
      (local (tba err) (v.receive))
      (when tba
        (self.on-message v tba))
        ;(local tsa (util.tba->tsa tba))
        ;(util.plist tsa))
      (when err
        (self.on-lost v err)
        (tset connections k nil))))

  (defn self.on-update [dt]
    (local sock (server.accept))
    (when sock
      (tset connections n (socket-wrapper sock))
      (self.on-connect (. connections n))
      (set n (+ n 1)))

    (when (not manual)
      (receive-all)))




  self)
