CREATE TABLE ai_yorumlar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    symbol TEXT NOT NULL,
    date TEXT NOT NULL,
    mod TEXT NOT NULL,
    yorum TEXT,
    token_kullanim INTEGER,
    maliyet REAL,
    olusturuldu_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(symbol, date, mod)
);
CREATE TABLE deflator (
    ad     TEXT NOT NULL,          -- 'USDTRY' | 'TUFE'
    date   TEXT NOT NULL,
    deger  REAL NOT NULL,
    kaynak TEXT,
    PRIMARY KEY (ad, date)
);
CREATE TABLE endeks_gunluk (
    sembol TEXT NOT NULL,
    date   TEXT NOT NULL,
    close  REAL,
    kaynak TEXT,
    PRIMARY KEY (sembol, date)
);
CREATE TABLE fetch_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    symbol TEXT,
    status TEXT,
    message TEXT,
    fetched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE fundamental_cache (
            sembol          TEXT PRIMARY KEY,
            guncelleme      TEXT,      -- YYYY-MM-DD
            fk              REAL,
            pd_dd           REAL,
            roe             REAL,
            borc_ozkaynak   REAL,
            piyasa_deg      REAL,
            kar_marji       REAL,
            ciro_buyume     REAL,
            kar_buyume      REAL,
            ort_hacim       REAL,
            ad              TEXT
        );
CREATE TABLE fundamental_gecmis (
    sembol          TEXT NOT NULL,
    donem           TEXT NOT NULL,      -- '2022' (yıllık)
    gecerli_tarih   TEXT NOT NULL,      -- point-in-time: bu tarihten İTİBAREN kullanılabilir
    ozkaynak        REAL,
    net_kar         REAL,
    satis           REAL,
    toplam_varlik   REAL,
    kisa_yukumluluk REAL,
    uzun_yukumluluk REAL,
    faaliyet_kari   REAL,
    roe             REAL,
    net_marj        REAL,
    borc_ozkaynak   REAL,
    kaynak          TEXT, sablon TEXT,
    PRIMARY KEY (sembol, donem)
);
CREATE TABLE hat_ilerleme (
            is_adi  TEXT NOT NULL,
            sembol  TEXT NOT NULL,
            gun     TEXT NOT NULL,      -- YYYY-MM-DD, koşum günü
            zaman   TEXT NOT NULL,
            sonuc   TEXT NOT NULL,      -- OK | BOS | HATA
            PRIMARY KEY (is_adi, sembol, gun)
        );
CREATE TABLE hat_kilit (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            is_adi     TEXT NOT NULL,
            durum      TEXT NOT NULL,      -- CALISIYOR | BITTI | DUSTU
            pid        INTEGER NOT NULL,
            makine     TEXT NOT NULL,
            baslama    TEXT NOT NULL,
            kalp_atisi TEXT NOT NULL,
            bitis      TEXT
        );
CREATE TABLE instruments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    symbol TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    sector TEXT,
    tv_symbol TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE is_kuyrugu (
                id            INTEGER PRIMARY KEY AUTOINCREMENT,
                is_tipi       TEXT NOT NULL,
                parametreler  TEXT,
                durum         TEXT NOT NULL DEFAULT 'BEKLIYOR',
                ilerleme      INTEGER NOT NULL DEFAULT 0,
                mesaj         TEXT,
                olusturma     TEXT NOT NULL,
                baslama       TEXT,
                bitis         TEXT,
                hata          TEXT,
                kalp_atisi    TEXT,
                surec_pid     INTEGER
            );
CREATE TABLE kap_bildirim (
            disclosure_index INTEGER PRIMARY KEY,
            tarih            TEXT NOT NULL,      -- YYYY-MM-DD
            saat             TEXT,
            sembol           TEXT,               -- stockCodes (virgüllü olabilir)
            sirket           TEXT,
            sinif            TEXT,               -- ODA / DKB / DG / FR
            kategori         TEXT,               -- disclosureCategory
            konu             TEXT,               -- subject  ← ANA SINIFLANDIRMA
            ozet             TEXT,
            gec_mi           INTEGER
        );
CREATE TABLE ohlcv_4h (
        symbol TEXT, date TEXT, open REAL,
        high REAL, low REAL, close REAL, volume REAL,
        PRIMARY KEY (symbol, date)
    );
