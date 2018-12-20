(local socket (require :socket))

(defn server-tcp [a]
  (local self {})
  (local a (or a {}))

  (local adress (or a.adress "*"))
  (local port (or a.port 8080))

  (defn self.init []
    (local (tcp err) (socket.tcp))
    (if tcp
      (do
        (local (succ err) (: tcp :bind adress port))
        (: tcp :listen 32)
        (: tcp :settimeout 0)
        (: tcp :setoption :reuseaddr true)
        (: tcp :setoption :tcp-nodelay true)
        (set self.tcp tcp)
        (values succ err))
      (values nil err)))

  (defn self.accept []
    (local client (: self.tcp :accept))
    (when client
      (: client :settimeout 0)
      (: self.tcp :setoption :reuseaddr true)
      (: client :setoption :tcp-nodelay true)
      (local (ip port) (: client :getsockname)))
      ;(print ip port))
    client)

  self)
