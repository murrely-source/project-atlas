import { FoundationBanner, PageHeading } from "@/components/page-heading"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { StatusBadge } from "@/components/ui/status-badge"
import { businessDocuments, foundationActivity, priorityItems, projects } from "@/lib/workspace-data"

const metrics = [
  { label: "Named initiatives", value: String(projects.length), detail: "Charter-defined projects" },
  { label: "Business record types", value: String(businessDocuments.length), detail: "Awaiting governed sources" },
  { label: "Connected data sources", value: "0", detail: "Supabase not configured" },
  { label: "AI capabilities", value: "0", detail: "Deferred beyond Sprint 1" },
]

export function Dashboard() {
  return (
    <>
      <PageHeading kicker="Executive dashboard" title="A clear view of the work that matters." description="The Solaris Workspace foundation brings operating context together without presenting unverified business information as fact." />
      <FoundationBanner />

      <section className="metric-grid" aria-label="Workspace foundation summary">
        {metrics.map((metric) => (
          <article className="card metric-card" key={metric.label}>
            <p className="metric-label">{metric.label}</p>
            <strong className="metric-value">{metric.value}</strong>
            <span className="metric-detail">{metric.detail}</span>
          </article>
        ))}
      </section>

      <div className="content-grid">
        <Card className="span-7">
          <CardHeader title="Priority items" description="Prerequisites for governed production operation" />
          <CardContent>
            <ul className="record-list">
              {priorityItems.map((item) => (
                <li className="record-item" key={item.id}>
                  <div><h3 className="record-title">{item.title}</h3><p className="record-meta">{item.kind} · {item.context}</p></div>
                  <StatusBadge status={item.status} />
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>

        <Card className="span-5">
          <CardHeader title="Business health" description="Foundation readiness, not financial performance" />
          <CardContent>
            <ul className="record-list">
              <li className="record-item"><div><h3 className="record-title">Application foundation</h3><p className="record-meta">Shell, routes, models, and responsive system</p></div><StatusBadge status="Ready" /></li>
              <li className="record-item"><div><h3 className="record-title">Data persistence</h3><p className="record-meta">No production database is connected</p></div><StatusBadge status="Blocked" /></li>
              <li className="record-item"><div><h3 className="record-title">Access control</h3><p className="record-meta">Authentication is intentionally stubbed</p></div><StatusBadge status="Needs review" /></li>
            </ul>
          </CardContent>
        </Card>

        <Card className="span-6">
          <CardHeader title="Active project foundations" description="Projects named in the approved charter" />
          <CardContent>
            <ul className="record-list">
              {projects.map((project) => (
                <li className="record-item" key={project.id}>
                  <div><h3 className="record-title">{project.title}</h3><p className="record-meta">{project.objective}</p></div>
                  <StatusBadge status={project.status} />
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>

        <Card className="span-6">
          <CardHeader title="Recent foundation activity" description="Traceable Sprint 1 engineering outcomes" />
          <CardContent>
            <ul className="record-list">
              {foundationActivity.map((item) => (
                <li className="record-item" key={item.id}>
                  <div><h3 className="record-title">{item.title}</h3><p className="record-meta">{item.context}</p></div>
                  <StatusBadge status={item.status} />
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
      </div>
    </>
  )
}
