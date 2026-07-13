#!/usr/bin/env ruby
# Static smoke checks for the Project Atlas prototype.
require "json"

root = File.expand_path("..", __dir__)
app = File.join(root, "app")
html = File.read(File.join(app, "index.html"), encoding: "UTF-8")
data = File.read(File.join(app, "data.js"), encoding: "UTF-8")
theme_init = File.read(File.join(app, "theme-init.js"), encoding: "UTF-8")
app_script = File.read(File.join(app, "app.js"), encoding: "UTF-8")
styles = File.read(File.join(app, "styles.css"), encoding: "UTF-8")
intelligence_path = File.join(app, "data", "intelligence.json")
intelligence = JSON.parse(File.read(intelligence_path, encoding: "UTF-8"))

failures = []
workspace_ids = data.scan(/\{ id: "([^"]+)", label:/).flatten
card_targets = data.scan(/destination: "([^"]+)"/).flatten
articles = intelligence.fetch("items")
article_ids = articles.map { |article| article.fetch("id") }
page_ids = html.scan(/<section id="([^"]+)" class="page(?: active)?">/).flatten
nav_targets = html.scan(/class="nav(?: active)?" data-page="([^"]+)"/).flatten
open_targets = html.scan(/data-open-page="([^"]+)"/).flatten
overview_targets = open_targets.first(card_targets.length)
asset_paths = html.scan(/(?:src|href)="((?:assets\/)?[^"\/]+\.(?:css|js|png))"/).flatten

