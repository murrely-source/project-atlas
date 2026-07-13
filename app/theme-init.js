"use strict";

(() => {
  const storageKey = "solaris-nexus-theme";

  function normalizeTheme(value) {
    return value === "light" ? "light" : "dark";
  }

  function readStoredTheme() {
    try {
      return normalizeTheme(window.localStorage.getItem(storageKey));
    } catch {
      return "dark";
    }
  }

  function storeTheme(theme) {
    try {
      window.localStorage.setItem(storageKey, normalizeTheme(theme));
    } catch {
      // The selected theme still applies for this page when storage is unavailable.
    }
  }

  function applyRootTheme(theme) {
    const normalizedTheme = normalizeTheme(theme);
    document.documentElement.dataset.theme = normalizedTheme;
    document.documentElement.style.colorScheme = normalizedTheme;
    return normalizedTheme;
  }

  window.SOLARIS_THEME = Object.freeze({
    storageKey,
    normalizeTheme,
    readStoredTheme,
    storeTheme,
    applyRootTheme
  });

  applyRootTheme(readStoredTheme());
})();
