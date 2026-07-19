"use strict";

(() => {
  const site = window.SOLARIS_SITE;
  const menuButton = document.querySelector("#site-menu-button");
  const mobileOverlay = document.querySelector("#mobile-navigation-overlay");
  const mobileClose = document.querySelector("#mobile-navigation-close");
  const desktopNavigation = window.matchMedia("(min-width: 768px)");
  const backgroundContent = document.querySelectorAll(".skip-link, .site-header, main, .site-footer");
  const contactConfig = window.SOLARIS_CONTACT_CONFIG;
  const contactForm = document.querySelector("#contact-form");
  const contactSubmit = document.querySelector("#contact-submit");
  const contactStatus = document.querySelector("#contact-status");
  const contactSuccess = document.querySelector("#contact-success");
  const contactErrorSummary = document.querySelector("#contact-error-summary");
  const contactErrorList = document.querySelector("#contact-error-list");
  const contactTurnstileError = document.querySelector("#contact-turnstile-error");
  let menuOpen = false;
  let lockedScrollPosition = 0;
  let turnstileToken = "";
  let turnstileWidgetId = null;

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
    backgroundContent.forEach((element) => { element.inert = true; });
    document.body.classList.add("nav-open");
    menuButton.setAttribute("aria-expanded", "true");
    window.requestAnimationFrame(() => mobileClose.focus());
  }

  function closeMenu({ restoreFocus = true, restoreScroll = true } = {}) {
    if (!menuOpen) {
      return;
    }
    menuOpen = false;
    mobileOverlay.hidden = true;
    mobileOverlay.setAttribute("aria-hidden", "true");
    backgroundContent.forEach((element) => { element.inert = false; });
    document.body.classList.remove("nav-open");
    document.body.style.top = "";
    if (restoreScroll) {
      window.scrollTo(0, lockedScrollPosition);
    }
    menuButton.setAttribute("aria-expanded", "false");
    if (restoreFocus) {
      menuButton.focus({ preventScroll: true });
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

  function contactFieldMessage(field) {
    const value = field.value.trim();
    const requiredMessages = {
      fullName: "Enter your full name.",
      company: "Enter your company.",
      email: "Enter your email address.",
      subject: "Enter a subject.",
      message: "Enter your message."
    };

    if (field.required && value === "") {
      return requiredMessages[field.name];
    }
    if (field.name === "email" && field.validity.typeMismatch) {
      return "Enter a valid email address.";
    }
    return "";
  }

  function setContactFieldError(field, message) {
    const error = document.querySelector(`#${field.id}-error`);
    field.setAttribute("aria-invalid", message ? "true" : "false");
    error.textContent = message;
  }

  function clearContactErrorSummary() {
    contactErrorList.replaceChildren();
    contactErrorSummary.hidden = true;
  }

  function showContactErrorSummary(errors) {
    contactErrorList.replaceChildren(...errors.map((error) => {
      const item = document.createElement("li");
      const link = document.createElement("a");
      link.href = `#${error.id}`;
      link.textContent = error.message;
      item.append(link);
      return item;
    }));
    contactErrorSummary.hidden = false;
    contactErrorSummary.focus();
  }

  function validateContactForm() {
    const errors = [];
    contactForm.querySelectorAll("input, textarea").forEach((field) => {
      const message = contactFieldMessage(field);
      setContactFieldError(field, message);
      if (message) {
        errors.push({ id: field.id, message });
      }
    });

    const turnstileMessage = turnstileToken ? "" : "Complete the security verification.";
    contactTurnstileError.textContent = turnstileMessage;
    if (turnstileMessage) {
      errors.push({ id: "contact-turnstile", message: turnstileMessage });
    }
    return errors;
  }

  function setContactSubmitting(isSubmitting) {
    contactForm.setAttribute("aria-busy", String(isSubmitting));
    contactSubmit.disabled = isSubmitting;
    contactSubmit.textContent = isSubmitting ? "Sending..." : "Send Message";
    contactStatus.textContent = isSubmitting ? "Sending your message." : "";
  }

  function resetContactTurnstile() {
    turnstileToken = "";
    if (turnstileWidgetId !== null && window.turnstile) {
      window.turnstile.reset(turnstileWidgetId);
    }
  }

  function initializeContactTurnstile() {
    if (!contactForm || !contactConfig || !contactConfig.turnstileSiteKey || !window.turnstile || turnstileWidgetId !== null) {
      return;
    }

    turnstileWidgetId = window.turnstile.render("#contact-turnstile", {
      sitekey: contactConfig.turnstileSiteKey,
      size: "flexible",
      callback(token) {
        turnstileToken = token;
        contactTurnstileError.textContent = "";
      },
      "expired-callback"() {
        turnstileToken = "";
        contactTurnstileError.textContent = "Security verification expired. Please complete it again.";
      },
      "error-callback"() {
        turnstileToken = "";
        contactTurnstileError.textContent = "Security verification is temporarily unavailable. Please try again.";
      }
    });
  }

  window.onSolarisTurnstileReady = initializeContactTurnstile;

  function initializeContactForm() {
    if (!contactForm) {
      return;
    }

    contactForm.addEventListener("focusout", (event) => {
      if (event.target.matches("input, textarea")) {
        setContactFieldError(event.target, contactFieldMessage(event.target));
      }
    });

    contactForm.addEventListener("input", (event) => {
      if (event.target.matches("input, textarea") && event.target.getAttribute("aria-invalid") === "true") {
        setContactFieldError(event.target, contactFieldMessage(event.target));
      }
    });

    contactForm.addEventListener("submit", async (event) => {
      event.preventDefault();
      contactStatus.textContent = "";

      const errors = validateContactForm();
      if (errors.length > 0) {
        showContactErrorSummary(errors);
        return;
      }

      clearContactErrorSummary();
      const formData = new FormData(contactForm);
      const payload = {
        fullName: formData.get("fullName").trim(),
        company: formData.get("company").trim(),
        email: formData.get("email").trim(),
        phone: formData.get("phone").trim(),
        subject: formData.get("subject").trim(),
        message: formData.get("message").trim(),
        turnstileToken
      };

      setContactSubmitting(true);

      try {
        const response = await fetch(contactConfig.endpointUrl, {
          method: "POST",
          headers: { "Content-Type": "text/plain;charset=UTF-8" },
          body: JSON.stringify(payload),
          redirect: "follow"
        });
        let result;
        try {
          result = await response.json();
        } catch (_error) {
          throw new Error("The contact endpoint returned an unreadable response.");
        }

        if (!response.ok || result.status !== "success") {
          throw new Error("The contact endpoint did not accept the submission.");
        }

        contactForm.reset();
        resetContactTurnstile();
        contactForm.hidden = true;
        contactSuccess.hidden = false;
        contactSuccess.focus();
      } catch (error) {
        console.error("Contact submission failed.", error);
        contactStatus.textContent = "We couldn't send your message. Please try again in a few moments.";
        resetContactTurnstile();
      } finally {
        setContactSubmitting(false);
      }
    });
  }

  populateText("[data-company-name]", site.companyDisplayName);
  populateText("[data-company-tagline]", site.tagline);
  renderHeroTitle();
  populateText("[data-product-name]", site.product.name);
  populateText("[data-product-cta]", site.product.heroCtaLabel);
  populateText("[data-product-expansion]", site.product.expansion);
  renderNavigation();
  renderMobileNavigation();
  updateCurrentNavigation();
  renderSolutions();
  renderLensCapabilities();
  initializeContactForm();
  if (window.turnstile) {
    initializeContactTurnstile();
  }

  menuButton.addEventListener("click", openMenu);
  mobileClose.addEventListener("click", () => closeMenu());
  mobileOverlay.addEventListener("keydown", trapMenuFocus);
  mobileOverlay.addEventListener("click", (event) => {
    if (event.target === mobileOverlay) {
      closeMenu();
    } else if (event.target.closest("a")) {
      closeMenu({ restoreScroll: false });
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
      closeMenu({ restoreFocus: false });
    }
  });
  window.addEventListener("hashchange", updateCurrentNavigation);
})();
