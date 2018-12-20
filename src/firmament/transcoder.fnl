(local util (require :firmament.util))

(local self {})

;(defn transcoder []
;  (local self {})

(defn self.tba->fstream [tba]
  (local cstream [])
  (each [i v (ipairs tba)]
    ;HACK guard against messages starting with 0
    (table.insert v 1 1)
    (each [ii octet (ipairs (util.octets->cstream v))]
      (tset cstream (+ (# cstream) 1) octet))
    ;HACK revert side effects
    (table.remove v 1))
  cstream)

(defn self.fstream->tba [fstream]
  (local tba [])
  (local hack-tba [])
  (local meta-digits (util.cstream->digits fstream))
  (each [i digits (ipairs meta-digits)]
    (local octets (util.convert digits (- 256 2) 256))
    (local t [])
    (each [ii octet (ipairs octets)]
      (tset t (+ (# t) 1) octet))
    (tset tba (+ (# tba) 1) t))

  ;HACK guard against messages starting with 0
  (each [i v (ipairs tba)]
    (local t [])
    (for [n 2 (# v)]
      (tset t (+ (# t) 1) (. v n)))
    (tset hack-tba (+ (# hack-tba) 1) t))
  hack-tba)

;  self)
self
