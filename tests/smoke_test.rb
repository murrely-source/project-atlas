#!/usr/bin/env ruby
# Static smoke checks for the Project Atlas prototype.
require "json"
require "digest"

root = File.expand_path("..", __dir__)
app = File.join(root, "app")
html = File.read(File.join(app, "index.html"), encoding: "UTF-8")
data = File.read(File.join(app, "data.js"), encoding: "UTF-8")
theme_init = File.read(File.join(app, "theme-init.js"), encoding: "UTF-8")
app_script = File.read(File.join(app, "app.js"), encoding: "UTF-8")
styles = File.read(File.join(app, "styles.css"), encoding: "UTF-8")
intelligence_path = File.join(app, "data", "intelligence.json")
intelligence = JSON.parse(File.read(intelligence_path, encoding: "UTF-8"))
approved_lockup_source = File.join(app, "assets", "brand", "solaris-labs-approved-theme-lockups.png")
dark_lockup = File.join(app, "assets", "brand", "solaris-labs-lockup-dark-v4.png")
light_lockup = File.join(app, "assets", "brand", "solaris-labs-lockup-light-v4.png")

def png_dimensions(path)
  File.binread(path, 24).byteslice(16, 8).unpack("NN")
end

failures = []
workspace_ids = data.scan(/\{ id: "([^"]+)", label:/).flatten
card_targets = data.scan(/destination: "([^"]+)"/).flatten
articles = intelligence.fetch("items")
article_ids = articles.map { |article| article.fetch("id") }
page_ids = html.scan(/<section id="([^"]+)" class="page(?: active)?">/).flatten
nav_targets = html.scan(/class="nav(?: active)?" data-page="([^"]+)"/).flatten
open_targets = html.scan(/data-open-page="([^"]+)"/).flatten
overview_targets = open_targets.first(card_targets.length)
asset_paths = html.scan(/(?:src|href)="((?:assets\/[^\"]+|[^"\/]+)\.(?:css|js|png))"/).flatten

