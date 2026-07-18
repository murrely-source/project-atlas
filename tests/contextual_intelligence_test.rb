#!/usr/bin/env ruby
# Preservation contracts for the governed intelligence and legacy Nexus preview.
require "json"

root = File.expand_path("..", __dir__)
dataset = JSON.parse(File.read(File.join(root, "app", "data", "intelligence.json"), encoding: "UTF-8"))
legacy_html = File.read(File.join(root, "app", "nexus-preview.html"), encoding: "UTF-8")
data_script = File.read(File.join(root, "app", "data.js"), encoding: "UTF-8")
app_script = File.read(File.join(root, "app", "app.js"), encoding: "UTF-8")
items = dataset.fetch("items")

abort("FAIL: governed intelligence records changed") unless items.length == 5 && items.all? { |item| item["verified"] == true }
abort("FAIL: governed loader was removed") unless data_script.include?("validateIntelligence") && data_script.include?("normalizeArticle")
abort("FAIL: legacy entry point no longer loads governed data") unless legacy_html.include?('src="data.js"') && legacy_html.include?('src="app.js"')
abort("FAIL: shared intelligence drawer was removed") unless legacy_html.include?('role="dialog" aria-modal="true"') && app_script.include?("openDrawer")
abort("FAIL: safe source-link behavior changed") unless legacy_html.include?('target="_blank" rel="noopener noreferrer"')
abort("FAIL: governed intelligence leaked into public homepage") if File.read(File.join(root, "app", "index.html"), encoding: "UTF-8").include?(items.first.fetch("title"))

puts "PASS: governed intelligence and legacy Nexus preview preserved"
puts "  five verified records, loader, drawer, and safe source behavior retained outside the public homepage"
