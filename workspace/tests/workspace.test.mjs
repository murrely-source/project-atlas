import assert from "node:assert/strict"
import { readFileSync } from "node:fs"
import test from "node:test"

const read = (path) => readFileSync(new URL(`../${path}`, import.meta.url), "utf8")
const data = read("src/lib/workspace-data.ts")
const models = read("src/lib/models.ts")
const shell = read("src/components/workspace-shell.tsx")
const moduleRoute = read("src/app/[module]/page.tsx")
const packageJson = JSON.parse(read("package.json"))

const expectedModules = ["business", "documents", "projects", "research", "knowledge", "standards", "clients", "tasks", "meetings", "calendar", "decisions", "settings"]

test("every approved primary module has one route and navigation entry", () => {
  for (const moduleId of expectedModules) {
    assert.match(models, new RegExp(`"${moduleId}"`))
    assert.match(data, new RegExp(`href: "/${moduleId}"`))
  }
  assert.match(moduleRoute, /generateStaticParams/)
})

test("the shell exposes accessible responsive navigation contracts", () => {
  assert.match(shell, /aria-label="Workspace navigation"/)
  assert.match(shell, /aria-label="Primary"/)
  assert.match(shell, /aria-controls="workspace-sidebar"/)
  assert.match(shell, /aria-expanded=\{menuOpen\}/)
  assert.match(shell, /event\.key === "Escape"/)
  assert.match(shell, /document\.body\.style\.overflow/)
})

test("Sprint 1 contains no AI or backend runtime dependencies", () => {
  const dependencyNames = Object.keys(packageJson.dependencies ?? {})
  assert.equal(dependencyNames.some((name) => /openai|supabase|ai-sdk/i.test(name)), false)
  assert.match(data, /AI explicitly deferred/)
})

test("foundation data is explicitly distinguished from live operating data", () => {
  assert.match(read("src/components/page-heading.tsx"), /not live operating data/)
  assert.match(data, /Record type established; governed source document is not connected/)
})
