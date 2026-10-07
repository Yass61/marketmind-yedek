CREATE TABLE dinleyici (anahtar TEXT PRIMARY KEY, deger TEXT);
CREATE TABLE onaylar (
        kod TEXT PRIMARY KEY, ozet TEXT, durum TEXT NOT NULL CHECK (durum IN ('bekliyor','onaylandi','reddedildi')),
        soruldu TEXT NOT NULL, son_soru TEXT NOT NULL, soru_sayisi INTEGER NOT NULL DEFAULT 1,
        cevap_zamani TEXT, sebep TEXT, hash TEXT);
