(local socket (require :socket))

(defn client-tcp [a]
  (local self {})
  (local a (or a {}))

  ;(local running true)
  (local adress (socket.dns.toip (or a.adress "localhost")))
  (local port (or a.port 8080))

  (defn self.init []
    (local (tcp err) (socket.tcp))
    (if tcp
      (do
        (: tcp :setoption :tcp-nodelay true)
        (: tcp :setoption :reuseaddr true)
        (: tcp :settimeout 5)
        (local (succ err) (: tcp :connect adress port))
        (: tcp :settimeout 0)
        (when succ
          (set self.tcp tcp))
        (values succ err))
      (values nil err)))

  (defn self.connect []
    (set self.tcp (socket.tcp))
    (: self.tcp :settimeout 0)
    (: self.tcp :setoption :tcp-nodelay true)
    (: self.tcp :connect adress port))

  (defn self.get []
    self.tcp)

  self)
