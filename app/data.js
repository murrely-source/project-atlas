"use strict";

(() => {
  const intelligenceUrl = new URL("data/intelligence.json", document.baseURI).href;
  const requiredStringFields = Object.freeze([
    "id",
    "title",
    "source",
    "publishedDate",
    "estimatedReadingTime",
    "executiveSummary",
    "whyItMatters",
    "boardRecommendation",
    "evidenceQuality",
    "chairNotes"
  ]);
  const requiredArrayFields = Object.freeze([
    "keyTakeaways",
    "relatedStandards",
    "relatedSolarisModules"
  ]);

  class IntelligenceDataError extends Error {
    constructor(code, message) {
      super(message);
      this.name = "IntelligenceDataError";
      this.code = code;
    }
  }

  const baseData = Object.freeze({
    workspaces: Object.freeze([
      { id: "overview", label: "Overview" },
      { id: "ask", label: "Ask Nexus" },
      { id: "intelligence", label: "Intelligence Center" },
      { id: "settings", label: "Settings" }
    ]),
    overviewCards: Object.freeze([]),
    legacyNavigation: Object.freeze([
      { route: "news", label: "News Desk" },
      { route: "human", label: "Human Firewall™" },
      { route: "standards", label: "Standards & Learning" },
      { route: "regulation", label: "Regulatory Watch" },
      { route: "progress", label: "Progress & Milestones" },
      { route: "backlog", label: "Atlas Backlog" },
      { route: "documents", label: "Documents" },
      { route: "pending", label: "Board Queue" },
      { route: "dhf", label: "DHF / Decisions" },
      { route: "skills", label: "Skills Library" },
      { route: "notifications", label: "Notifications" }
    ]),
    legacyOverviewDestinations: Object.freeze(["intelligence", "news", "human", "standards", "regulation", "progress", "backlog", "pending", "documents"]),
    newsCategories: Object.freeze(["all", "governance", "human", "standards", "enterprise"]),
    workspaceIntelligence: Object.freeze({
      intelligence: Object.freeze({ allVerified: true, categories: Object.freeze([]) })
    }),
    legacyWorkspaceIntelligence: Object.freeze({
      standards: Object.freeze({ categories: Object.freeze(["Standards", "Official Guidance", "Implementation Guidance", "Standards Training", "Certification", "Training", "Webinar", "Conference", "Publication", "Exam Update", "Course Update"]) }),
      regulation: Object.freeze({ categories: Object.freeze(["Regulation", "Enforcement", "Consultation", "Legislation"]) }),
      human: Object.freeze({ categories: Object.freeze(["Human Impact", "AI Literacy", "Human Oversight", "Workforce Readiness"]) })
    }),
    standardsLearningFilters: Object.freeze({
      organization: Object.freeze(["NIST", "ISO / ISO/IEC", "OECD", "IEEE", "W3C", "CISA", "OWASP", "EU AI Office", "UK AI Safety Institute", "Singapore IMDA / AI Verify", "IAPP", "ISACA", "PMI"]),
      contentType: Object.freeze(["Standard", "Guidance", "Certification", "Training", "Webinar", "Conference", "Publication", "Exam Update", "Course Update"]),
      certification: Object.freeze(["IAPP AIGP", "ISACA AAIA", "ISO/IEC 42001 training and auditor pathways", "ISO 23894 learning", "ITIL AI Governance"]),
      status: Object.freeze(["New", "Updated", "Revised", "Registration Open", "Coming Soon", "Monitor"]),
      recommendation: Object.freeze(["Monitor", "Board Review", "Integration Candidate", "Archive / Reference"])
    }),
    standardsLearningOrganizationAliases: Object.freeze({
      "ISO / ISO/IEC": Object.freeze(["ISO", "ISO/IEC"]),
      "EU AI Office": Object.freeze(["EU AI Office", "European AI Office", "European Commission"]),
      "UK AI Safety Institute": Object.freeze(["UK AI Safety Institute", "AI Safety Institute"]),
      "Singapore IMDA / AI Verify": Object.freeze(["Singapore IMDA", "IMDA", "AI Verify"])
    }),
    standardsLearningSections: Object.freeze({
      standards: Object.freeze(["NIST", "ISO / ISO/IEC", "OECD", "IEEE", "W3C", "ISO 23894"]),
      organizations: Object.freeze(["CISA", "OWASP", "EU AI Office", "UK AI Safety Institute", "Singapore IMDA / AI Verify", "IAPP", "ISACA", "PMI"]),
      certifications: Object.freeze(["IAPP AIGP", "ISACA AAIA", "ISO/IEC 42001 auditor pathways"]),
      training: Object.freeze(["ISO/IEC 42001 training", "ISO 23894 learning", "ITIL AI Governance", "NIST training and webinars"]),
      events: Object.freeze(["Approved AI governance conferences and events"]),
      publications: Object.freeze(["Standards publications", "Official guidance", "Implementation guidance"])
    }),
    searchScopes: Object.freeze(["News", "Intelligence", "Standards & Learning", "Regulations", "Documents", "Skills Library", "DHF", "Board Decisions", "Atlas Backlog", "Executive Briefs", "Future client assessments"]),
    articles: Object.freeze([])
  });

  function assertNonEmptyString(value, field, articleId) {
    if (typeof value !== "string" || value.trim() === "") {
      throw new IntelligenceDataError("INVALID", `Article ${articleId} has an invalid ${field}.`);
    }
  }

  function normalizeCategory(category) {
    return Array.isArray(category) ? [...category] : [category];
  }

  function normalizeArticle(article) {
    const readTime = article.estimatedReadingTime ?? article.readTime;
    return {
      ...article,
      publishedDate: article.publishedDate ?? article.published,
      originalUrl: article.originalUrl ?? article.url ?? null,
      estimatedReadingTime: typeof readTime === "number" ? `${readTime} min` : readTime,
      boardRecommendation: article.boardRecommendation ?? article.recommendation,
      category: normalizeCategory(article.category),
      tags: Array.isArray(article.tags) ? [...article.tags] : [],
      relatedWorkspaces: Array.isArray(article.relatedWorkspaces) ? [...article.relatedWorkspaces] : []
    };
  }

  function validateArticle(sourceArticle, index) {
    if (!sourceArticle || typeof sourceArticle !== "object" || Array.isArray(sourceArticle)) {
      throw new IntelligenceDataError("INVALID", `Article at index ${index} is not an object.`);
    }
    const article = normalizeArticle(sourceArticle);

    const articleId = typeof article.id === "string" && article.id.trim() ? article.id : `index ${index}`;
    requiredStringFields.forEach((field) => {
      if (field === "chairNotes") {
        if (typeof article[field] !== "string") {
          throw new IntelligenceDataError("INVALID", `Article ${articleId} has an invalid ${field}.`);
        }
        return;
      }
      assertNonEmptyString(article[field], field, articleId);
    });

    requiredArrayFields.forEach((field) => {
      if (!Array.isArray(article[field]) || article[field].some((value) => typeof value !== "string" || value.trim() === "")) {
        throw new IntelligenceDataError("INVALID", `Article ${articleId} has an invalid ${field}.`);
      }
    });

    if (!Array.isArray(article.category) || article.category.length === 0 || article.category.some((value) => typeof value !== "string" || value.trim() === "")) {
      throw new IntelligenceDataError("INVALID", `Article ${articleId} has an invalid category.`);
    }

    if (article.originalUrl !== null) {
      assertNonEmptyString(article.originalUrl, "originalUrl", articleId);
      let parsedUrl;
      try {
        parsedUrl = new URL(article.originalUrl);
      } catch {
        throw new IntelligenceDataError("INVALID", `Article ${articleId} has an invalid originalUrl.`);
      }
      if (parsedUrl.protocol !== "https:") {
        throw new IntelligenceDataError("INVALID", `Article ${articleId} originalUrl must use HTTPS.`);
      }
    }

    if (typeof article.bookmarked !== "boolean") {
      throw new IntelligenceDataError("INVALID", `Article ${articleId} has an invalid bookmarked value.`);
    }

    if (Object.prototype.hasOwnProperty.call(article, "verified") && typeof article.verified !== "boolean") {
      throw new IntelligenceDataError("INVALID", `Article ${articleId} has an invalid verified value.`);
    }

    if (article.verified === true && article.originalUrl === null) {
      throw new IntelligenceDataError("INVALID", `Verified article ${articleId} must include an originalUrl.`);
    }

    return Object.freeze({
      ...article,
      category: Object.freeze([...article.category]),
      tags: Object.freeze([...article.tags]),
      relatedWorkspaces: Object.freeze([...article.relatedWorkspaces]),
      keyTakeaways: Object.freeze([...article.keyTakeaways]),
      relatedStandards: Object.freeze([...article.relatedStandards]),
      relatedSolarisModules: Object.freeze([...article.relatedSolarisModules])
    });
  }

  function validateIntelligence(payload) {
    if (!payload || typeof payload !== "object" || Array.isArray(payload)) {
      throw new IntelligenceDataError("INVALID", "The intelligence dataset must be a JSON object.");
    }
    const sourceArticles = Array.isArray(payload.items) ? payload.items : payload.articles;
    if (!Array.isArray(sourceArticles)) {
      throw new IntelligenceDataError("INVALID", "The intelligence dataset must contain an items or articles array.");
    }
    if (sourceArticles.length === 0) {
      throw new IntelligenceDataError("EMPTY", "The intelligence dataset contains no articles.");
    }

    const articles = sourceArticles.map(validateArticle);
    const ids = new Set();
    articles.forEach((article) => {
      if (ids.has(article.id)) {
        throw new IntelligenceDataError("INVALID", `Duplicate article ID: ${article.id}.`);
      }
      ids.add(article.id);
    });

    return Object.freeze(articles);
  }

  function loadFileUrl(url) {
    return new Promise((resolve, reject) => {
      const request = new XMLHttpRequest();
      request.open("GET", url, true);
      request.onload = () => {
        if ((request.status >= 200 && request.status < 300) || (request.status === 0 && request.responseText)) {
          resolve(request.responseText);
        } else {
          reject(new IntelligenceDataError("MISSING", "The intelligence dataset could not be loaded."));
        }
      };
      request.onerror = () => reject(new IntelligenceDataError("MISSING", "The intelligence dataset could not be loaded."));
      request.send();
    });
  }

  async function loadDatasetText(url) {
    if (window.location.protocol === "file:") {
      return loadFileUrl(url);
    }

    try {
      const response = await fetch(url, { cache: "no-store" });
      if (!response.ok) {
        throw new IntelligenceDataError("MISSING", "The intelligence dataset could not be loaded.");
      }
      return await response.text();
    } catch (error) {
      if (error instanceof IntelligenceDataError) {
        throw error;
      }
      throw new IntelligenceDataError("MISSING", "The intelligence dataset could not be loaded.");
    }
  }

  async function loadIntelligence() {
    const datasetText = await loadDatasetText(intelligenceUrl);
    let payload;
    try {
      payload = JSON.parse(datasetText);
    } catch {
      throw new IntelligenceDataError("MALFORMED", "The intelligence dataset contains malformed JSON.");
    }

    const articles = validateIntelligence(payload);
    const loadedData = Object.freeze({ ...baseData, articles });
    window.ATLAS_DATA = loadedData;
    window.ATLAS_DATA_ERROR = null;
    return loadedData;
  }

  window.ATLAS_DATA = baseData;
  window.ATLAS_DATA_ERROR = null;
  window.ATLAS_DATA_LOADER = Object.freeze({
    intelligenceUrl,
    loadIntelligence,
    normalizeArticle,
    validateIntelligence
  });
  window.ATLAS_DATA_READY = loadIntelligence().catch((error) => {
    window.ATLAS_DATA_ERROR = error instanceof IntelligenceDataError
      ? error
      : new IntelligenceDataError("MISSING", "The intelligence dataset could not be loaded.");
    return null;
  });
})();
