"use strict";

(() => {
  const site = window.SOLARIS_SITE;
  const menuButton = document.querySelector("#site-menu-button");
  const mobileOverlay = document.querySelector("#mobile-navigation-overlay");
  const mobileClose = document.querySelector("#mobile-navigation-close");
  const desktopNavigation = window.matchMedia("(min-width: 768px)");
  let menuOpen = false;
  let lockedScrollPosition = 0;

  function populateText(selector, value) {
    document.querySelectorAll(selector).forEach((element) => {
      element.textContent = value;
    });
  }

  function renderHeroTitle() {
    const heading = document.querySelector("[data-hero-company-name]");
    const words = site.companyDisplayName.trim().split(/\s+/);
    heading.replaceChildren(...words.map((word) => {
      const line = document.createElement("span");
      line.className = "hero-title-line";
      line.textContent = word;
      return line;
    }));
    heading.setAttribute("aria-label", site.companyDisplayName);
  }

  function renderNavigation() {
    document.querySelectorAll("[data-primary-navigation]").forEach((list) => {
      list.replaceChildren();
      site.navigation.forEach((item) => {
        const listItem = document.createElement("li");
        const link = document.createElement("a");
        link.href = item.href;
        link.textContent = item.label;
        if (item.href === "#home") {
          link.setAttribute("aria-current", "page");
        }
        listItem.append(link);
        list.append(listItem);
      });
    });
  }

  function renderMobileNavigation() {
    const list = document.querySelector("[data-mobile-navigation]");
    list.replaceChildren();
    site.navigation.forEach((item) => {
      const listItem = document.createElement("li");
      const link = document.createElement("a");
      link.className = "mobile-nav-link";
      link.href = item.href;
      link.textContent = item.label;
      listItem.append(link);
      list.append(listItem);
    });
  }

  function updateCurrentNavigation() {
    const currentHash = window.location.hash || "#home";
    document.querySelectorAll("[data-primary-navigation] a, [data-mobile-navigation] a").forEach((link) => {
      const linkIsCurrent = link.getAttribute("href") === currentHash;
      if (linkIsCurrent) {
        link.setAttribute("aria-current", "page");
      } else {
        link.removeAttribute("aria-current");
      }
      if (link.classList.contains("mobile-nav-link")) {
        link.classList.toggle("mobile-nav-link--active", linkIsCurrent);
      }
    });
  }

  function renderSolutions() {
    const container = document.querySelector("#solution-cards");
    site.solutions.forEach((solution, index) => {
      const article = document.createElement("article");
      article.className = "solution-card";
      const number = document.createElement("span");
      number.className = "card-number";
      number.textContent = String(index + 1).padStart(2, "0");
      const title = document.createElement("h3");
      title.textContent = solution.title;
      const description = document.createElement("p");
      description.textContent = solution.description;
      article.append(number, title, description);
      container.append(article);
    });
  }

  function renderLensCapabilities() {
    const list = document.querySelector("#lens-capabilities");
    site.lensCapabilities.forEach((capability) => {
      const item = document.createElement("li");
      item.textContent = capability;
      list.append(item);
    });
  }

  function openMenu() {
    if (desktopNavigation.matches || menuOpen) {
      return;
    }
    menuOpen = true;
    lockedScrollPosition = window.scrollY;
    document.body.style.top = `-${lockedScrollPosition}px`;
    mobileOverlay.hidden = false;
    mobileOverlay.setAttribute("aria-hidden", "false");
    document.body.classList.add("nav-open");
    menuButton.setAttribute("aria-expanded", "true");
    window.requestAnimationFrame(() => mobileClose.focus());
  }

  function closeMenu(restoreFocus = true) {
    if (!menuOpen) {
      return;
    }
    menuOpen = false;
    mobileOverlay.hidden = true;
    mobileOverlay.setAttribute("aria-hidden", "true");
    document.body.classList.remove("nav-open");
    document.body.style.top = "";
    window.scrollTo(0, lockedScrollPosition);
    menuButton.setAttribute("aria-expanded", "false");
    if (restoreFocus) {
      menuButton.focus();
    }
  }

  function trapMenuFocus(event) {
    if (event.key !== "Tab" || !menuOpen) {
      return;
    }
    const focusable = [mobileClose, ...mobileOverlay.querySelectorAll("a")];
    const first = focusable[0];
    const last = focusable[focusable.length - 1];
    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first.focus();
    }
  }

  populateText("[data-company-name]", site.companyDisplayName);
  populateText("[data-company-tagline]", site.tagline);
  renderHeroTitle();
  populateText("[data-product-name]", site.product.name);
  populateText("[data-product-expansion]", site.product.expansion);
  renderNavigation();
  renderMobileNavigation();
  updateCurrentNavigation();
  renderSolutions();
  renderLensCapabilities();

  menuButton.addEventListener("click", openMenu);
  mobileClose.addEventListener("click", () => closeMenu());
  mobileOverlay.addEventListener("keydown", trapMenuFocus);
  mobileOverlay.addEventListener("click", (event) => {
    if (event.target.closest("a")) {
      closeMenu();
    }
  });
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && menuOpen) {
      event.preventDefault();
      closeMenu();
    }
  });
  desktopNavigation.addEventListener("change", (event) => {
    if (event.matches) {
      closeMenu(false);
    }
  });
  window.addEventListener("hashchange", updateCurrentNavigation);
})();
