(local util {})


(defn util.sublist [t low high]
  (local low (or low 1))
  (local high (or high (# t)))
  (local r {})
  (for [n low high]
    (tset r (+ (# r) 1) (. t n)))
  r)

(defn util.plist [the-list sep]
  (local sep (or sep "⋮"))
  (io.write "(")
  (each [i v (ipairs the-list)]
    (io.write v)
    ;(print v)
    (io.write sep))
  (print ")"))

(defn util.list->string [the-list sep]
  (local sep (or sep "⋮"))
  (var r "(")
  (each [i v (ipairs the-list)]
    (set r (.. r v))
    (set r (.. r sep)))
  (set r (.. r ")"))
  r)

(defn util.reverse [the-table]
  (local t [])

  (for [i (# the_table) 1 -1]
    (tset t (+ (# t) 1) (. the_table i)))
  t)

;; convert string into list of octets
(defn util.string->octets [str]
  (local tmp-octets [])

  (for [i 1 (# str)]
    (local c (: str :sub i i))
    (local b (string.byte c))
    (tset tmp-octets i b))

  tmp-octets)

;; convert list of octets into string
(defn util.octets->string [octets]
  (var tmp-string "")

  (each [i v (ipairs octets)]
    (local c (string.char v))
    (set tmp-string (.. tmp-string c)))

  tmp-string)

;TODO add option to preserve leading zeros
;; convert source digits "src" from base "fb" to base "tb"
(defn util.convert [src fb tb]
  (local res [])
  (var tsrc src)

  (defn divmod [xsrc]
    (local d [])
    (var rem 0)

    (each [k v (ipairs xsrc)]
      (var c (+ (* rem fb) v))
      (var e (math.floor (/ c tb)))
      (set rem (% c tb))

      (when (or (> (# d) 0) (~= e 0))
        (tset d (+ (# d) 1) e)))

    (values d rem))

  (while (> (# tsrc) 0)

    (let [(src rem) (divmod tsrc)]
      (set tsrc src)

      (tset res (+ (# res) 1) rem)))

  (util.reverse res))

;; convert digits  to changestream
(defn util.digits->cstream [digits]
  (local t [])
  (var last nil)

  (each [i v (ipairs digits)]
    (if (= v last)
        (tset t (+ (# t) 1) 1)
        (tset t (+ (# t) 1) (+ v 2)))

    (set last v))

  (tset t (+ (# t) 1) 0)
  t)


;FIXME ignored message terminators, for now ;TODO fixed ?
;; convert changestream to digits
(defn util.cstream->digits [cstream]
  (local mt [])
  (var t [])
  (var last nil)

  (each [i v (ipairs cstream)]
    (if (= v 1)
        (tset t (+ (# t) 1) last)
        (= v 0)
        (do
          (tset mt (+ (# mt) 1) t)
          (set t []))
        (tset t (+ (# t) 1) (- v 2)))

    (set last (- v 2)))

  mt)

(defn util.octets->cstream [octets cbase]
  (local cbase (or cbase 256))
  (local rbase (- cbase 2))
  (local d (util.convert octets 256 rbase))
  (local c (util.digits->cstream d))
  c)


(defn util.cstream->octets [cstream cbase]
  (local cbase (or cbase 256))
  (local rbase (- cbase 2))
  (local d (util.cstream->digits cstream))
  (local o (util.convert d rbase 256))
  o)

;token string array to token byte array
(defn util.tsa->tba [tsa]
  (local tba [])
  (each [i v (ipairs tsa)]
    (tset tba (+ (# tba) 1) (util.string->octets v)))
  tba)

;token byte array to token string array
;FIXME test function
(defn util.tba->tsa [tba]
  (local tsa [])
  (each [i v (ipairs tba)]
    (tset tsa (+ (# tsa) 1) (util.octets->string v)))
  tsa)


util
