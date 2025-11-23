// ALWAYS RUN FIREFOX IN PRIVATE BROWSING MODE
user_pref("browser.privatebrowsing.autostart", true);

// DISABLE HISTORY STORAGE
user_pref("places.history.enabled", false);

// DISABLE COOKIE PERSISTENCE (session-only)
user_pref("network.cookie.lifetimePolicy", 2);

// DISABLE DISK CACHE
user_pref("browser.cache.disk.enable", false);

// DISABLE FORM / SEARCH HISTORY
user_pref("browser.formfill.enable", false);

// DISABLE SESSION RESTORE
user_pref("browser.sessionstore.resume_from_crash", false);
