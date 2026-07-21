import { FoundationBanner, PageHeading } from "@/components/page-heading"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { StatusBadge } from "@/components/ui/status-badge"
import type { WorkspaceModule } from "@/lib/models"
import { businessDocuments, priorityItems, projects } from "@/lib/workspace-data"

function DocumentTable() {
  return (
    <div className="table-wrap">
      <table className="data-table">
        <caption>Business document foundation records</caption>
        <thead><tr><th scope="col">Document</th><th scope="col">Version</th><th scope="col">Status</th><th scope="col">Owner</th><th scope="col">Relationships</th></tr></thead>
        <tbody>
          {businessDocuments.map((document) => (
            <tr key={document.id}>
              <td><strong>{document.title}</strong><br /><span className="muted">{document.notes}</span></td>
              <td>{document.version}</td>
              <td><StatusBadge status={document.status} /></td>
              <td>{document.owner}</td>
              <td className="muted">Not connected</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

function ProjectTable() {
  return (
    <div className="table-wrap">
      <table className="data-table">
        <caption>Project foundation records</caption>
        <thead><tr><th scope="col">Project</th><th scope="col">Objective</th><th scope="col">Status</th><th scope="col">Next milestone</th><th scope="col">Dependencies</th></tr></thead>
        <tbody>
          {projects.map((project) => (
            <tr key={project.id}>
              <td><strong>{project.title}</strong></td>
              <td>{project.objective}</td>
              <td><StatusBadge status={project.status} /></td>
              <td>{project.nextMilestone}</td>
              <td>{project.dependencies.join(", ")}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

function TaskList() {
  return (
    <ul className="record-list">
      {priorityItems.map((item) => (
        <li className="record-item" key={item.id}>
          <div><h3 className="record-title">{item.title}</h3><p className="record-meta">{item.context}</p></div>
          <StatusBadge status={item.status} />
        </li>
      ))}
    </ul>
  )
}

function SettingsFoundation() {
  const settings = [
    ["Appearance", "Dark Solaris workspace foundation; user persistence is deferred."],
    ["Accessibility", "WCAG 2.2 AA is the engineering baseline; preference controls are deferred."],
    ["Notifications", "No notification service is connected."],
    ["Language", "English is the only configured interface language."],
    ["Profile and access", "Authentication and roles await an approved Supabase design."],
  ]
  return (
    <div className="settings-list">
      {settings.map(([title, description]) => (
        <div className="setting-row" key={title}>
          <div><h2>{title}</h2><p>{description}</p></div>
          <span className="control-placeholder">Not yet configurable</span>
        </div>
      ))}
    </div>
  )
}

export function ModulePage({ module }: { module: WorkspaceModule }) {
  const isDocumentModule = module.id === "business" || module.id === "documents"
  const isProjects = module.id === "projects"
  const isTasksOrDecisions = module.id === "tasks" || module.id === "decisions"
  const isSettings = module.id === "settings"
  const hasFoundationRecords = isDocumentModule || isProjects || isTasksOrDecisions || isSettings

  return (
    <>
      <PageHeading kicker={module.kicker} title={module.title} description={module.description} />
      <FoundationBanner />
      <div className="module-grid">
        <Card>
          <CardHeader title={hasFoundationRecords ? `${module.title} foundation` : "No governed records connected"} description={module.purpose} />
          <CardContent>
            {isDocumentModule ? <DocumentTable /> : null}
            {isProjects ? <ProjectTable /> : null}
            {isTasksOrDecisions ? <TaskList /> : null}
            {isSettings ? <SettingsFoundation /> : null}
            {!hasFoundationRecords ? (
              <div className="empty-state">
                <div><h2>Structure is ready; content is governed.</h2><p>This module intentionally contains no invented records. Approved data sources and access rules must be connected before operational information appears here.</p></div>
              </div>
            ) : null}
          </CardContent>
        </Card>
        <Card>
          <CardHeader title="Module scope" description="Prepared for controlled expansion" />
          <CardContent>
            <ul className="scope-list">{module.capabilities.map((capability) => <li key={capability}>{capability}</li>)}</ul>
          </CardContent>
        </Card>
      </div>
    </>
  )
}