failures << "approved primary workspace data changed" unless workspace_ids == %w[overview ask intelligence settings]
failures << "a primary workspace section is missing" unless (workspace_ids - page_ids).empty?
failures << "sidebar navigation does not match structured workspace data" unless nav_targets.sort == workspace_ids.sort
failures << "a clickable control points to an unknown workspace" unless (open_targets - workspace_ids).empty?
failures << "legacy overview routing data remains" unless card_targets.empty?
failures << "Overview high-level sections are incomplete" unless ["Top AI Headlines", "Continue a Previous Nexus Conversation", "Notifications"].all? { |label| html.include?(label) }
failures << "HTML still contains inline style or script blocks" if html.match?(/<style|<script>/)
failures << "approved public product title is missing" unless html.include?("<title>Solaris Nexus: Intelligence Platform</title>")
failures << "approved public product header is missing" unless html.include?("<h1>Solaris Nexus</h1><p>Intelligence Platform</p>")
lockup_alt = "Solaris Labs — Technology for Human-Centered AI"
failures << "Solaris Labs corporate identity is missing" unless html.include?(%(<div class="brand-lockup" role="img" aria-label="#{lockup_alt}">)) && html.include?(%(src="assets/brand/solaris-labs-lockup-dark-v4.png" alt="#{lockup_alt}")) && html.include?(%(src="assets/brand/solaris-labs-lockup-light-v4.png" alt="#{lockup_alt}"))
failures << "stale Solaris Labs lockup references remain" if html.match?(/src="assets\/brand\/solaris-labs-lockup-(?:dark|light)(?:-v3)?\.png"/)
failures << "duplicate standalone Solaris Labs monogram remains" if html.include?("brand-symbol") || html.include?("solaris-labs-monogram-transparent-512.png")
failures << "Chair-approved Solaris Labs source image was altered" unless File.file?(approved_lockup_source) && Digest::SHA256.file(approved_lockup_source).hexdigest == "177fafebec8f5cf54eb0b17825f0c2472fc8e36d805b198f5a7ef777c485a508"
failures << "Solaris Labs production crops do not retain their native 1385x255 dimensions" unless [dark_lockup, light_lockup].all? { |path| File.file?(path) && png_dimensions(path) == [1385, 255] }
failures << "legacy advisory identity remains in the corporate header" if html.match?(/<header class="top">.*?AI RISK &amp; GOVERNANCE ADVISORY/m)
failures << "corporate identity is not theme-aware" unless styles.include?(":root[data-theme=\"light\"] .brand-lockup-dark { display: none; }") && styles.include?(":root[data-theme=\"light\"] .brand-lockup-light { display: block; }")
failures << "Solaris Labs lockup proportions are not preserved" unless styles.include?(".brand-lockup-image { display: block; width: 100%; height: auto; object-fit: contain; }")
failures << "a CSS filter is altering the Solaris Labs lockup" if styles.match?(/\.brand-lockup(?:-image|-dark|-light)?[^}]*filter:/)
failures << "future Solaris Labs ecosystem website and product switcher backlog item is missing" unless html.include?("Solaris Labs ecosystem website and product switcher")
failures << "theme initializer must load before the stylesheet" unless html.index('src="theme-init.js"') < html.index('href="styles.css"')
failures << "Settings Dark and Light controls are missing" unless html.include?('data-theme-choice="dark" aria-pressed="true"') && html.include?('data-theme-choice="light" aria-pressed="false"') && html.include?('role="group" aria-label="Settings theme"')
failures << "theme controls must exist exclusively in Settings" unless html.scan('data-theme-choice="dark"').length == 1 && html.scan('data-theme-choice="light"').length == 1 && !html.include?('aria-label="Color theme"')
approved_footer = "© 2026 Powered by Solaris Labs - Technology for Human-Centered AI"
failures << "approved footer text or structure changed" unless html.include?("<footer class=\"footer\">#{approved_footer}</footer>") && html.scan(approved_footer).length == 1
failures << "global search interface remains" if html.match?(/global-search|Search Solaris Nexus|search-icon/)
failures << "header Notifications or Settings controls remain" if html.include?('id="header-notifications"') || html.include?('id="header-settings"')
search_scope_names = ["News", "Intelligence", "Standards", "Regulations", "Documents", "Skills Library", "DHF", "Board Decisions", "Atlas Backlog", "Executive Briefs", "Future client assessments"]
failures << "unexposed legacy search-scope information was deleted" unless data.include?("legacySearchScopes") && search_scope_names.all? { |scope| data.include?(scope) }
failures << "development banner remains in the header" if html.include?("Internal — Solaris Use Only")
failures << "obsolete global search behavior remains" if app_script.match?(/globalSearch|Global search|expandGlobalSearch|collapseGlobalSearch/)
failures << "Notifications workspace is missing its explicit placeholder" unless html.include?('<section id="notifications" class="page">') && html.include?("Notification delivery, preferences, and history are not implemented in this release.")
failures << "Settings future category placeholders are incomplete" unless %w[Accessibility Notifications Language].all? { |category| html.include?("#{category} <span>Future</span>") }
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
failures << "consolidated intelligence list is missing or duplicated" unless html.scan('id="article-list"').length == 1 && html.match?(/<section id="intelligence" class="page">.*?id="article-list"/m)
failures << "reusable workspace feed component is missing" unless app_script.include?("function renderWorkspaceIntelligenceFeed(container)") && app_script.include?("createArticleTrigger(article, true)") && app_script.include?("article.verified !== true")
failures << "Standards & Learning source content was not retained or remains routed" unless html.include?('<section id="standards" class="page">') && html.include?("<h2>Standards &amp; Learning</h2>") && !html.include?('data-page="standards"')
standards_sections = ["Standards", "Professional Organizations", "Certifications", "Training &amp; Webinars", "Conferences &amp; Events", "Publications &amp; Guidance"]
failures << "Standards & Learning sections are incomplete" unless standards_sections.all? { |section| html.include?(section) }
failures << "Standards & Learning filters are incomplete" unless %w[organization contentType certification status recommendation].all? { |filter| html.include?("data-standards-filter=\"#{filter}\"") }
failures << "IAPP AIGP ecosystem or certification coverage is incomplete" unless data.scan("IAPP AIGP").length >= 2 && html.include?("professional AI governance ecosystem") && html.include?("certification and learning pathway")
failures << "Intelligence Center does not initialize from external data" unless app_script.include?("await window.ATLAS_DATA_READY") && app_script.include?("atlasData = loadedData") && app_script.include?("renderArticles()")
failures << "drawer close, backdrop, or Escape behavior is missing" unless app_script.match?(/drawerClose\.addEventListener\("click", closeDrawer\).*drawerBackdrop\.addEventListener\("click", closeDrawer\)/m) && app_script.include?('event.key === "Escape"')
failures << "Return to Intelligence Center control is missing or inaccessible" unless html.include?('id="drawer-return" type="button" aria-label="Return to Intelligence Center">← Return to Intelligence Center</button>') && styles.include?(".drawer-return:focus-visible")
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
