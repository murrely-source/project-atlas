"use strict";

(() => {
  const site = window.SOLARIS_SITE;
  const menuButton = document.querySelector("#site-menu-button");
  const navigation = document.querySelector("#site-navigation");
  const menuClose = document.querySelector("#site-menu-close");
  const backdrop = document.querySelector("#site-nav-backdrop");
  const desktopNavigation = window.matchMedia("(min-width: 768px)");
  let menuOpen = false;
  let lockedScrollPosition = 0;

  function populateText(selector, value) {
    document.querySelectorAll(selector).forEach((element) => {
      element.textContent = value;
    });
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

  function updateCurrentNavigation() {
    const currentHash = window.location.hash || "#home";
    document.querySelectorAll("[data-primary-navigation] a").forEach((link) => {
      if (link.getAttribute("href") === currentHash) {
        link.setAttribute("aria-current", "page");
      } else {
        link.removeAttribute("aria-current");
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
    navigation.classList.add("is-open");
    backdrop.hidden = false;
    document.body.classList.add("nav-open");
    menuButton.setAttribute("aria-expanded", "true");
    window.requestAnimationFrame(() => menuClose.focus());
  }

  function closeMenu(restoreFocus = true) {
    if (!menuOpen) {
      return;
    }
    menuOpen = false;
    navigation.classList.remove("is-open");
    backdrop.hidden = true;
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
    const focusable = [menuClose, ...navigation.querySelectorAll("a")];
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
  populateText("[data-product-name]", site.product.name);
  populateText("[data-product-expansion]", site.product.expansion);
  renderNavigation();
  updateCurrentNavigation();
  renderSolutions();
  renderLensCapabilities();

  menuButton.addEventListener("click", openMenu);
  menuClose.addEventListener("click", () => closeMenu());
  backdrop.addEventListener("click", () => closeMenu());
  navigation.addEventListener("keydown", trapMenuFocus);
  navigation.addEventListener("click", (event) => {
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
