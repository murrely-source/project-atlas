#!/usr/bin/env ruby
# Responsive contracts for the Solaris Lucerna public website.

root = File.expand_path("..", __dir__)
html = File.read(File.join(root, "app", "index.html"), encoding: "UTF-8")
css = File.read(File.join(root, "app", "site.css"), encoding: "UTF-8")
script = File.read(File.join(root, "app", "site.js"), encoding: "UTF-8")
failures = []

failures << "viewport metadata is missing" unless html.include?('name="viewport" content="width=device-width, initial-scale=1"')
failures << "320px minimum layout contract is missing" unless css.include?("html { min-width: 320px;")
failures << "page-level overflow protection is missing" unless css.match?(/body \{[^}]*overflow-x: hidden;/)
failures << "fluid page container is missing" unless css.include?("width: min(100% - 40px, var(--page-width))")
failures << "tablet layout breakpoint is missing" unless css.include?("@media (max-width: 980px)")
failures << "mobile layout breakpoint is missing" unless css.include?("@media (max-width: 767px)")
failures << "small-phone layout breakpoint is missing" unless css.include?("@media (max-width: 420px)")
failures << "LENS layout does not collapse on tablet" unless css.match?(/@media \(max-width: 980px\).*?\.lens-layout \{ grid-template-columns: 1fr; \}/m)
failures << "content grids do not collapse on mobile" unless css.match?(/@media \(max-width: 767px\).*?\.solution-grid, \.resource-grid \{ grid-template-columns: 1fr; \}/m)
failures << "narrative layout does not collapse on mobile" unless css.match?(/@media \(max-width: 767px\).*?\.perspective-layout \{ grid-template-columns: 1fr; \}/m)
mobile_css = css[/@media \(max-width: 767px\) \{(.*?)\n\}/m, 1].to_s
mobile_overlay_rule = mobile_css[/\.mobile-nav-overlay \{([^}]*)\}/, 1].to_s
failures << "desktop navigation is not hidden at the mobile breakpoint" unless mobile_css.include?(".site-navigation { display: none; }")
failures << "mobile navigation overlay is missing" unless mobile_overlay_rule.include?("position: fixed") && mobile_overlay_rule.include?("inset: 0") && mobile_overlay_rule.include?("width: 100%") && mobile_overlay_rule.include?("height: 100vh") && mobile_overlay_rule.include?("overflow-y: auto")
failures << "mobile navigation hidden state is missing" unless mobile_css.include?(".mobile-nav-overlay[hidden] { display: none; }")
failures << "mobile scroll lock is missing" unless css.include?("body.nav-open { position: fixed; width: 100%; overflow: hidden; }") && script.include?("window.scrollTo(0, lockedScrollPosition)")
failures << "mobile menu does not close after selection" unless script.match?(/event\.target\.closest\("a"\).*?closeMenu\(\)/m)
failures << "touch targets are undersized" unless css.include?("min-height: 44px") && css.include?("min-height: 48px") && css.include?("min-height: 52px")
failures << "hero does not use a stable full-width layout" unless css.match?(/\.hero \{[^}]*width: 100%;[^}]*min-height: clamp\(40rem, calc\(100svh - var\(--header-height\)\), 56rem\);[^}]*display: grid;/)
hero_rule = css[/\.hero \{([^}]*)\}/, 1].to_s
failures << "hero artwork does not use a stable focal treatment" unless hero_rule.include?('background-image: url("assets/brand/hero-sunrise.png");') && hero_rule.include?("background-position: center bottom;") && hero_rule.include?("background-size: cover;")
failures << "hero artwork is dimmed or filtered" if hero_rule.match?(/linear-gradient|opacity|filter|background-blend-mode/)
failures << "hero does not use a coordinated two-region layout" unless css.match?(/\.hero-layout \{[^}]*display: grid;[^}]*grid-template-rows: auto auto;[^}]*align-content: start;[^}]*gap: clamp\(1\.75rem, 4vh, 3rem\);[^}]*padding-block: clamp\(4rem, 8vh, 6rem\);/)
failures << "hero heading does not preserve a reliable two-line structure" unless html.scan('class="hero-title-line"').length == 2 && script.include?("function renderHeroTitle()") && script.include?('line.className = "hero-title-line"') && css.match?(/\.hero-title-line \{[^}]*display: block;[^}]*max-inline-size: 100%;/) && !css.match?(/\.hero-title-line \{[^}]*white-space: nowrap;/)
failures << "hero heading and support groups are incomplete" unless html.match?(/<div class="page-container hero-layout">\s*<div class="hero-heading">.*?<\/div>\s*<div class="hero-support">\s*<p class="hero-intro">.*?<div class="button-group">/m)
failures << "hero support is not confined to its readable image region" unless css.match?(/\.hero-support \{[^}]*width: min\(100%, 32rem\);[^}]*display: grid;[^}]*gap: clamp\(1\.5rem, 3vh, 2rem\);/)
failures << "hero desktop calls to action can wrap unpredictably" unless css.include?(".hero-support .button-group { flex-wrap: nowrap; }")
failures << "forced-colors Hero fallback is missing" unless css.match?(/@media \(forced-colors: active\).*?\.hero h1 \{ background: none; color: CanvasText; \}/m)
failures << "desktop navigation targets are undersized" unless css.match?(/\.wordmark \{[^}]*min-height: 44px;/) && css.match?(/\.site-navigation a \{[^}]*min-height: 44px;/)
failures << "obsolete Hero implementation remains" if html.include?('class="hero-copy"') || css.include?(".hero-copy") || css.include?("@media (min-width: 981px)") || css.include?("grid-template-columns: minmax(0, 48rem) minmax(0, 1fr)") || css.include?(".hero { min-height: auto;") || css.include?(".hero::before")
failures << "simplified footer is not centered responsively" unless css.match?(/\.footer-content \{[^}]*display: flex;[^}]*align-items: center;[^}]*justify-content: center;/) && css.match?(/\.site-footer p span \{ display: block; \}/)

[1280, 1366, 1440, 1600, 1728, 1920, 2560].each do |viewport_width|
  container_width = [viewport_width - 40, 1200].min
  container_start = (viewport_width - container_width) / 2.0
  support_end = container_start + [container_width, 512].min
  failures << "hero support crosses the sunrise center at #{viewport_width}px" unless support_end < viewport_width / 2.0
end

unless failures.empty?
  failures.each { |failure| warn "FAIL: #{failure}" }
  exit 1
end

puts "PASS: Solaris Lucerna responsive contracts"
puts "  Hero geometry validated at 1280, 1366, 1440, 1600, 1728, 1920, and 2560px"
puts "  tablet, mobile navigation, grids, touch targets, and footer behavior validated"
