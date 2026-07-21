import type { RecordStatus } from "@/lib/models"

const statusClass: Record<RecordStatus, string> = {
  Foundation: "status-foundation",
  "Needs review": "status-review",
  Ready: "status-ready",
  Blocked: "status-blocked",
}

export function StatusBadge({ status }: { status: RecordStatus }) {
  return <span className={`status-badge ${statusClass[status]}`}>{status}</span>
}
