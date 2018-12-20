(local util (require :firmament.util))
(local transcoder (require :firmament.transcoder))

(defn connection [socket]
  (local self {})
  (local a (or a {}))

  (local size 8192)

  (assert socket)
  (set self.sock socket)

  (var buffer "")

  (defn self.close []
    (: self.sock :shutdown))

  (defn self.get-sockname []
    (: socket :getsockname))

  ;TODO use threading macro ?
  (defn self.sendraw [tba]
    (local fstream (transcoder.tba->fstream tba))
    (local packet (util.octets->string fstream))
    (: self.sock :send packet))

  (defn self.flush []
    (self.sendraw [[]]))

  (defn self.send [tba]
    (self.sendraw [(unpack tba) []]))

  (defn self.receive []
    (local (data err partial) (: self.sock :receive size))

    (local msg (or data partial))
    (when (and msg (> (# msg) 0))
      (set buffer (.. buffer msg))
      (local octets (util.string->octets buffer)))
      ;(util.plist octets))

    (local (start stop) (: buffer :find "\0\3\0"))
    ;TODO use threading macro ?
    (if start
        (do
          (local packet (: buffer :sub 1 start))
          (local fstream (util.string->octets packet))
          (local tba (transcoder.fstream->tba fstream))
          ;(util.plist (. tba 1))
          (set buffer (: buffer :sub (+ stop 1) (# buffer)))
          tba)
        (if (= err :timeout)
            (values nil nil)
            (values nil err))))




  self)