failures << "workspace sections do not match structured workspace data" unless page_ids.sort == workspace_ids.sort
failures << "expected 14 unique workspaces including Standards & Learning, Notifications, and Settings" unless workspace_ids.length == 14 && !workspace_ids.include?("learning") && workspace_ids.include?("standards") && workspace_ids.include?("notifications") && workspace_ids.include?("settings")
failures << "sidebar navigation does not match structured workspace data" unless nav_targets.sort == workspace_ids.sort
failures << "a clickable control points to an unknown workspace" unless (open_targets - workspace_ids).empty?
failures << "overview cards do not match structured overview routing data" unless overview_targets.sort == card_targets.sort
failures << "expected nine overview cards" unless overview_targets.length == 9
failures << "HTML still contains inline style or script blocks" if html.match?(/<style|<script>/)
failures << "approved Solaris website is missing" unless html.include?("solarisadvisoryai.com")
failures << "approved public product title is missing" unless html.include?("<title>Solaris Nexus: Intelligence Platform</title>")
failures << "approved public product header is missing" unless html.include?("<h1>Solaris Nexus</h1><p>Intelligence Platform</p>")
failures << "theme initializer must load before the stylesheet" unless html.index('src="theme-init.js"') < html.index('href="styles.css"')
failures << "Settings Dark and Light controls are missing" unless html.include?('data-theme-choice="dark" aria-pressed="true"') && html.include?('data-theme-choice="light" aria-pressed="false"') && html.include?('role="group" aria-label="Settings theme"')
failures << "theme controls must exist exclusively in Settings" unless html.scan('data-theme-choice="dark"').length == 1 && html.scan('data-theme-choice="light"').length == 1 && !html.include?('aria-label="Color theme"')
failures << "accessible global search form is incomplete" unless html.include?('id="global-search" role="search"') && html.include?('<label class="visually-hidden" for="global-search-input">Search Solaris Nexus</label>') && html.include?('id="global-search-input" type="search"')
failures << "search icons are missing or malformed" unless html.scan('<svg class="search-icon').length == 2 && html.scan('<circle cx="11" cy="11" r="7">').length == 2 && html.scan('d="m16.5 16.5 4 4"').length == 2
failures << "header Notifications or Settings controls remain" if html.include?('id="header-notifications"') || html.include?('id="header-settings"')
failures << "global search mobile toggle is incomplete" unless html.include?('id="global-search-toggle" type="button" aria-label="Open global search" aria-expanded="false" aria-controls="global-search-field"')
search_scope_names = ["News", "Intelligence", "Standards", "Regulations", "Documents", "Skills Library", "DHF", "Board Decisions", "Atlas Backlog", "Executive Briefs", "Future client assessments"]
failures << "future global search scopes are incomplete" unless search_scope_names.all? { |scope| data.include?(scope) }
failures << "development banner remains in the header" if html.include?("Internal — Solaris Use Only")
failures << "global search placeholder behavior is missing" unless app_script.include?('globalSearch.addEventListener("submit"') && app_script.include?("Global search is not implemented in this release.")
failures << "mobile search expansion and Escape contracts are missing" unless app_script.include?('globalSearch.classList.add("is-expanded")') && app_script.include?('globalSearch.classList.remove("is-expanded")') && app_script.match?(/event\.key === "Escape".*?collapseGlobalSearch\(\)/m)
failures << "Notifications workspace is missing its explicit placeholder" unless html.include?('<section id="notifications" class="page">') && html.include?("Notification delivery, preferences, and history are not implemented in this release.")
failures << "Settings future category placeholders are incomplete" unless %w[Accessibility Dashboard Intelligence Account].all? { |category| html.include?("#{category} <span>Future</span>") }
failures << "future Settings controls must not be implemented" unless html.include?("No controls are implemented in this release.")
failures << "intelligence records remain embedded in data.js" if data.include?("demo-agentic-governance") || data.match?(/articles:\s*Object\.freeze\(\[\s*\{/m)
failures << "external intelligence loader contract is missing" unless data.include?('new URL("data/intelligence.json", document.baseURI)') && data.include?("window.ATLAS_DATA_READY") && data.include?("validateIntelligence")
failures << "graceful intelligence error contracts are incomplete" unless %w[MISSING MALFORMED EMPTY INVALID].all? { |code| data.include?("\"#{code}\"") } && app_script.include?("renderIntelligenceError")
failures << "theme storage key or localStorage persistence is missing" unless theme_init.include?('"solaris-nexus-theme"') && theme_init.include?("window.localStorage.getItem(storageKey)") && theme_init.include?("window.localStorage.setItem(storageKey")
failures << "Dark default and invalid-value fallback are missing" unless theme_init.include?('return value === "light" ? "light" : "dark"') && theme_init.match?(/catch \{\s+return "dark";/)
failures << "document-root theme application is missing" unless theme_init.include?("document.documentElement.dataset.theme = normalizedTheme")
failures << "theme controls are not wired for immediate switching" unless app_script.include?('choice.addEventListener("click", () => selectTheme(choice.dataset.themeChoice))') && app_script.include?("window.SOLARIS_THEME.applyRootTheme(theme)")
required_theme_tokens = %w[page-bg header-bg sidebar-bg panel-bg input-bg text text-muted border table-head-bg interactive-bg badge-ok-bg track-bg card-bg drawer-header-bg]
required_theme_tokens.each do |token|
  failures << "theme token missing: --#{token}" unless styles.scan("--#{token}:").length >= 2
end
failures << "light-theme root selector is missing" unless styles.include?(':root[data-theme="light"]')
failures << "article IDs must be present and unique" unless article_ids.length == 5 && article_ids.uniq.length == article_ids.length
required_article_fields = %w[id title source published url category readTime executiveSummary keyTakeaways whyItMatters businessImpact relatedStandards relatedSolarisModules recommendation evidenceQuality chairNotes bookmarked verified]
required_article_fields.each do |field|
  failures << "article data is missing required field: #{field}" unless articles.all? { |article| article.key?(field) }
end
failures << "drawer dialog semantics are missing" unless html.include?('role="dialog" aria-modal="true" aria-labelledby="drawer-title"')
failures << "safe new-tab source attributes are missing" unless html.include?('target="_blank" rel="noopener noreferrer"')
failures << "article selection is not wired to the selected record" unless app_script.include?('button.addEventListener("click", () => openDrawer(article, button))') && app_script.include?('setText("#drawer-title", article.title)')
verified_urls = articles.select { |article| article["verified"] }.map { |article| article["url"] }
failures << "verified governed URLs must use HTTPS" unless verified_urls.length == 5 && verified_urls.all? { |url| url.start_with?("https://") }
failures << "example.com placeholder URLs remain" if verified_urls.any? { |url| url.include?("example.com") }
failures << "governed items schema normalization is missing" unless data.include?("Array.isArray(payload.items) ? payload.items : payload.articles") && data.include?("normalizeArticle")
failures << "category array rendering or filtering is missing" unless app_script.include?('Categories: ${article.category.join(", ")}') && app_script.include?("categories.some((articleCategory) => articleCategory.includes(category))") && app_script.include?('renderTags("#drawer-categories", article.category)')
feed_ids = html.scan(/data-intelligence-feed="([^"]+)"/).flatten
failures << "contextual intelligence feeds are incomplete" unless feed_ids.sort == %w[human intelligence regulation standards]
failures << "reusable workspace feed component is missing" unless app_script.include?("function renderWorkspaceIntelligenceFeed(container)") && app_script.include?("createArticleTrigger(article, true)") && app_script.include?("article.verified !== true")
failures << "Standards & Learning route is missing or duplicated" unless html.include?('<section id="standards" class="page">') && html.include?("<h2>Standards &amp; Learning</h2>") && html.scan('data-page="standards"').length == 1 && !html.include?('id="learning" class="page"') && !html.include?('data-page="learning"')
standards_sections = ["Standards", "Professional Organizations", "Certifications", "Training &amp; Webinars", "Conferences &amp; Events", "Publications &amp; Guidance"]
failures << "Standards & Learning sections are incomplete" unless standards_sections.all? { |section| html.include?(section) }
failures << "Standards & Learning filters are incomplete" unless %w[organization contentType certification status recommendation].all? { |filter| html.include?("data-standards-filter=\"#{filter}\"") }
failures << "IAPP AIGP ecosystem or certification coverage is incomplete" unless data.scan("IAPP AIGP").length >= 2 && html.include?("professional AI governance ecosystem") && html.include?("certification and learning pathway")
failures << "News Desk does not initialize from external data" unless app_script.include?("await window.ATLAS_DATA_READY") && app_script.include?("atlasData = loadedData") && app_script.include?("renderArticles()")
failures << "drawer close, backdrop, or Escape behavior is missing" unless app_script.match?(/drawerClose\.addEventListener\("click", closeDrawer\).*drawerBackdrop\.addEventListener\("click", closeDrawer\)/m) && app_script.include?('event.key === "Escape"')
failures << "Return to News Desk control is missing or inaccessible" unless html.include?('id="drawer-return" type="button" aria-label="Return to News Desk">← Return to News Desk</button>') && styles.include?(".drawer-return:focus-visible")
failures << "context-aware drawer return does not preserve workspace state" unless app_script.include?('drawerReturn.addEventListener("click", returnToOriginWorkspace)') && app_script.include?("drawerOriginWorkspace") && app_script.include?("drawerOriginScrollPosition = window.scrollY") && app_script.include?('window.scrollTo({ top: scrollPosition, behavior: "auto" })')
failures << "Business Impact is missing from the shared drawer" unless html.include?('<p id="drawer-business-impact"></p>') && app_script.include?('setText("#drawer-business-impact", article.businessImpact')
failures << "unverified source handling is missing" unless app_script.include?('originalSource.removeAttribute("href")') && app_script.include?('originalSource.setAttribute("aria-disabled", "true")') && app_script.include?('sourcePending.hidden = false')

asset_paths.each do |relative_path|
  failures << "missing local asset: #{relative_path}" unless File.file?(File.join(app, relative_path))
end

unless failures.empty?
  failures.each { |message| warn "FAIL: #{message}" }
  exit 1
end

puts "PASS: Atlas static smoke checks"
puts "  #{workspace_ids.length} workspaces and #{card_targets.length} overview routes validated"
puts "  #{asset_paths.length} local assets resolved"
puts "  #{article_ids.length} unique governed articles and drawer safety contracts validated"
puts "  external intelligence JSON, loader, validator, and graceful failure contracts validated"
puts "  Dark/Light initialization, persistence, controls, and semantic token contracts validated"