CREATE TABLE ohlcv_daily_ham(
  id INT,
  symbol TEXT,
  date TEXT,
  open REAL,
  high REAL,
  low REAL,
  close REAL,
  volume REAL
);
CREATE TABLE ohlcv_daily_reel (
    symbol TEXT NOT NULL,
    date   TEXT NOT NULL,
    baz    TEXT NOT NULL,          -- 'usd' | 'tufe'
    high   REAL, low REAL, close REAL,
    volume REAL,                   -- LOT (deflate edilmez)
    PRIMARY KEY (symbol, date, baz)
);
CREATE TABLE ohlcv_daily_uzun (
    symbol   TEXT NOT NULL,
    date     TEXT NOT NULL,          -- YYYY-MM-DD
    open     REAL,                   -- ⚠️ kaynakta YOK, NULL
    high     REAL,
    low      REAL,
    close    REAL,
    volume   REAL,                   -- LOT (TL hacim / ham AOF ile türetildi)
    hacim_tl REAL,                   -- kaynağın verdiği TL hacim
    aof      REAL,                   -- düzeltilmiş ağırlıklı ortalama fiyat
    kaynak   TEXT,
    PRIMARY KEY (symbol, date)
);
CREATE TABLE "ohlcv_daily_yf_arsiv" (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    symbol TEXT NOT NULL,
    date TEXT NOT NULL,
    open REAL,
    high REAL,
    low REAL,
    close REAL,
    volume REAL,
    UNIQUE(symbol, date),
    FOREIGN KEY (symbol) REFERENCES instruments(symbol)
);
CREATE TABLE piyasa_degeri (
    symbol   TEXT NOT NULL,
    date     TEXT NOT NULL,
    pd       REAL,      -- piyasa değeri (TL)
    hao_pd   REAL,      -- halka açık kısmın piyasa değeri
    sermaye  REAL,
    PRIMARY KEY (symbol, date)
);
CREATE TABLE prices_latest (
    symbol TEXT PRIMARY KEY,
    price REAL NOT NULL,
    change_24h REAL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE "tarama_arsiv" (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tarama_tarihi TEXT NOT NULL,      -- YYYY-MM-DD
    sembol TEXT NOT NULL,
    kategori TEXT,                     -- AKTIF | IZLEMEDE | ELENEN
    toplam_skor REAL,
    blok_trend REAL, blok_hacim REAL, blok_sikisma REAL, blok_goreceli REAL,
    adx REAL, adx_carpan REAL,
    kap_puan INTEGER, kap_etiketler TEXT,
    fund_durum TEXT, fund_bayraklar TEXT,
    sektor TEXT, sektor_rel REAL,
    fiyat REAL,                        -- tarama anındaki kapanış
    rsi REAL, mom_20 REAL, mom_60 REAL, hacim_z REAL,
    tavan_mi INTEGER, kaynak TEXT DEFAULT 'canli', sektor_rel_v2 REAL, toplam_skor_v2 REAL, bozukluk TEXT, ema20_uzak REAL, likidite REAL, atr REAL, giris_bolgesi REAL, stop REAL, rr REAL, evren_boyut INTEGER,                  -- o gün tavan mı (ertesi gün alınamaz)
    UNIQUE(tarama_tarihi, sembol, kaynak)
);
CREATE TABLE technical_analysis (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    symbol TEXT NOT NULL,
    date TEXT NOT NULL,
    hesaplandi_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Genel sonuc
    skor REAL DEFAULT 0,
    kalite TEXT,
    tavsiye TEXT,
    no_trade_nedeni TEXT,

    -- Rejim ve trend
    regime TEXT,
    alt_regime TEXT,
    regime_yon TEXT,
    regime_guc INTEGER DEFAULT 0,
    volatilite TEXT,
    compression INTEGER DEFAULT 0,

    -- Gostergeler
    rsi REAL DEFAULT 50,
    macd_pozitif INTEGER DEFAULT 0,
    ema_pozisyon TEXT,

    -- ICT/SMC bayraklari
    bos_var INTEGER DEFAULT 0,
    choch_var INTEGER DEFAULT 0,
    mss_var INTEGER DEFAULT 0,
    sweep_var INTEGER DEFAULT 0,
    ob_var INTEGER DEFAULT 0,
    fvg_var INTEGER DEFAULT 0,
    ict_confluence INTEGER DEFAULT 0,

    -- State machine
    state_ilerleme INTEGER DEFAULT 0,
    sweep_tamam INTEGER DEFAULT 0,
    choch_tamam INTEGER DEFAULT 0,
    bos_tamam INTEGER DEFAULT 0,
    poi_tamam INTEGER DEFAULT 0,
    retest_tamam INTEGER DEFAULT 0,

    -- MTF
    h4_bias TEXT,
    h1_bias TEXT,
    m15_bias TEXT,
    mtf_hizalama INTEGER DEFAULT 0,

    -- Formasyon ve harmonik
    formasyon TEXT,
    formasyon_guven INTEGER DEFAULT 0,
    harmonik_pattern TEXT,
    harmonik_guven INTEGER DEFAULT 0,

    -- Hafiza
    hafiza_benzer INTEGER DEFAULT 0,
    hafiza_basari INTEGER DEFAULT 0,
    hafiza_rr REAL DEFAULT 0,

    -- Edge
    edge_durum TEXT,
    edge_tavsiye TEXT,
    decay_var INTEGER DEFAULT 0,
    failure_tavsiye TEXT,
    guven_carpani REAL DEFAULT 1.0,

    -- Fibo
    fibo_kurulum TEXT,

    -- AI ozet
    ai_ozet TEXT,

    -- Hata ve ham veri
    hata TEXT,
    ham_sonuc TEXT, gz_aktif TEXT, gz_tip TEXT, gz_icinde INTEGER DEFAULT 0, gz_alt REAL, gz_ust REAL, gz_uyari TEXT, gz_hedefler TEXT, baskin_arketip TEXT, baskin_arketip_skor REAL, baskin_arketip_durum TEXT, momentum_skor REAL, donus_skor REAL, kirilim_skor REAL, pullback_skor REAL,

    UNIQUE(symbol, date)
);
CREATE TABLE video_hat_ilerleme (
    kod        TEXT NOT NULL,
    adim       TEXT NOT NULL,
    sonuc      TEXT NOT NULL,          -- BITTI | HATA | ATLANDI
    parmak_izi TEXT,                   -- adımın gördüğü girdi
    ayrinti    TEXT,
    zaman      TEXT NOT NULL,
    PRIMARY KEY (kod, adim)
);
CREATE TABLE yayin_kuyrugu (
            id            INTEGER PRIMARY KEY AUTOINCREMENT,
            kod           TEXT NOT NULL,
            icerik_yolu   TEXT,
            metin         TEXT NOT NULL,
            platformlar   TEXT NOT NULL,      -- JSON dizi
            medya         TEXT,               -- JSON dizi
            durum         TEXT NOT NULL,
            denetci_sonuc TEXT,               -- JSON
            gonderi_id    TEXT,               -- Postproxy id
            platform_durum TEXT,              -- JSON
            hata          TEXT,
            olusturma     TEXT NOT NULL,
            guncelleme    TEXT NOT NULL,
            gonderim      TEXT
        , zincir TEXT, baslik TEXT, kapak_url TEXT);
CREATE TABLE yayin_kuyrugu_gunluk (
            id      INTEGER PRIMARY KEY AUTOINCREMENT,
            kuyruk_id INTEGER NOT NULL,
            onceki  TEXT,
            durum   TEXT NOT NULL,
            sebep   TEXT,
            zaman   TEXT NOT NULL
        );
CREATE INDEX idx_ta_date ON technical_analysis(date);
CREATE INDEX idx_ta_skor ON technical_analysis(skor DESC);
CREATE INDEX idx_ta_symbol_date ON technical_analysis(symbol, date);
CREATE INDEX idx_ta_tavsiye ON technical_analysis(tavsiye);
CREATE INDEX ix_fund_gecmis_tarih ON fundamental_gecmis(gecerli_tarih);
CREATE INDEX ix_hat_ilerleme_gun ON hat_ilerleme(is_adi, gun);
CREATE UNIQUE INDEX ix_hat_kilit_tek_aktif
        ON hat_kilit(is_adi) WHERE durum = 'CALISIYOR';
CREATE INDEX ix_is_durum
            ON is_kuyrugu(durum, id);
CREATE UNIQUE INDEX ix_is_tek_aktif
            ON is_kuyrugu(is_tipi)
            WHERE durum IN ('BEKLIYOR', 'CALISIYOR');
CREATE INDEX ix_kap_konu ON kap_bildirim(konu);
CREATE INDEX ix_kap_sembol_tarih ON kap_bildirim(sembol, tarih);
CREATE INDEX ix_ohlcv_daily_uzun_date ON ohlcv_daily_uzun(date);
CREATE INDEX ix_pd_date ON piyasa_degeri(date);
CREATE INDEX ix_reel_baz_date ON ohlcv_daily_reel(baz, date);
CREATE INDEX ix_tarama_arsiv_kategori ON tarama_arsiv(kategori);
CREATE INDEX ix_tarama_arsiv_tarih ON tarama_arsiv(tarama_tarihi);
CREATE INDEX ix_yayin_kuyrugu_durum ON yayin_kuyrugu(durum, id);
CREATE UNIQUE INDEX ix_yayin_kuyrugu_tek_aktif
        ON yayin_kuyrugu(kod)
        WHERE durum IN ('TASLAK','DENETIMDE','ONAYDA','ONAYLANDI');
CREATE VIEW ohlcv_daily AS
SELECT
    rowid            AS id,
    symbol,
    date,
    COALESCE(open, aof) AS open,   -- ⚠️ AÇILIŞ DEĞİL, AOF (bkz. modül başlığı)
    high, low, close, volume
FROM ohlcv_daily_uzun;
