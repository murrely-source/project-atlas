#!/usr/bin/env ruby
# Consolidated Intelligence Center contracts using the governed dataset.
require "json"

root = File.expand_path("..", __dir__)
items = JSON.parse(File.read(File.join(root, "app", "data", "intelligence.json"), encoding: "UTF-8")).fetch("items")
html = File.read(File.join(root, "app", "index.html"), encoding: "UTF-8")
data_script = File.read(File.join(root, "app", "data.js"), encoding: "UTF-8")
app_script = File.read(File.join(root, "app", "app.js"), encoding: "UTF-8")

abort("FAIL: governed dataset changed") unless items.length == 5 && items.all? { |item| item["verified"] == true }
abort("FAIL: Intelligence Center does not own the governed record list") unless html.match?(/<section id="intelligence" class="page">.*?id="article-list"/m)
abort("FAIL: News, learning, standards, and regulation areas are not consolidated") unless ["Knowledge &amp; Learning", "Standards &amp; Frameworks", "Laws &amp; Regulations"].all? { |label| html.include?(label) }
abort("FAIL: consolidated feed duplicates governed data") unless html.scan('id="article-list"').length == 1 && !File.exist?(File.join(root, "app", "data", "learning.json"))
abort("FAIL: record renderer does not use the one governed collection") unless app_script.include?("atlasData.articles.forEach")
abort("FAIL: unverified records are not excluded from Overview headlines") unless app_script.include?('article.verified === true).slice(0, 3)')
abort("FAIL: article triggers do not open the shared drawer") unless app_script.include?('button.addEventListener("click", () => openDrawer(article, button))')
abort("FAIL: shared source link safety contract changed") unless html.match?(/id="original-source"[^>]*target="_blank"[^>]*rel="noopener noreferrer"/)
abort("FAIL: drawer return is not context-aware") unless app_script.include?('trigger.closest(".page")?.id || "intelligence"') && app_script.include?('activatePage(drawerOriginWorkspace)')

monitored_programs = ["NIST", "ISO / ISO/IEC", "OECD", "IEEE", "W3C", "CISA", "OWASP", "EU AI Office", "UK AI Safety Institute", "Singapore IMDA / AI Verify", "IAPP", "IAPP AIGP", "ISACA", "ISACA AAIA", "PMI", "ISO/IEC 42001 training and auditor pathways", "ISO 23894 learning", "ITIL AI Governance"]
monitored_programs.each do |program|
  abort("FAIL: retained monitoring scope is missing #{program}") unless data_script.include?(program)
end

abort("FAIL: composable intelligence filters are missing") unless %w[organization contentType certification status recommendation].all? { |filter| html.include?("data-standards-filter=\"#{filter}\"") } && app_script.include?("Object.entries(activeStandardsFilters).every")
abort("FAIL: category and metadata filters are not combined") unless app_script.include?("!categoryMatches || !matchesStandardsFilters(article)")
abort("FAIL: legacy workspace information was deleted") unless %w[news human standards regulation].all? { |id| html.include?(%(<section id="#{id}" class="page)) }

puts "PASS: consolidated governed intelligence"
puts "  five records, one visible feed, retained monitoring scope, combined filters, and shared drawer validated"
