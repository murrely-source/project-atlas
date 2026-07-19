#!/usr/bin/env ruby
# Static smoke checks for the Solaris Lucerna public-site entry point.

root = File.expand_path("..", __dir__)
app = File.join(root, "app")
html = File.read(File.join(app, "index.html"), encoding: "UTF-8")
css = File.read(File.join(app, "site.css"), encoding: "UTF-8")
script = File.read(File.join(app, "site.js"), encoding: "UTF-8")
config = File.read(File.join(app, "brand-config.js"), encoding: "UTF-8")
contact_config = File.read(File.join(app, "contact-config.js"), encoding: "UTF-8")
workflow = File.read(File.join(root, ".github", "workflows", "deploy-pages.yml"), encoding: "UTF-8")
failures = []

failures << "public entry point contains inline styles or scripts" if html.match?(/<style|<script(?![^>]*src=)/)
failures << "public metadata title is missing" unless html.include?("<title>Solaris Lucerna | Illuminating Responsible Intelligence</title>")
failures << "meta description is missing" unless html.include?('name="description"') && html.include?("AI adoption, governance, risk awareness, and operational readiness")
failures << "Open Graph text metadata is incomplete" unless %w[og:type og:site_name og:title og:description].all? { |property| html.include?(%[property="#{property}"]) }
failures << "Twitter text metadata is incomplete" unless html.include?('name="twitter:card"') && html.include?('name="twitter:title"') && html.include?('name="twitter:description"')
failures << "shared public assets are not loaded" unless html.include?('href="site.css"') && html.include?('src="brand-config.js"') && html.include?('src="contact-config.js"') && html.include?('src="site.js?v=0.22.2"')
failures << "contact handler script is not cache-versioned" unless html.include?('src="site.js?v=0.22.2"')
failures << "centralized corporate identity is incomplete" unless config.include?('companyName: "Solaris Lucerna"') && config.include?('tagline: "Illuminating Responsible Intelligence"')
failures << "LENS name is not centralized" unless config.include?('name: "LENS"') && config.include?('heroCtaLabel: "Discover LENS"') && config.include?('expansion: "Lucerna Executive Navigation System"')
failures << "retired Nexus name remains user-facing" if html.match?(/\bNexus\b/i)
failures << "legacy advisory name remains user-facing" if html.match?(/Solaris AI Risk|solarisadvisoryai/i)
failures << "homepage sections are incomplete" unless %w[home about perspective solutions lens resources contact].all? { |id| html.include?(%[id="#{id}"]) }
failures << "educational narrative does not precede services" unless html.index('id="perspective"') < html.index('id="solutions"')
failures << "Project Aurora narrative is incomplete" unless html.include?("next chapter in a much longer human story") && html.include?("Governance is how organizations make those decisions visible")
failures << "approved homepage calls to action are missing" unless html.include?("Explore Our Solutions") && html.include?('href="#lens" data-product-cta>Discover LENS</a>') && script.include?('populateText("[data-product-cta]", site.product.heroCtaLabel)')
failures << "secondary Hero CTA is not a single text node" if html.match?(/data-product-cta[^>]*>[^<]*<span/)
failures << "secondary Hero CTA accessible name is overridden" if html.match?(/<a[^>]*data-product-cta[^>]*aria-label=/)
failures << "product naming is duplicated outside the approved fallback" unless html.scan(/\bLENS\b/).length == 1 && !html.include?("Lucerna Executive Navigation System")
failures << "LENS oversight limitation is missing" unless html.include?("does not replace legal, technical, governance, or executive judgment")
failures << "resource placeholders are not governed" unless html.scan("Coming Soon").length >= 3 && !html.match?(/lorem ipsum/i)
failures << "production contact form is incomplete" unless html.include?('<form class="contact-form" id="contact-form" novalidate>') && %w[fullName company email phone subject message].all? { |name| html.include?(%[name="#{name}"]) }
failures << "contact endpoint is not centralized" unless contact_config.scan(/https:\/\/script\.google\.com\/macros\/s\/[A-Za-z0-9_-]+\/exec/).length == 1 && !html.include?("AKfycbw30") && !script.include?("AKfycbw30")
failures << "Turnstile frontend configuration is incomplete" unless contact_config.include?('turnstileSiteKey: "0x4AAAAAAD5JTPEstTe-ZHcG"') && html.include?("https://challenges.cloudflare.com/turnstile/v0/api.js") && script.include?("window.turnstile.render")
failures << "contact request does not use preflight-safe JSON transport" unless script.include?('"Content-Type": "text/plain;charset=UTF-8"') && script.include?("body: JSON.stringify(payload)") && script.include?('redirect: "follow"')
failures << "connectivity probe could be mistaken for delivery" unless script.include?('result.status !== "success"') && !script.include?('result.status === "ok"')
failures << "contact success message is incorrect" unless html.include?("Thank you. Your message has been received. We'll be in touch shortly.")
failures << "temporary connectivity page is exposed in production navigation" if html.include?("contact-connectivity-test.html") || config.include?("contact-connectivity-test.html")
failures << "private contact values are exposed in public files" if [html, script, config, contact_config].any? { |content| content.match?(/TURNSTILE_SECRET_KEY|CONTACT_RECIPIENT|CONTACT_CC/) }
footer = html[/<footer class="site-footer">(.*?)<\/footer>/m, 1].to_s
failures << "footer branding remains duplicated" if footer.match?(/data-company-name|data-company-tagline|footer-brand/)
failures << "footer navigation remains duplicated" if footer.match?(/<nav|data-primary-navigation|Home|Solutions|LENS|Resources|About|Contact/)
failures << "simplified footer statement is incomplete" unless footer.include?("© 2026 Solaris Lucerna.") && footer.include?("Responsible intelligence supports—and does not replace—professional judgment.")
failures << "footer divider or centered layout is missing" unless css.match?(/\.site-footer \{[^}]*border-top: 1px solid var\(--border\);/) && css.match?(/\.footer-content \{[^}]*align-items: center;[^}]*justify-content: center;/) && css.match?(/\.site-footer p \{[^}]*text-align: center;/)
hero_asset = File.join(app, "assets", "brand", "hero-sunrise.png")
failures << "approved hero artwork is missing" unless File.file?(hero_asset) && css.include?('url("assets/brand/hero-sunrise.png")')
failures << "temporary hero placeholder remains" if html.match?(/Production asset pending|data-required-asset|art-placement/)
failures << "hero artwork remains a framed image component" if html.include?("hero-art-placeholder") || html.include?('src="assets/brand/hero-sunrise.png"') || css.include?(".hero-art-placeholder")
failures << "hero background does not match the artwork's deep navy edge" unless css.include?("background-color: #000310;")
hero_rule = css[/\.hero \{([^}]*)\}/, 1].to_s
failures << "hero artwork is modified by a dimming treatment" if hero_rule.match?(/linear-gradient|opacity|filter|background-blend-mode/) || css.include?(".hero::before")
failures << "Poppins and Montserrat design families are missing" unless css.include?('--font-heading: Poppins') && css.include?('--font-body: Montserrat')
failures << "WCAG focus treatment is missing" unless css.include?(":focus-visible") && html.include?("Skip to main content")
failures << "reduced-motion treatment is missing" unless css.include?("prefers-reduced-motion: reduce")
failures << "legacy Nexus preview was deleted" unless File.file?(File.join(app, "nexus-preview.html")) && File.file?(File.join(app, "data", "intelligence.json"))
failures << "GitHub Pages no longer publishes only app/" unless workflow.include?("path: ./app")

%w[site.css brand-config.js contact-config.js site.js].each do |path|
  failures << "missing public asset: #{path}" unless File.file?(File.join(app, path))
end

unless failures.empty?
  failures.each { |failure| warn "FAIL: #{failure}" }
  exit 1
end

puts "PASS: Solaris Lucerna public-site smoke checks"
puts "  centralized identity, homepage sections, metadata, asset governance, and legacy preservation validated"
