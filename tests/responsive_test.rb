#!/usr/bin/env ruby
# Structural and behavioral contracts for ECR-004 responsive layout.

root = File.expand_path("..", __dir__)
html = File.read(File.join(root, "app/index.html"), encoding: "UTF-8")
css = File.read(File.join(root, "app/styles.css"), encoding: "UTF-8")
script = File.read(File.join(root, "app/app.js"), encoding: "UTF-8")
failures = []

failures << "320px minimum viewport contract is missing" unless css.include?("html { min-width: 320px; }")
failures << "tablet/mobile breakpoint is missing" unless css.include?("@media(max-width:767px)")
failures << "phone breakpoint is missing" unless css.include?("@media(max-width:480px)")
failures << "fluid Overview sections are missing" unless css.include?(".overview-sections { display: grid; gap: 14px; }")
failures << "mobile Overview heading layout is missing" unless css.match?(/@media\(max-width:767px\).*?\.overview-section-heading \{ align-items: stretch; flex-direction: column; \}/m)
failures << "page-level horizontal overflow protection is missing" unless css.match?(/body \{[^}]*overflow-x: hidden;/)
failures << "accessible mobile menu control is missing" unless html.include?('id="menu-toggle" type="button" aria-expanded="false" aria-controls="workspace-navigation"')
failures << "mobile navigation landmark is missing" unless html.include?('id="workspace-navigation" aria-label="Workspace navigation"') && html.include?('aria-label="Solaris Nexus workspaces"')
failures << "mobile close or backdrop control is missing" unless html.include?('id="menu-close"') && html.include?('id="nav-backdrop"')
failures << "mobile menu open contract is missing" unless script.include?('workspaceNavigation.classList.add("is-open")') && script.include?('menuToggle.setAttribute("aria-expanded", "true")')
failures << "mobile menu close contract is missing" unless script.include?('workspaceNavigation.classList.remove("is-open")') && script.include?('menuToggle.setAttribute("aria-expanded", "false")')
failures << "mobile menu focus return is missing" unless script.include?("menuToggle.focus()")
failures << "mobile Escape close is missing" unless script.match?(/event\.key === "Escape" && mobileMenuOpen.*?closeMobileMenu\(\)/m)
failures << "mobile backdrop close is missing" unless script.include?('navBackdrop.addEventListener("click", () => closeMobileMenu())')
failures << "workspace selection does not close mobile navigation" unless script.match?(/openPage\(item\.dataset\.page\);\s+closeMobileMenu\(\);/)
failures << "mobile navigation scroll lock is missing" unless css.include?("body.nav-open { overflow: hidden; }")
table_count = html.scan("<table>").length
scroll_count = html.scan('class="table-scroll" role="region" aria-label="Scrollable data table" tabindex="0"').length
failures << "all retained tables must have accessible contained scrolling" unless table_count.positive? && scroll_count == table_count
failures << "wide table data may be truncated" unless css.include?("table { width: 100%; min-width: 560px;") && css.include?(".table-scroll { max-width: 100%; overflow-x: auto;")
failures << "mobile drawer width contract is missing" unless css.match?(/@media\(max-width:767px\).*?\.intelligence-drawer \{ width: 100vw; \}/m)
failures << "drawer return touch target is undersized" unless css.match?(/\.drawer-return \{[^}]*min-height: 44px;/)
failures << "critical touch targets are below the practical target" unless css.include?(".settings-theme-choice") && css.include?(".menu-toggle") && css.scan("min-height: 44px").length >= 5
failures << "reduced-motion navigation contract is missing" unless css.match?(/prefers-reduced-motion:reduce.*?\.shell > aside/m)
failures << "theme compatibility contract is missing" unless css.include?(':root[data-theme="light"]') && html.include?('data-theme-choice="light"')
failures << "responsive Settings layout is missing" unless css.match?(/@media\(max-width:767px\).*?\.settings-layout \{ grid-template-columns: 1fr; \}/m) && css.match?(/@media\(max-width:480px\).*?\.setting-row \{ align-items: stretch; flex-direction: column; \}/m)
failures << "obsolete global search layout remains" if css.match?(/global-search|search-field-icon|#global-search-input/)
failures << "header tools leave desktop space or hide the mobile menu" unless css.include?(".header-tools { display: none; }") && css.match?(/@media\(max-width:767px\).*?\.header-tools \{ display: flex; width: 100%; align-items: center; \}/m)
failures << "Solaris Labs corporate lockup lacks responsive sizing" unless css.match?(/@media\(max-width:767px\).*?\.brand-lockup \{ width: 310px; min-width: 0; \}/m) && css.match?(/@media\(max-width:480px\).*?\.brand-lockup \{ width: min\(100%,265px\); \}/m)
failures << "theme lockups do not retain proportions" unless html.scan('class="brand-lockup-image').length == 2 && css.include?(".brand-lockup-image { display: block; width: 100%; height: auto; object-fit: contain; }")
failures << "lockup sizing may clip narrow viewports" unless css.include?(".brand-lockup { width: min(100%,265px); }")
failures << "Intelligence Center desktop filter layout is missing" unless css.include?(".standards-filter-grid { display: grid; grid-template-columns: repeat(5,minmax(0,1fr));")
failures << "Intelligence Center filter and reference layouts are not responsive" unless css.match?(/@media\(max-width:1100px\).*?\.standards-filter-grid \{ grid-template-columns: repeat\(2,minmax\(0,1fr\)\); \}/m) && css.match?(/@media\(max-width:767px\).*?\.standards-filter-grid, \.standards-section-grid \{ grid-template-columns: 1fr; \}/m)
failures << "Intelligence Center filters are not touch friendly" unless css.match?(/\.standards-filter-grid select \{[^}]*min-height: 44px;/)

unless failures.empty?
  failures.each { |failure| warn "FAIL: #{failure}" }
  exit 1
end

puts "PASS: ECR-004 responsive contracts"
puts "  fluid Overview sections and responsive Intelligence Center layouts validated"
puts "  mobile navigation open/close/focus/Escape/backdrop/selection contracts validated"
puts "  #{table_count} tables retain all data in accessible contained scroll regions"
