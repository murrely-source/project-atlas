#!/usr/bin/env ruby
# Static smoke checks for the Solaris Lucerna public-site entry point.

root = File.expand_path("..", __dir__)
app = File.join(root, "app")
html = File.read(File.join(app, "index.html"), encoding: "UTF-8")
css = File.read(File.join(app, "site.css"), encoding: "UTF-8")
script = File.read(File.join(app, "site.js"), encoding: "UTF-8")
config = File.read(File.join(app, "brand-config.js"), encoding: "UTF-8")
workflow = File.read(File.join(root, ".github", "workflows", "deploy-pages.yml"), encoding: "UTF-8")
failures = []

failures << "public entry point contains inline styles or scripts" if html.match?(/<style|<script(?![^>]*src=)/)
failures << "public metadata title is missing" unless html.include?("<title>Solaris Lucerna | Illuminating Responsible Intelligence</title>")
failures << "meta description is missing" unless html.include?('name="description"') && html.include?("AI adoption, governance, risk awareness, and operational readiness")
failures << "Open Graph text metadata is incomplete" unless %w[og:type og:site_name og:title og:description].all? { |property| html.include?(%[property="#{property}"]) }
failures << "Twitter text metadata is incomplete" unless html.include?('name="twitter:card"') && html.include?('name="twitter:title"') && html.include?('name="twitter:description"')
failures << "shared public assets are not loaded" unless html.include?('href="site.css"') && html.include?('src="brand-config.js"') && html.include?('src="site.js"')
failures << "centralized corporate identity is incomplete" unless config.include?('companyName: "Solaris Lucerna"') && config.include?('tagline: "Illuminating Responsible Intelligence"')
failures << "LENS name is not centralized" unless config.include?('name: "LENS"') && config.include?('expansion: "Lucerna Executive Navigation System"')
failures << "retired Nexus name remains user-facing" if html.match?(/\bNexus\b/i)
failures << "legacy advisory name remains user-facing" if html.match?(/Solaris AI Risk|solarisadvisoryai/i)
failures << "homepage sections are incomplete" unless %w[home about solutions lens resources contact].all? { |id| html.include?(%[id="#{id}"]) }
failures << "approved homepage calls to action are missing" unless html.include?("Explore Our Solutions") && html.include?("Discover <span data-product-name></span>")
failures << "product naming is duplicated outside centralized configuration" if html.match?(/\bLENS\b|Lucerna Executive Navigation System/)
failures << "LENS oversight limitation is missing" unless html.include?("does not replace legal, technical, governance, or executive judgment")
failures << "resource placeholders are not governed" unless html.scan("Coming Soon").length >= 4 && !html.match?(/lorem ipsum/i)
failures << "contact preview collects data without an approved integration" if html.match?(/<form|<input|<textarea|<select/)
failures << "hero asset handoff is missing" unless html.include?('data-required-asset="assets/brand/solaris-lucerna-hero-approved.webp"') && File.file?(File.join(app, "assets", "brand", "README.md"))
failures << "unapproved hero image is referenced" if html.match?(/<img|background-image/i)
failures << "Poppins and Montserrat design families are missing" unless css.include?("font-family: Poppins") && css.include?("font-family: Montserrat")
failures << "WCAG focus treatment is missing" unless css.include?(":focus-visible") && html.include?("Skip to main content")
failures << "reduced-motion treatment is missing" unless css.include?("prefers-reduced-motion: reduce")
failures << "legacy Nexus preview was deleted" unless File.file?(File.join(app, "nexus-preview.html")) && File.file?(File.join(app, "data", "intelligence.json"))
failures << "GitHub Pages no longer publishes only app/" unless workflow.include?("path: ./app")

%w[site.css brand-config.js site.js].each do |path|
  failures << "missing public asset: #{path}" unless File.file?(File.join(app, path))
end

unless failures.empty?
  failures.each { |failure| warn "FAIL: #{failure}" }
  exit 1
end

puts "PASS: Solaris Lucerna public-site smoke checks"
puts "  centralized identity, homepage sections, metadata, asset governance, and legacy preservation validated"
