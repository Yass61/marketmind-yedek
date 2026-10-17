CREATE TABLE dinleyici (anahtar TEXT PRIMARY KEY, deger TEXT);
CREATE TABLE onay_guncelleme (kod TEXT, zaman TEXT, eski_ozet TEXT, yeni_ozet TEXT, fark TEXT, gerekce TEXT);
CREATE TABLE onaylar (
        kod TEXT PRIMARY KEY, ozet TEXT, durum TEXT NOT NULL CHECK (durum IN ('bekliyor','onaylandi','reddedildi')),
        soruldu TEXT NOT NULL, son_soru TEXT NOT NULL, soru_sayisi INTEGER NOT NULL DEFAULT 1,
        cevap_zamani TEXT, sebep TEXT, hash TEXT);
CREATE TABLE tg_durum (anahtar TEXT PRIMARY KEY, deger TEXT);
CREATE TABLE tg_gonderim (id INTEGER PRIMARY KEY, kimlik TEXT, sinif TEXT, zaman TEXT, ok INTEGER,
          ayrinti TEXT, mesaj_id INTEGER, bicim TEXT, yineleme INTEGER DEFAULT 0);
CREATE TABLE tg_karar (id INTEGER PRIMARY KEY, kod TEXT, tur TEXT, ozet TEXT, son_saat TEXT,
          mesaj_id INTEGER, sabit INTEGER DEFAULT 0, durum TEXT DEFAULT 'acik', olusturma TEXT, kapanis TEXT);
CREATE TABLE tg_kuyruk (id INTEGER PRIMARY KEY, sinif TEXT, metin TEXT, son_saat TEXT, kod TEXT,
          tur TEXT, olusturma TEXT, durum TEXT DEFAULT 'bekliyor', mesaj_id INTEGER);
CREATE TABLE tg_not (id INTEGER PRIMARY KEY, karar_id INTEGER, metin TEXT, zaman TEXT);
