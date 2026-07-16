"use strict";

let atlasData = window.ATLAS_DATA;
const primaryPageIds = ["overview", "ask", "intelligence", "settings"];
const pages = primaryPageIds.map((id) => document.getElementById(id));
const nav = [...document.querySelectorAll(".nav")];
const articleList = document.querySelector("#article-list");
const overviewHeadlines = document.querySelector("#overview-headlines");
const workspaceIntelligenceFeeds = [...document.querySelectorAll("#intelligence [data-intelligence-feed]")];
const standardsFilters = [...document.querySelectorAll("#intelligence [data-standards-filter]")];
const drawerLayer = document.querySelector("#intelligence-drawer-layer");
const drawer = document.querySelector("#intelligence-drawer");
const drawerReturn = document.querySelector("#drawer-return");
const drawerClose = document.querySelector("#drawer-close");
const drawerBackdrop = document.querySelector("#drawer-backdrop");
const bookmarkControl = document.querySelector("#bookmark-control");
const chairNotes = document.querySelector("#chair-notes");
const originalSource = document.querySelector("#original-source");
const sourcePending = document.querySelector("#source-pending");
const themeChoices = [...document.querySelectorAll("[data-theme-choice]")];
const themeStatus = document.querySelector("#theme-status");
const menuToggle = document.querySelector("#menu-toggle");
const menuClose = document.querySelector("#menu-close");
const workspaceNavigation = document.querySelector("#workspace-navigation");
const navBackdrop = document.querySelector("#nav-backdrop");
const desktopNavigationQuery = window.matchMedia("(min-width: 768px)");
const askNexusForm = document.querySelector("#ask-nexus-form");
const askNexusStatus = document.querySelector("#ask-nexus-status");

let selectedArticle = null;
let selectedArticleTrigger = null;
let mobileMenuOpen = false;
let activeIntelligenceCategory = "all";
const activeStandardsFilters = { organization: "all", contentType: "all", certification: "all", status: "all", recommendation: "all" };
let drawerOriginWorkspace = "intelligence";
let drawerOriginScrollPosition = 0;
const sessionFallback = new Map();

function openMobileMenu() {
  if (desktopNavigationQuery.matches || mobileMenuOpen) {
    return;
  }

  mobileMenuOpen = true;
  workspaceNavigation.classList.add("is-open");
  navBackdrop.hidden = false;
  document.body.classList.add("nav-open");
  menuToggle.setAttribute("aria-expanded", "true");
  window.requestAnimationFrame(() => {
    menuClose.focus();
  });
}

function closeMobileMenu(restoreFocus = true) {
  if (!mobileMenuOpen) {
    return;
  }

  mobileMenuOpen = false;
  workspaceNavigation.classList.remove("is-open");
  navBackdrop.hidden = true;
  document.body.classList.remove("nav-open");
  menuToggle.setAttribute("aria-expanded", "false");
  if (restoreFocus) {
    menuToggle.focus();
  }
}

function handleMobileNavigationKeydown(event) {
  if (event.key !== "Tab" || !mobileMenuOpen) {
    return;
  }

  const first = menuClose;
  const last = nav[nav.length - 1];
  if (event.shiftKey && document.activeElement === first) {
    event.preventDefault();
    last.focus();
  } else if (!event.shiftKey && document.activeElement === last) {
    event.preventDefault();
    first.focus();
  }
}

function updateThemeControls(theme, announce = false) {
  themeChoices.forEach((choice) => {
    choice.setAttribute("aria-pressed", String(choice.dataset.themeChoice === theme));
  });
  themeStatus.textContent = `Current theme: ${theme === "light" ? "Light" : "Dark"}`;
  if (!announce) {
    themeStatus.setAttribute("aria-live", "off");
    window.requestAnimationFrame(() => themeStatus.setAttribute("aria-live", "polite"));
  }
}

function selectTheme(theme) {
  const selectedTheme = window.SOLARIS_THEME.applyRootTheme(theme);
  window.SOLARIS_THEME.storeTheme(selectedTheme);
  updateThemeControls(selectedTheme, true);
}

function readSession(key, fallbackValue) {
  try {
    const value = window.sessionStorage.getItem(key);
    return value === null ? fallbackValue : JSON.parse(value);
  } catch {
    return sessionFallback.has(key) ? sessionFallback.get(key) : fallbackValue;
  }
}

function writeSession(key, value) {
  try {
    window.sessionStorage.setItem(key, JSON.stringify(value));
  } catch {
    sessionFallback.set(key, value);
  }
}

