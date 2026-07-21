export function PageHeading({ kicker, title, description }: { kicker: string; title: string; description: string }) {
  return (
    <header className="page-heading">
      <p className="page-kicker">{kicker}</p>
      <h1>{title}</h1>
      <p className="page-description">{description}</p>
    </header>
  )
}

export function FoundationBanner() {
  return (
    <div className="foundation-banner" role="note">
      Sprint 1 foundation records establish structure only. They are not live operating data and do not assert business, client, standards, or project status.
    </div>
  )
}
