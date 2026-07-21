import Link from "next/link"

export default function NotFound() {
  return (
    <div className="empty-state">
      <div>
        <p className="page-kicker">Workspace route</p>
        <h1>Module not found</h1>
        <p>The requested workspace module is not part of the approved Sprint 1 navigation.</p>
        <p><Link href="/">Return to Dashboard</Link></p>
      </div>
    </div>
  )
}