function openPage(id) {
  if (!atlasData.workspaces.some((workspace) => workspace.id === id)) {
    return;
  }

  if (!drawerLayer.hidden) {
    closeDrawer();
  }

  activatePage(id);
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function activatePage(id) {
  pages.forEach((page) => page.classList.toggle("active", page.id === id));
  nav.forEach((item) => item.classList.toggle("active", item.dataset.page === id));
}

function badgeClass(recommendation) {
  if (recommendation.startsWith("Integration")) {
    return "act";
  }
  if (recommendation.startsWith("Archive")) {
    return "ok";
  }
  return "watch";
}

function renderArticles() {
  articleList.replaceChildren();
  atlasData.articles.forEach((article) => {
    const row = document.createElement("article");
    row.className = "intel item";
    row.dataset.cat = article.category.map((category) => category.toLowerCase()).join("|");
    const button = createArticleTrigger(article);
    row.append(button);
    articleList.append(row);
  });
  articleList.setAttribute("aria-busy", "false");
  filterIntelligence(activeIntelligenceCategory);
}

function renderOverviewHeadlines() {
  overviewHeadlines.replaceChildren();
  atlasData.articles.filter((article) => article.verified === true).slice(0, 3).forEach((article) => {
    const item = document.createElement("article");
    item.className = "workspace-feed-item";
    item.append(createArticleTrigger(article, true));
    overviewHeadlines.append(item);
  });
  overviewHeadlines.setAttribute("aria-busy", "false");
}

function createArticleTrigger(article, compact = false) {
  const button = document.createElement("button");
  button.className = compact ? "article-trigger workspace-feed-trigger" : "article-trigger";
  button.type = "button";
  button.dataset.articleId = article.id;
  button.setAttribute("aria-haspopup", "dialog");

  const title = document.createElement("h4");
  title.textContent = article.title;
  const summary = document.createElement("span");
  summary.className = "small";
  summary.textContent = article.executiveSummary.replace("Demonstration analysis: ", "");
  const meta = document.createElement("span");
  meta.className = "article-row-meta";
  meta.textContent = `${article.source} • ${article.estimatedReadingTime}`;
  const categories = document.createElement("span");
  categories.className = "small article-categories";
  categories.textContent = `Categories: ${article.category.join(", ")}`;
  const badge = document.createElement("span");
  badge.className = `badge ${badgeClass(article.boardRecommendation)}`;
  badge.textContent = article.boardRecommendation.split(" — ")[0];

  button.append(title, summary, meta, categories, badge);
  button.addEventListener("click", () => openDrawer(article, button));
  return button;
}

function normalizedSearchValues(article) {
  return [
    ...article.category,
    ...article.tags,
    ...article.relatedWorkspaces,
    ...article.relatedStandards,
    ...article.relatedSolarisModules,
    article.title,
    article.source,
    article.organization,
    article.contentType,
    article.certification,
    article.status,
    article.boardRecommendation
  ].filter((value) => typeof value === "string").map((value) => value.toLowerCase());
}

function matchesWorkspaceIntelligence(article, workspaceId) {
  if (article.verified !== true) {
    return false;
  }
  const mapping = atlasData.workspaceIntelligence[workspaceId];
  if (!mapping) {
    return false;
  }
  if (mapping.allVerified) {
    return true;
  }
  if (article.relatedWorkspaces.some((workspace) => workspace.toLowerCase() === workspaceId)) {
    return true;
  }
  const values = normalizedSearchValues(article);
  return mapping.categories.some((category) => values.includes(category.toLowerCase()));
}

function matchesStandardsFilters(article) {
  const values = normalizedSearchValues(article);
  return Object.entries(activeStandardsFilters).every(([filterName, selectedValue]) => {
    if (selectedValue === "all") {
      return true;
    }
    const normalizedValue = selectedValue.toLowerCase();
    if (filterName === "recommendation") {
      return article.boardRecommendation.toLowerCase() === normalizedValue;
    }
    if (filterName === "status") {
      return typeof article.status === "string" && article.status.toLowerCase() === normalizedValue;
    }
    if (filterName === "organization") {
      const aliases = atlasData.standardsLearningOrganizationAliases[selectedValue] || [selectedValue];
      return aliases.some((alias) => values.some((value) => value.includes(alias.toLowerCase())));
    }
    return values.some((value) => value.includes(normalizedValue));
  });
}

function renderWorkspaceIntelligenceFeed(container) {
  const workspaceId = container.dataset.intelligenceFeed;
  const records = atlasData.articles.filter((article) => matchesWorkspaceIntelligence(article, workspaceId))
    .filter((article) => workspaceId !== "standards" || matchesStandardsFilters(article));
  container.replaceChildren();

  if (records.length === 0) {
    const emptyState = document.createElement("p");
    emptyState.className = "workspace-feed-empty";
    emptyState.textContent = "No verified governed intelligence records match this workspace yet.";
    container.append(emptyState);
    return;
  }

  records.forEach((article) => {
    const item = document.createElement("article");
    item.className = "workspace-feed-item";
    item.append(createArticleTrigger(article, true));
    container.append(item);
  });
}

function renderWorkspaceIntelligenceFeeds() {
  workspaceIntelligenceFeeds.forEach(renderWorkspaceIntelligenceFeed);
}

function populateSelect(select, values) {
  values.forEach((value) => {
    const option = document.createElement("option");
    option.value = value;
    option.textContent = value;
    select.append(option);
  });
}

function initializeStandardsLearningWorkspace() {
  standardsFilters.forEach((select) => {
    populateSelect(select, atlasData.standardsLearningFilters[select.dataset.standardsFilter]);
  });
  document.querySelectorAll("#intelligence [data-monitoring-section]").forEach((container) => {
    const values = atlasData.standardsLearningSections[container.dataset.monitoringSection];
    values.forEach((value) => {
      const item = document.createElement("span");
      item.textContent = value;
      container.append(item);
    });
  });
}

function filterStandardsIntelligence(select) {
  activeStandardsFilters[select.dataset.standardsFilter] = select.value;
  filterIntelligence(activeIntelligenceCategory);
}

function renderIntelligenceError(error) {
  const messages = {
    MISSING: "The intelligence dataset could not be loaded.",
    MALFORMED: "The intelligence dataset is not valid JSON.",
    EMPTY: "The intelligence dataset contains no records.",
    INVALID: "The intelligence dataset did not pass validation."
  };
  const state = document.createElement("div");
  state.className = "data-state";
  state.setAttribute("role", "alert");
  const title = document.createElement("h4");
  title.textContent = "Intelligence unavailable";
  const message = document.createElement("p");
  message.textContent = messages[error?.code] || messages.MISSING;
  state.append(title, message);
  articleList.replaceChildren(state);
  articleList.setAttribute("aria-busy", "false");
  overviewHeadlines.replaceChildren(state.cloneNode(true));
  overviewHeadlines.setAttribute("aria-busy", "false");
}

async function initializeIntelligence() {
  initializeStandardsLearningWorkspace();
  const loadedData = await window.ATLAS_DATA_READY;
  if (!loadedData) {
    renderIntelligenceError(window.ATLAS_DATA_ERROR);
    return;
  }
  atlasData = loadedData;
  renderArticles();
  renderOverviewHeadlines();
  renderWorkspaceIntelligenceFeeds();
}

function filterIntelligence(category) {
  activeIntelligenceCategory = category;
  document.querySelectorAll(".filter").forEach((filter) => {
    filter.classList.toggle("active", filter.dataset.cat === category);
  });

  articleList.querySelectorAll(".intel").forEach((item) => {
    const article = atlasData.articles.find((record) => record.id === item.querySelector("[data-article-id]")?.dataset.articleId);
    const categories = item.dataset.cat.split("|");
    const categoryMatches = category === "all" || categories.some((articleCategory) => articleCategory.includes(category));
    item.hidden = !article || !categoryMatches || !matchesStandardsFilters(article);
  });
}

function setText(id, value) {
  document.querySelector(id).textContent = value;
}

function renderList(id, values) {
  const list = document.querySelector(id);
  list.replaceChildren();
  values.forEach((value) => {
    const item = document.createElement("li");
    item.textContent = value;
    list.append(item);
  });
}

function renderTags(id, values) {
  const container = document.querySelector(id);
  container.replaceChildren();
  values.forEach((value) => {
    const tag = document.createElement("span");
    tag.textContent = value;
    container.append(tag);
  });
}

function updateBookmarkControl(isBookmarked) {
  bookmarkControl.setAttribute("aria-pressed", String(isBookmarked));
  bookmarkControl.textContent = isBookmarked ? "★ Bookmarked" : "☆ Bookmark";
}

function configureSourceLink(article) {
  const sourceIsVerified = article.verified !== false;
  if (article.originalUrl && sourceIsVerified) {
    originalSource.href = article.originalUrl;
    originalSource.removeAttribute("aria-disabled");
    originalSource.removeAttribute("tabindex");
    sourcePending.hidden = true;
    return;
  }

  originalSource.removeAttribute("href");
  originalSource.setAttribute("aria-disabled", "true");
  originalSource.tabIndex = -1;
  sourcePending.hidden = false;
}

function openDrawer(article, trigger) {
  selectedArticle = article;
  selectedArticleTrigger = trigger;
  drawerOriginWorkspace = trigger.closest(".page")?.id || "intelligence";
  drawerOriginScrollPosition = window.scrollY;
  const originLabel = atlasData.workspaces.find((workspace) => workspace.id === drawerOriginWorkspace)?.label || "Intelligence Center";
  drawerReturn.textContent = `← Return to ${originLabel}`;
  drawerReturn.setAttribute("aria-label", `Return to ${originLabel}`);

  setText("#drawer-source", article.source);
  setText("#drawer-title", article.title);
  setText("#drawer-published", `Published ${article.publishedDate}`);
  setText("#drawer-reading-time", article.estimatedReadingTime);
  setText("#drawer-evidence", `Evidence: ${article.evidenceQuality}`);
  setText("#drawer-summary", article.executiveSummary);
  setText("#drawer-why", article.whyItMatters);
  setText("#drawer-business-impact", article.businessImpact || "Not specified in this governed record.");
  setText("#drawer-recommendation", article.boardRecommendation);
  renderList("#drawer-takeaways", article.keyTakeaways);
  renderTags("#drawer-standards", article.relatedStandards);
  renderTags("#drawer-modules", article.relatedSolarisModules);
  renderTags("#drawer-categories", article.category);

  chairNotes.value = readSession(`atlas-notes-${article.id}`, article.chairNotes);
  updateBookmarkControl(readSession(`atlas-bookmark-${article.id}`, article.bookmarked));
  configureSourceLink(article);

  drawerLayer.hidden = false;
  document.body.classList.add("drawer-open");
  window.requestAnimationFrame(() => {
    drawerLayer.classList.add("is-open");
    drawerClose.focus();
  });
}

function closeDrawer() {
  if (drawerLayer.hidden) {
    return;
  }

  drawerLayer.classList.remove("is-open");
  document.body.classList.remove("drawer-open");
  drawerLayer.hidden = true;
  selectedArticle = null;

  if (selectedArticleTrigger?.isConnected) {
    selectedArticleTrigger.focus();
  }
  selectedArticleTrigger = null;
}

function returnToOriginWorkspace() {
  const scrollPosition = drawerOriginScrollPosition;
  activatePage(drawerOriginWorkspace);
  closeDrawer();
  window.requestAnimationFrame(() => {
    window.scrollTo({ top: scrollPosition, behavior: "auto" });
  });
}

function drawerFocusableElements() {
  return [...drawer.querySelectorAll('button:not([disabled]), a[href], textarea, [tabindex]:not([tabindex="-1"])')]
    .filter((element) => !element.hidden);
}

function handleDrawerKeydown(event) {
  if (event.key === "Escape") {
    event.preventDefault();
    closeDrawer();
    return;
  }

  if (event.key !== "Tab") {
    return;
  }

  const focusable = drawerFocusableElements();
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

initializeIntelligence();
updateThemeControls(document.documentElement.dataset.theme);

themeChoices.forEach((choice) => {
  choice.addEventListener("click", () => selectTheme(choice.dataset.themeChoice));
});

menuToggle.addEventListener("click", () => {
  if (mobileMenuOpen) {
    closeMobileMenu();
  } else {
    openMobileMenu();
  }
});
navBackdrop.addEventListener("click", () => closeMobileMenu());
menuClose.addEventListener("click", () => closeMobileMenu());
workspaceNavigation.addEventListener("keydown", handleMobileNavigationKeydown);
desktopNavigationQuery.addEventListener("change", (event) => {
  if (event.matches) {
    closeMobileMenu(false);
  }
});
document.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && mobileMenuOpen) {
    event.preventDefault();
    closeMobileMenu();
  }
});

