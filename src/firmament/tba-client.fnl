(local socket (require :socket))
(local tcp-client (require :firmament.tcp-client))
(local connection (require :firmament.connection))
(local util (require :firmament.util))

(defn tba-client [a]
  (local self {})
  (local a (or a {}))

  (local socket-wrapper (or a.socket-wrapper connection))

  (local adress (socket.dns.toip (or a.adress "localhost")))
  (local port (or a.port 8080))
  (local client (tcp-client {:adress adress :port port}))
  (var conn false)
  (local manual a.manual)

  (defn self.on-init [addr prt]
    (print "<-> initializing connection with" (.. addr :: prt)))

  (defn self.on-lost [reason]
    (print "<-> connection lost" reason))

  (defn self.on-message [tba]
    (local tsa (util.tba->tsa tba))
    (local dmsg (util.list->string tsa))
    (local (ip port) (conn.get-sockname))
    (print "<-> message" ip port dmsg))

  (defn self.init []
    (self.on-init adress port)
    (local (succ err) (client.init))
    (when (not err)
      (set conn (socket-wrapper (client.get))))
    (values succ err))

  (defn self.send [tba]
    (conn.send tba))

  (defn self.receive []
    (local (tba err) (conn.receive))
    (when tba
      (self.on-message tba))
    (when err
      (self.on-lost err)))

  (defn self.on-update []
    (when (not manual)
      (self.receive)))
  self)