nav.forEach((item) => {
  item.addEventListener("click", () => {
    openPage(item.dataset.page);
    closeMobileMenu();
  });
});

document.querySelectorAll("[data-open-page]").forEach((element) => {
  element.addEventListener("click", () => openPage(element.dataset.openPage));
});

document.querySelectorAll(".filter").forEach((filter) => {
  filter.addEventListener("click", () => filterIntelligence(filter.dataset.cat));
});

standardsFilters.forEach((filter) => {
  filter.addEventListener("change", () => filterStandardsIntelligence(filter));
});

askNexusForm.addEventListener("submit", (event) => {
  event.preventDefault();
  askNexusStatus.textContent = "Model connectivity is not implemented in this preview. No prompt was sent.";
});

drawerClose.addEventListener("click", closeDrawer);
drawerBackdrop.addEventListener("click", closeDrawer);
drawerReturn.addEventListener("click", returnToOriginWorkspace);
drawer.addEventListener("keydown", handleDrawerKeydown);

chairNotes.addEventListener("input", () => {
  if (selectedArticle) {
    writeSession(`atlas-notes-${selectedArticle.id}`, chairNotes.value);
  }
});

bookmarkControl.addEventListener("click", () => {
  if (!selectedArticle) {
    return;
  }

  const key = `atlas-bookmark-${selectedArticle.id}`;
  const isBookmarked = !readSession(key, selectedArticle.bookmarked);
  writeSession(key, isBookmarked);
  updateBookmarkControl(isBookmarked);
});
